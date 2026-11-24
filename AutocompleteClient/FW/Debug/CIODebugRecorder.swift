//
//  CIODebugRecorder.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Records the tracking events of a ConstructorIO instance while debug mode is enabled. It numbers the events as they are fired and, once their requests have completed, logs them and hands them to the listeners. It can be used from any thread.
 */
class CIODebugRecorder {

    /**
     A tracking event that was fired and is waiting for the outcome of its request
     */
    struct PendingEvent {
        let sequence: Int
        let name: CIOTrackingEventName
        let firedAt: Date
        let request: URLRequest
    }

    private class WeakListener {
        weak var listener: CIODebugEventListener?

        init(_ listener: CIODebugEventListener) {
            self.listener = listener
        }
    }

    private let lock = NSLock()
    private var nextSequence = 1
    private var listeners: [WeakListener] = []

    func addListener(_ listener: CIODebugEventListener) {
        self.withListeners { liveListeners, listeners in
            if !liveListeners.contains(where: { $0 === listener }) {
                listeners.append(WeakListener(listener))
            }
        }
    }

    func removeListener(_ listener: CIODebugEventListener) {
        self.withListeners { _, listeners in
            listeners.removeAll { $0.listener === listener }
        }
    }

    /**
     Start recording an event. This is called on the thread of the tracking call, before the request is sent.

     The sequence number and the time are taken together, so that both tell the same order.
     */
    func begin(name: CIOTrackingEventName, request: URLRequest) -> PendingEvent {
        self.lock.lock()
        let sequence = self.nextSequence
        self.nextSequence += 1
        let firedAt = Date()
        self.lock.unlock()

        return PendingEvent(sequence: sequence, name: name, firedAt: firedAt, request: request)
    }

    /**
     Finish recording an event with the response of its request, then log it and hand it to the listeners on the main queue. This is called on the thread on which the response arrives.
     */
    func finish(_ pendingEvent: PendingEvent, with response: NetworkResponse) {
        let event = CIODebugEvent(sequence: pendingEvent.sequence, name: pendingEvent.name, firedAt: pendingEvent.firedAt, request: pendingEvent.request, response: response)

        DispatchQueue.main.async {
            ConstructorIO.logger.log(Constants.Logging.debugEvent(event))

            // The boxes are kept for the delivery and not the listeners, so that a listener the app lets go of in the meantime is not kept alive and called.
            // A listener can also be removed by one that is called before it, so each one is checked right before it is called.
            for box in self.listenerBoxes() {
                guard let listener = box.listener, self.isListening(listener) else {
                    continue
                }
                listener.didTrack(event: event)
            }
        }
    }

    private func listenerBoxes() -> [WeakListener] {
        return self.withListeners { _, listeners in listeners }
    }

    private func isListening(_ listener: CIODebugEventListener) -> Bool {
        return self.withListeners { liveListeners, _ in liveListeners.contains { $0 === listener } }
    }

    /**
     Reads or changes the list of listeners while holding the lock. Every access to the list has to go through here.

     Reading a weak reference keeps its listener alive for a moment. If that turned out to be the last reference, the listener would be deallocated while the lock is held, and a deinit that calls back into the recorder would wait for the lock forever. The listeners that are alive are therefore kept alive until the lock has been released, which can make the calling thread the one that deallocates a listener. The delivery reads the weak reference of one box at a time outside of the lock for the same reason.

     Keeping them alive relies on `withExtendedLifetime`: an optimised build would otherwise let go of the array right after its last use, which is before the unlock. The tests build the framework without optimisation and cannot tell whether it is there, so do not remove it.
     */
    private func withListeners<T>(_ body: (_ liveListeners: [CIODebugEventListener], _ listeners: inout [WeakListener]) -> T) -> T {
        self.lock.lock()
        let liveListeners = self.listeners.compactMap { $0.listener }
        if liveListeners.count != self.listeners.count {
            self.listeners.removeAll { $0.listener == nil }
        }
        let result = body(liveListeners, &self.listeners)
        self.lock.unlock()

        return withExtendedLifetime(liveListeners) { result }
    }
}
