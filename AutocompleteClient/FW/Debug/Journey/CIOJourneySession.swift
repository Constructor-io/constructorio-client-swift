//
//  CIOJourneySession.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/// Records the events of one journey run, from Start to Stop, and keeps the latest report. Main thread only.
final class CIOJourneySession {

    static let shared = CIOJourneySession()

    static let didChangeNotification = Notification.Name("CIOJourneySessionDidChange")

    private(set) var journey: CIOJourney?
    private(set) var isRecording = false
    private(set) var startedAt: Date?
    private(set) var events: [CIODebugEvent] = []
    private(set) var report: CIOJourneyReport?

    func start(_ journey: CIOJourney) {
        self.journey = journey
        self.isRecording = true
        self.startedAt = Date()
        self.events = []
        self.report = CIOJourneyValidator.validate(journey: journey, events: [], isFinal: false)
        print(Constants.Logging.debugMessage("Recording started · \(journey.id) · \(journey.steps.count) steps"))
        self.notifyChange()
    }

    @discardableResult
    func stop() -> CIOJourneyReport? {
        guard self.isRecording, let journey = self.journey else { return self.report }
        self.isRecording = false
        let report = CIOJourneyValidator.validate(journey: journey, events: self.events, isFinal: true)
        self.report = report
        print(Constants.Logging.debugMessage("Recording stopped\n\(report)"))
        self.notifyChange()
        return report
    }

    /// Clears the last report
    func reset() {
        self.journey = nil
        self.isRecording = false
        self.startedAt = nil
        self.events = []
        self.report = nil
        self.notifyChange()
    }

    func record(_ event: CIODebugEvent) {
        // Responses can arrive after Stop for events fired before it, so only keep events fired while recording
        guard self.isRecording, let journey = self.journey, let startedAt = self.startedAt, event.firedAt >= startedAt else { return }
        self.events.append(event)
        let report = CIOJourneyValidator.validate(journey: journey, events: self.events, isFinal: false)
        self.report = report
        let isThisEvent = { (other: CIODebugEvent?) in other?.sequence == event.sequence && other?.firedAt == event.firedAt }
        if let result = report.steps.first(where: { $0.order == .inOrder && isThisEvent($0.event) }) {
            print(Constants.Logging.debugMessage("Journey step \(result.index + 1)/\(journey.steps.count) \(result.step.event) · \(result.statusDescription)"))
        } else if let extra = report.extraEvents.last(where: { isThisEvent($0.event) }) {
            switch extra.kind {
            case .outOfOrder(let stepIndex, let expectedStepIndex):
                print(Constants.Logging.debugMessage("Journey · \(event.name.rawValue) is OUT OF ORDER: it's step \(stepIndex + 1), but step \(expectedStepIndex + 1) (\(journey.steps[expectedStepIndex].event)) is expected. Not accepted."))
            case .duplicate:
                print(Constants.Logging.debugMessage("Journey · \(event.name.rawValue) is a duplicate"))
            case .unexpected:
                print(Constants.Logging.debugMessage("Journey · \(event.name.rawValue) isn't part of \(journey.id)"))
            }
        }
        self.notifyChange()
    }

    private func notifyChange() {
        NotificationCenter.default.post(name: CIOJourneySession.didChangeNotification, object: self)
    }
}
