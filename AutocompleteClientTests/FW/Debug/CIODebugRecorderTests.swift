//
//  CIODebugRecorderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class CIODebugRecorderTests: XCTestCase {

    // Unregisters itself when it is deallocated, which is a call into the recorder from wherever its last reference is dropped
    final class SelfRemovingListener: CIODebugEventListener {
        let recorder: CIODebugRecorder

        init(recorder: CIODebugRecorder) {
            self.recorder = recorder
        }

        func didTrack(event: CIODebugEvent) {}

        deinit {
            self.recorder.removeListener(self)
        }
    }

    let timeout: TimeInterval = 5.0
    let request = URLRequest(url: URL(string: "https://ac.cnstrc.com/behavior?action=focus&term=corn")!)
    let response = NetworkResponse(data: Data(), statusCode: 204)

    func testBegin_NumbersTheEventsInTheOrderOfTheCalls() {
        let recorder = CIODebugRecorder()

        let first = recorder.begin(name: .inputFocus, request: self.request)
        let second = recorder.begin(name: .searchSubmit, request: self.request)

        XCTAssertEqual(first.sequence, 1)
        XCTAssertEqual(second.sequence, 2)
    }

    func testBegin_FromManyThreads_GivesEveryEventItsOwnSequenceNumber() {
        let recorder = CIODebugRecorder()
        let count = 50_000
        var sequences = [Int](repeating: 0, count: count)

        sequences.withUnsafeMutableBufferPointer { buffer in
            DispatchQueue.concurrentPerform(iterations: count) { index in
                buffer[index] = recorder.begin(name: .inputFocus, request: self.request).sequence
            }
        }

        XCTAssertEqual(Set(sequences).count, count, "Every event should get a sequence number of its own.")
        XCTAssertEqual(sequences.min(), 1)
        XCTAssertEqual(sequences.max(), count)
    }

    func testFinish_FromABackgroundThread_DeliversTheEventOnTheMainQueue() {
        let recorder = CIODebugRecorder()
        let collector = DebugEventCollector()
        collector.expectation = self.expectation(description: "The listener should receive the event.")
        recorder.addListener(collector)
        let pendingEvent = recorder.begin(name: .inputFocus, request: self.request)

        DispatchQueue.global().async {
            recorder.finish(pendingEvent, with: self.response)
        }
        self.waitForExpectationWithDefaultHandler(self.timeout)

        XCTAssertEqual(collector.calledOnMainThread, [true])
        XCTAssertEqual(collector.events.first?.sequence, 1)
        XCTAssertEqual(collector.events.first?.name, .inputFocus)
        XCTAssertEqual(collector.events.first?.url, self.request.url)
        XCTAssertEqual(collector.events.first?.statusCode, 204)
    }

    func testListeners_AddedAndRemovedFromManyThreads_EndUpAsTheyWereLeft() {
        let recorder = CIODebugRecorder()
        let collectors = (0..<100).map { _ in DebugEventCollector() }

        DispatchQueue.concurrentPerform(iterations: collectors.count) { index in
            recorder.addListener(collectors[index])
            recorder.addListener(collectors[index])
            if index % 2 == 0 {
                recorder.removeListener(collectors[index])
            }
        }
        let delivered = self.expectation(description: "The listeners that were left should receive the event.")
        delivered.expectedFulfillmentCount = collectors.count / 2
        collectors.forEach { $0.expectation = delivered }
        recorder.finish(recorder.begin(name: .inputFocus, request: self.request), with: self.response)
        self.waitForExpectationWithDefaultHandler(self.timeout)

        for (index, collector) in collectors.enumerated() {
            XCTAssertEqual(collector.events.count, index % 2 == 0 ? 0 : 1, "Listener \(index) was \(index % 2 == 0 ? "removed" : "added twice").")
        }
    }

    func testListener_WhoseDeinitUsesTheRecorder_DoesNotDeadlockIt() {
        // A listener that is deallocated while the recorder holds its lock would never get the lock in its deinit.
        // Everything runs in the background, so that such a deadlock makes this test time out instead of freezing the test run.
        let recorder = CIODebugRecorder()
        let finished = self.expectation(description: "Listeners that are deallocated on other threads should not deadlock the recorder.")

        DispatchQueue.global().async {
            for _ in 0..<50_000 {
                var listeners: [SelfRemovingListener?] = [SelfRemovingListener(recorder: recorder), SelfRemovingListener(recorder: recorder)]
                listeners.forEach { recorder.addListener($0!) }
                listeners.withUnsafeMutableBufferPointer { buffer in
                    // Each thread drops the last reference to one of the listeners, while the deinit of the other one has the recorder look at it
                    DispatchQueue.concurrentPerform(iterations: buffer.count) { index in
                        buffer[index] = nil
                    }
                }
            }
            finished.fulfill()
        }

        self.wait(for: [finished], timeout: 60.0)
    }
}
