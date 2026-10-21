//
//  CIODebugRecorder.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

class CIODebugRecorder {

    private let lock = NSLock()
    private var nextSequence = 1
    private var listeners: [CIODebugEventListener] = []

    func addListener(_ listener: CIODebugEventListener) {
        self.lock.lock()
        defer { self.lock.unlock() }
        guard !self.listeners.contains(where: { $0 === listener }) else { return }
        self.listeners.append(listener)
    }

    func removeListener(_ listener: CIODebugEventListener) {
        self.lock.lock()
        defer { self.lock.unlock() }
        self.listeners.removeAll(where: { $0 === listener })
    }

    // Captures the event at fire time so the sequence reflects the order tracking methods were called in
    func makeEvent(name: CIOTrackingEventName, request: URLRequest) -> CIODebugEvent {
        self.lock.lock()
        let sequence = self.nextSequence
        self.nextSequence += 1
        self.lock.unlock()
        return CIODebugEvent(sequence: sequence, name: name, firedAt: Date(), request: request)
    }

    func record(_ event: CIODebugEvent) {
        self.lock.lock()
        let listeners = self.listeners
        self.lock.unlock()

        DispatchQueue.main.async {
            print(Constants.Logging.debugEvent(event))
            CIODebugEventLog.shared.append(event)
            listeners.forEach { $0.didTrack(event: event) }
        }
    }
}
