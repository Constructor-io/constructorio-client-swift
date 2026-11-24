//
//  DebugEventCollector.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

// A debug event listener that keeps what it received, for the tests to inspect
class DebugEventCollector: CIODebugEventListener {

    private(set) var events: [CIODebugEvent] = []

    // Whether each of the events came in on the main thread
    private(set) var calledOnMainThread: [Bool] = []

    // Fulfilled once for every event that comes in. An event too many then fails the assertions of the test instead of raising an exception
    var expectation: XCTestExpectation? {
        didSet {
            self.expectation?.assertForOverFulfill = false
        }
    }

    // Called with every event that comes in, after it was stored
    var onEvent: ((CIODebugEvent) -> Void)?

    func didTrack(event: CIODebugEvent) {
        self.events.append(event)
        self.calledOnMainThread.append(Thread.isMainThread)
        self.expectation?.fulfill()
        self.onEvent?(event)
    }
}
