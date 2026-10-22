//
//  CIOJourneyReport.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/// The result of checking one parameter rule
struct CIOJourneyFinding {

    enum Severity {
        case passed
        case warning
        case error
        /// The rule depends on an earlier step that has no event, so it couldn't be checked
        case notVerified
    }

    let severity: Severity
    let param: String?
    let message: String
}

struct CIOJourneyStepResult {

    enum Order {
        case inOrder
        /// Fired before an earlier step had fired, so it wasn't accepted
        case outOfOrder
        /// Not fired yet, while recording
        case pending
        /// Never fired before recording stopped
        case missing
    }

    enum Status {
        case passed
        case warning
        case paramIssues
        case outOfOrder
        case rejected
        case missing
        case pending
    }

    let index: Int
    let step: CIOJourneyStep
    let event: CIODebugEvent?
    let order: Order
    let findings: [CIOJourneyFinding]

    var errorCount: Int {
        return self.findings.filter { $0.severity == .error }.count
    }

    var warningCount: Int {
        return self.findings.filter { $0.severity == .warning }.count
    }

    var status: Status {
        switch self.order {
        case .pending:
            return .pending
        case .missing:
            return .missing
        case .inOrder, .outOfOrder:
            break
        }
        if let event = self.event, !event.succeeded {
            return .rejected
        }
        if self.order == .outOfOrder {
            return .outOfOrder
        }
        if self.errorCount > 0 {
            return .paramIssues
        }
        return self.warningCount > 0 ? .warning : .passed
    }

    var statusDescription: String {
        switch self.status {
        case .passed:
            return "Valid, in order"
        case .warning:
            return "Valid, \(self.warningCount) warning\(self.warningCount == 1 ? "" : "s")"
        case .paramIssues:
            return "\(self.errorCount) parameter issue\(self.errorCount == 1 ? "" : "s")"
        case .outOfOrder:
            return "Out of order, fired before an earlier step"
        case .rejected:
            return "Rejected by the API (\(self.event?.statusDescription ?? "failed"))"
        case .missing:
            return "Missing, never fired"
        case .pending:
            return "Waiting"
        }
    }
}

/// A recorded event that didn't match a journey step
struct CIOJourneyExtraEvent {

    enum Kind {
        /// The event matched a step that had already fired
        case duplicate(stepIndex: Int)
        /// The event belongs to a later step and fired while an earlier step was expected
        case outOfOrder(stepIndex: Int, expectedStepIndex: Int)
        /// The event isn't part of the journey
        case unexpected
    }

    let event: CIODebugEvent
    let kind: Kind
}

struct CIOJourneyReport {

    enum Verdict {
        case inProgress
        case passed
        case passedWithWarnings
        case failed
    }

    let journey: CIOJourney
    let steps: [CIOJourneyStepResult]
    let extraEvents: [CIOJourneyExtraEvent]

    /// False while recording; steps that haven't fired are then pending rather than missing
    let isFinal: Bool

    /// Steps accepted in order
    var completedStepCount: Int {
        return self.steps.filter { $0.order == .inOrder }.count
    }

    /// The step the journey is waiting for, nil once every step has fired in order
    var nextStep: CIOJourneyStepResult? {
        return self.nextSteps.first
    }

    /// Every step the journey accepts next. More than one when steps share an `order` and can fire in either order.
    var nextSteps: [CIOJourneyStepResult] {
        let orders = CIOJourneyValidator.orders(of: self.journey)
        guard let current = self.steps.filter({ $0.order != .inOrder }).map({ orders[$0.index] }).min() else { return [] }
        return self.steps.filter { $0.order != .inOrder && orders[$0.index] == current }
    }

    var outOfOrderEvents: [CIOJourneyExtraEvent] {
        return self.extraEvents.filter { if case .outOfOrder = $0.kind { return true } else { return false } }
    }

    var duplicates: [CIOJourneyExtraEvent] {
        return self.extraEvents.filter { if case .duplicate = $0.kind { return true } else { return false } }
    }

    var verdict: CIOJourneyReport.Verdict {
        guard self.isFinal else { return .inProgress }
        let failing: [CIOJourneyStepResult.Status] = [.missing, .rejected, .outOfOrder, .paramIssues]
        if self.steps.contains(where: { failing.contains($0.status) }) || !self.outOfOrderEvents.isEmpty {
            return .failed
        }
        if self.steps.contains(where: { $0.status == .warning }) || !self.duplicates.isEmpty {
            return .passedWithWarnings
        }
        return .passed
    }

    var verdictDescription: String {
        switch self.verdict {
        case .inProgress:
            return "Recording"
        case .passed:
            return "Passed"
        case .passedWithWarnings:
            return "Passed with warnings"
        case .failed:
            return "Failed"
        }
    }

    var summary: String {
        var counts: [String] = []
        let valid = self.steps.filter { $0.status == .passed || $0.status == .warning }.count
        counts.append("\(valid) valid")
        for (status, label) in [(CIOJourneyStepResult.Status.paramIssues, "with parameter issues"), (.rejected, "rejected"), (.missing, "missing"), (.pending, "waiting")] {
            let count = self.steps.filter { $0.status == status }.count
            if count > 0 {
                counts.append("\(count) \(label)")
            }
        }
        if !self.outOfOrderEvents.isEmpty {
            counts.append("\(self.outOfOrderEvents.count) out of order")
        }
        if !self.duplicates.isEmpty {
            counts.append("\(self.duplicates.count) duplicate")
        }
        return counts.joined(separator: " · ")
    }
}

extension CIOJourneyReport: CustomStringConvertible {

    var description: String {
        var lines = ["Journey: \(self.journey.name) (\(self.journey.id))", "Verdict: \(self.verdictDescription)   \(self.summary)", ""]
        for result in self.steps {
            let marker: String
            switch result.status {
            case .passed: marker = "✓"
            case .warning: marker = "!"
            case .pending: marker = "·"
            default: marker = "✗"
            }
            let sequence = result.event.map { " #\($0.sequence)" } ?? ""
            lines.append("\(result.index + 1) \(marker) \(result.step.event)\(sequence) · \(result.statusDescription)")
            for finding in result.findings where finding.severity != .passed {
                lines.append("    \(CIOJourneyReport.label(for: finding.severity)) \(finding.message)")
            }
        }
        if !self.extraEvents.isEmpty {
            lines.append("")
            lines.append("Other events")
            for extra in self.extraEvents {
                switch extra.kind {
                case .duplicate(let stepIndex):
                    lines.append("  DUPLICATE #\(extra.event.sequence) \(extra.event.name.rawValue) (step \(stepIndex + 1) already fired)")
                case .outOfOrder(let stepIndex, let expectedStepIndex):
                    lines.append("  OUT OF ORDER #\(extra.event.sequence) \(extra.event.name.rawValue) is step \(stepIndex + 1), fired while step \(expectedStepIndex + 1) (\(self.journey.steps[expectedStepIndex].event)) was expected")
                case .unexpected:
                    lines.append("  NOT IN JOURNEY #\(extra.event.sequence) \(extra.event.name.rawValue)")
                }
            }
        }
        return lines.joined(separator: "\n")
    }

    static func label(for severity: CIOJourneyFinding.Severity) -> String {
        switch severity {
        case .passed: return "ok"
        case .warning: return "warning"
        case .error: return "error"
        case .notVerified: return "not verified"
        }
    }
}
