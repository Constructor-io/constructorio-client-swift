//
//  CIOJourneyValidator.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/// Checks recorded events against a journey's fixed sequence and parameter rules. Pure: the same journey and events
/// always give the same report, so it's re-run on every new event while recording.
enum CIOJourneyValidator {

    // Values the SDK fills in when the caller didn't pass one, so they count as missing
    static let placeholderValues: Set<String> = ["TERM_UNKNOWN", "Not Available"]

    static func validate(journey: CIOJourney, events: [CIODebugEvent], isFinal: Bool) -> CIOJourneyReport {
        // Responses arrive out of order, so order by when each tracking method was called
        let ordered = events.enumerated().sorted { lhs, rhs in
            lhs.element.firedAt == rhs.element.firedAt ? lhs.offset < rhs.offset : lhs.element.firedAt < rhs.element.firedAt
        }.map { $0.element }

        // The sequence is fixed, in groups of steps that share an `order`. Only steps in the current group are accepted,
        // in any order among themselves; the next group opens once every step in the current one has fired. An event
        // for a later group is rejected as out of order and the journey keeps waiting for the current group.
        let orders = self.orders(of: journey)
        let groups = Array(Set(orders)).sorted()

        var matched: [Int: CIODebugEvent] = [:]
        var earlyEvents: [Int: CIODebugEvent] = [:]
        var extraEvents: [CIOJourneyExtraEvent] = []
        var groupIndex = 0

        for event in ordered where event.name != .sessionStart {
            let candidates = journey.steps.indices.filter { self.step(journey.steps[$0], matches: event) }
            guard !candidates.isEmpty else {
                extraEvents.append(CIOJourneyExtraEvent(event: event, kind: .unexpected))
                continue
            }
            let currentOrder = groupIndex < groups.count ? groups[groupIndex] : Int.max
            // A journey can use the same event twice, so take the first step of that kind still waiting in the group
            if let index = candidates.first(where: { orders[$0] == currentOrder && matched[$0] == nil }) {
                matched[index] = event
                while groupIndex < groups.count, journey.steps.indices.filter({ orders[$0] == groups[groupIndex] }).allSatisfy({ matched[$0] != nil }) {
                    groupIndex += 1
                }
            } else if let ahead = candidates.first(where: { orders[$0] > currentOrder && matched[$0] == nil }) {
                let expected = journey.steps.indices.first { orders[$0] == currentOrder && matched[$0] == nil } ?? ahead
                extraEvents.append(CIOJourneyExtraEvent(event: event, kind: .outOfOrder(stepIndex: ahead, expectedStepIndex: expected)))
                if earlyEvents[ahead] == nil {
                    earlyEvents[ahead] = event
                }
            } else {
                let done = candidates.last(where: { matched[$0] != nil }) ?? candidates[0]
                extraEvents.append(CIOJourneyExtraEvent(event: event, kind: .duplicate(stepIndex: done)))
            }
        }

        let reachedOrder = groupIndex < groups.count ? groups[groupIndex] : Int.max
        let results = journey.steps.enumerated().map { index, step -> CIOJourneyStepResult in
            if let event = matched[index] {
                let findings = step.params.map { self.check($0, event: event, journey: journey, matched: matched) }
                return CIOJourneyStepResult(index: index, step: step, event: event, order: .inOrder, findings: findings)
            }
            // Fired too early and never again in its place
            if let early = earlyEvents[index], isFinal || orders[index] < reachedOrder {
                return CIOJourneyStepResult(index: index, step: step, event: early, order: .outOfOrder, findings: [])
            }
            return CIOJourneyStepResult(index: index, step: step, event: nil, order: isFinal ? .missing : .pending, findings: [])
        }

        return CIOJourneyReport(journey: journey, steps: results, extraEvents: extraEvents, isFinal: isFinal)
    }

    /// Each step's position in the sequence: its `order`, or its position in the list when it has none
    static func orders(of journey: CIOJourney) -> [Int] {
        return journey.steps.enumerated().map { index, step in step.order ?? index + 1 }
    }

    private static func step(_ step: CIOJourneyStep, matches event: CIODebugEvent) -> Bool {
        guard step.eventName == event.name else { return false }
        if let conversionType = step.conversionType {
            return event.parameterValue(for: "type") == conversionType
        }
        return true
    }

    private static func check(_ rule: CIOJourneyParamRule, event: CIODebugEvent, journey: CIOJourney, matched: [Int: CIODebugEvent]) -> CIOJourneyFinding {
        let values = event.parameterValues(for: rule.name).filter { !$0.isEmpty && !self.placeholderValues.contains($0) }
        let missingSeverity: CIOJourneyFinding.Severity = rule.required ? .error : .warning

        guard let value = values.first else {
            if !rule.required && !rule.recommended {
                return CIOJourneyFinding(severity: .passed, param: rule.name, message: "\(rule.name) not sent (optional)")
            }
            let label = rule.required ? "required" : "recommended"
            return CIOJourneyFinding(severity: missingSeverity, param: rule.name, message: rule.message.map { "\(rule.name) is \(label) but missing. \($0)" } ?? "\(rule.name) is \(label) but missing.")
        }

        if let min = rule.min {
            guard let number = Double(value), number >= min else {
                return CIOJourneyFinding(severity: .error, param: rule.name, message: "\(rule.name) is \"\(value)\", expected a number of at least \(CIOJourneyValidator.format(min)).")
            }
        }

        if let reference = rule.equals {
            switch self.referencedValues(reference, journey: journey, matched: matched) {
            case .unavailable(let reason):
                return CIOJourneyFinding(severity: .notVerified, param: rule.name, message: "\(rule.name) can't be compared: \(reason)")
            case .values(let expected):
                guard let first = expected.first else {
                    return CIOJourneyFinding(severity: .notVerified, param: rule.name, message: "\(rule.name) can't be compared: \(reference.param) wasn't sent in step \"\(reference.step)\".")
                }
                guard self.normalized(value) == self.normalized(first) else {
                    return CIOJourneyFinding(severity: .error, param: rule.name, message: rule.message.map { "\(rule.name) is \"\(value)\" but step \"\(reference.step)\" sent \"\(first)\". \($0)" } ?? "\(rule.name) is \"\(value)\" but step \"\(reference.step)\" sent \"\(first)\".")
                }
            }
        }

        if let reference = rule.in {
            switch self.referencedValues(reference, journey: journey, matched: matched) {
            case .unavailable(let reason):
                return CIOJourneyFinding(severity: .notVerified, param: rule.name, message: "\(rule.name) can't be compared: \(reason)")
            case .values(let expected):
                guard expected.map(self.normalized).contains(self.normalized(value)) else {
                    let shown = expected.prefix(3).joined(separator: ", ") + (expected.count > 3 ? " (+\(expected.count - 3))" : "")
                    return CIOJourneyFinding(severity: .error, param: rule.name, message: rule.message.map { "\(rule.name) \"\(value)\" isn't in step \"\(reference.step)\" (\(shown)). \($0)" } ?? "\(rule.name) \"\(value)\" isn't in step \"\(reference.step)\" (\(shown)).")
                }
            }
        }

        if let reference = rule.contains {
            switch self.referencedValues(reference, journey: journey, matched: matched) {
            case .unavailable(let reason):
                return CIOJourneyFinding(severity: .notVerified, param: rule.name, message: "\(rule.name) can't be compared: \(reason)")
            case .values(let expected):
                if let needed = expected.first, !values.map(self.normalized).contains(self.normalized(needed)) {
                    return CIOJourneyFinding(severity: .error, param: rule.name, message: rule.message.map { "\(rule.name) doesn't include \"\(needed)\" from step \"\(reference.step)\". \($0)" } ?? "\(rule.name) doesn't include \"\(needed)\" from step \"\(reference.step)\".")
                }
            }
        }

        let shown = values.count > 1 ? "\(values.count) values" : "\"\(value)\""
        return CIOJourneyFinding(severity: .passed, param: rule.name, message: "\(rule.name) = \(shown)")
    }

    private enum ReferencedValues {
        case values([String])
        case unavailable(String)
    }

    private static func referencedValues(_ reference: CIOJourneyParamRule.StepReference, journey: CIOJourney, matched: [Int: CIODebugEvent]) -> ReferencedValues {
        guard let index = journey.steps.firstIndex(where: { $0.id == reference.step }) else {
            return .unavailable("the journey has no step \"\(reference.step)\".")
        }
        guard let event = matched[index] else {
            return .unavailable("step \"\(reference.step)\" hasn't fired.")
        }
        return .values(event.parameterValues(for: reference.param).filter { !$0.isEmpty && !self.placeholderValues.contains($0) })
    }

    // Path values are percent-encoded and terms differ in case, so compare loosely
    private static func normalized(_ value: String) -> String {
        return (value.removingPercentEncoding ?? value).trimmingCharacters(in: .whitespaces).lowercased()
    }

    private static func format(_ number: Double) -> String {
        return number == number.rounded() ? String(Int(number)) : String(number)
    }
}
