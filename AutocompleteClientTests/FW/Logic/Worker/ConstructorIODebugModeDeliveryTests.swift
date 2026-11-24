//
//  ConstructorIODebugModeDeliveryTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class ConstructorIODebugModeDeliveryTests: XCTestCase {

    // Keeps the requests it is given until the test completes them, so that a test decides when and in which order the responses arrive
    final class HoldingNetworkClient: NetworkClient {
        private let lock = NSLock()
        private var completionHandlers: [(NetworkResponse) -> Void] = []

        func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void) {
            self.lock.lock()
            self.completionHandlers.append(completionHandler)
            self.lock.unlock()
        }

        // Completes the requests it holds on a background thread, as the real network client does, and returns once that is done.
        // The events and completion handlers are then waiting on the main queue.
        func completeAll(latestFirst: Bool = false) {
            self.lock.lock()
            let completionHandlers = latestFirst ? Array(self.completionHandlers.reversed()) : self.completionHandlers
            self.completionHandlers.removeAll()
            self.lock.unlock()

            let completed = DispatchSemaphore(value: 0)
            DispatchQueue.global().async {
                completionHandlers.forEach { $0(NetworkResponse(data: Data(), statusCode: 204)) }
                completed.signal()
            }
            completed.wait()
        }
    }

    let timeout: TimeInterval = 5.0

    var originalNetworkClient: (() -> NetworkClient)!
    var networkClient: HoldingNetworkClient!
    var constructor: ConstructorIO!
    var collector: DebugEventCollector!

    override func setUp() {
        super.setUp()
        let networkClient = HoldingNetworkClient()
        self.networkClient = networkClient
        self.originalNetworkClient = DependencyContainer.sharedInstance.networkClient
        DependencyContainer.sharedInstance.networkClient = { return networkClient }

        self.constructor = TestConstants.testConstructor()
        self.constructor.config.debugMode = true
        self.collector = DebugEventCollector()
        self.constructor.addDebugEventListener(self.collector)
    }

    override func tearDown() {
        DependencyContainer.sharedInstance.networkClient = self.originalNetworkClient
        super.tearDown()
    }

    func testSequence_FollowsTheOrderOfTheCalls_WhenTheResponsesArriveOutOfOrder() {
        ["first", "second", "third"].forEach { self.constructor.trackInputFocus(searchTerm: $0) }

        self.networkClient.completeAll(latestFirst: true)
        self.waitForEvents(3)

        XCTAssertEqual(self.collector.events.map { $0.queryValue(for: "term") }, ["third", "second", "first"], "The events should arrive in the order of their responses.")
        XCTAssertEqual(self.collector.events.map { $0.sequence }, [3, 2, 1], "The sequence numbers should follow the order of the calls.")
        let firedAt = self.collector.events.sorted { $0.sequence < $1.sequence }.map { $0.firedAt }
        XCTAssertEqual(firedAt, firedAt.sorted(), "An event with a higher sequence number should not have been fired earlier.")
    }

    func testEvent_FiredWhileDebugModeWasOn_IsDeliveredAfterItWasSwitchedOff() {
        self.constructor.trackInputFocus(searchTerm: "on")
        self.constructor.config.debugMode = false

        self.networkClient.completeAll()
        self.waitForEvents(1)

        XCTAssertEqual(self.collector.events.map { $0.queryValue(for: "term") }, ["on"])
    }

    func testEvent_FiredWhileDebugModeWasOff_IsNotRecordedAfterItWasSwitchedOn() {
        self.constructor.config.debugMode = false
        let completed = self.expectation(description: "The completion handler should be called.")
        self.constructor.trackInputFocus(searchTerm: "off") { _ in
            completed.fulfill()
        }
        self.constructor.config.debugMode = true

        self.networkClient.completeAll()
        self.wait(for: [completed], timeout: self.timeout)

        XCTAssertTrue(self.collector.events.isEmpty)
    }

    func testRequestInFlight_DoesNotKeepTheClientAlive() {
        for debugMode in [true, false] {
            let collector = DebugEventCollector()
            collector.expectation = XCTestExpectation(description: "The event of a request in flight should be delivered after its client is gone.")
            weak var weakConstructor: ConstructorIO?

            autoreleasepool {
                let constructor = TestConstants.testConstructor()
                constructor.config.debugMode = debugMode
                constructor.addDebugEventListener(collector)
                constructor.trackInputFocus(searchTerm: "in flight")
                weakConstructor = constructor
            }

            XCTAssertNil(weakConstructor, "A request in flight should not retain its client (debugMode: \(debugMode)).")
            self.networkClient.completeAll()
            if debugMode {
                self.wait(for: [collector.expectation!], timeout: self.timeout)
                XCTAssertEqual(collector.events.map { $0.name }, [.inputFocus])
            }
        }
    }

    func testListener_RemovedAfterTheResponseArrived_ReceivesNothing() {
        let completed = self.expectation(description: "The completion handler should be called.")
        self.constructor.trackInputFocus(searchTerm: "a") { _ in
            completed.fulfill()
        }

        // The event is waiting on the main queue when the listener is removed
        self.networkClient.completeAll()
        self.constructor.removeDebugEventListener(self.collector)
        self.wait(for: [completed], timeout: self.timeout)

        XCTAssertTrue(self.collector.events.isEmpty, "A listener should not be called after it was removed.")
    }

    func testListener_RemovedByAnotherListenerDuringTheDelivery_ReceivesNothing() {
        let removedCollector = DebugEventCollector()
        self.constructor.addDebugEventListener(removedCollector)
        self.collector.onEvent = { [unowned self] _ in
            self.constructor.removeDebugEventListener(removedCollector)
        }
        let completed = self.expectation(description: "The completion handler should be called.")
        self.constructor.trackInputFocus(searchTerm: "a") { _ in
            completed.fulfill()
        }

        self.networkClient.completeAll()
        self.wait(for: [completed], timeout: self.timeout)

        XCTAssertEqual(self.collector.events.count, 1)
        XCTAssertTrue(removedCollector.events.isEmpty, "A listener should not be called after it was removed.")
    }

    func testListener_ReleasedByAnotherListenerDuringTheDelivery_ReceivesNothing() {
        var releasedCollector: DebugEventCollector? = DebugEventCollector()
        weak var weakCollector: DebugEventCollector?
        weakCollector = releasedCollector
        var wasCalled = false
        var wasDeallocatedAtOnce = false
        releasedCollector?.onEvent = { _ in wasCalled = true }
        self.constructor.addDebugEventListener(releasedCollector!)
        self.collector.onEvent = { _ in
            // The app lets go of the listener without removing it
            releasedCollector = nil
            wasDeallocatedAtOnce = weakCollector == nil
        }
        let completed = self.expectation(description: "The completion handler should be called.")
        self.constructor.trackInputFocus(searchTerm: "a") { _ in
            completed.fulfill()
        }

        self.networkClient.completeAll()
        self.wait(for: [completed], timeout: self.timeout)

        XCTAssertEqual(self.collector.events.count, 1)
        XCTAssertTrue(wasDeallocatedAtOnce, "A delivery should not keep a listener alive that the app let go of.")
        XCTAssertFalse(wasCalled, "A listener should not be called after the app let go of it.")
    }

    func testListener_CanUseTheClientFromItsCallback() {
        let addedCollector = DebugEventCollector()
        self.collector.onEvent = { [unowned self] event in
            guard event.sequence == 1 else { return }
            self.constructor.addDebugEventListener(addedCollector)
            self.constructor.removeDebugEventListener(addedCollector)
            self.constructor.addDebugEventListener(addedCollector)
            self.constructor.trackInputFocus(searchTerm: "from the callback")
        }

        self.constructor.trackInputFocus(searchTerm: "first")
        self.networkClient.completeAll()
        self.waitForEvents(1)
        self.networkClient.completeAll()
        self.waitForEvents(1)

        XCTAssertEqual(self.collector.events.map { $0.queryValue(for: "term") }, ["first", "from the callback"])
        XCTAssertEqual(addedCollector.events.map { $0.sequence }, [2], "A listener that is added during a delivery should receive the events after it.")
    }

    func testSessionStart_FiredWhileTheClientIsCreated_IsRecorded() {
        // A timeout of zero makes the session expire at once, which is what a stored session that is older than the timeout does
        let originalSessionManager = DependencyContainer.sharedInstance.sessionManager
        DependencyContainer.sharedInstance.sessionManager = {
            return CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: 0, sessionLoader: NoSessionLoader())
        }
        defer { DependencyContainer.sharedInstance.sessionManager = originalSessionManager }

        let constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: TestConstants.testApiKey, debugMode: true))
        let collector = DebugEventCollector()
        constructor.addDebugEventListener(collector)
        collector.expectation = XCTestExpectation(description: "The session start should produce a debug event.")

        self.networkClient.completeAll()
        self.wait(for: [collector.expectation!], timeout: self.timeout)

        XCTAssertEqual(collector.events.map { $0.name }, [.sessionStart])
        XCTAssertEqual(collector.events.map { $0.sequence }, [1])
        XCTAssertEqual(collector.events.first?.queryValue(for: "action"), "session_start")
    }

    private func waitForEvents(_ count: Int) {
        let delivered = XCTestExpectation(description: "\(count) debug events should be delivered.")
        delivered.expectedFulfillmentCount = count
        self.collector.expectation = delivered
        self.wait(for: [delivered], timeout: self.timeout)
        self.collector.expectation = nil
    }
}
