//
//  ConstructorIODebugModeTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

// swiftlint:disable type_body_length file_length

class ConstructorIODebugModeTests: XCTestCase {

    // Keeps the lines it is given. The logger is called from several threads, so the lines are guarded by a lock.
    final class SpyLogger: CIOLogger {
        private let lock = NSLock()
        private var loggedLines: [String] = []

        var lines: [String] {
            self.lock.lock()
            defer { self.lock.unlock() }
            return self.loggedLines
        }

        func log(_ message: String) {
            self.lock.lock()
            self.loggedLines.append(message)
            self.lock.unlock()
        }
    }

    let timeout: TimeInterval = 5.0

    var constructor: ConstructorIO!
    var collector: DebugEventCollector!
    var originalLogger: CIOLogger?

    override func setUp() {
        super.setUp()
        // Answers every request that has no stub of its own, so that the tests do not depend on the network
        stub({ _ in true }, http(200))
        self.constructor = TestConstants.testConstructor()
        self.constructor.config.debugMode = true
        self.collector = DebugEventCollector()
        self.constructor.addDebugEventListener(self.collector)
    }

    override func tearDown() {
        if let originalLogger = self.originalLogger {
            self.setLogger(originalLogger)
            self.originalLogger = nil
        }
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    // MARK: Config

    func testDebugMode_IsDisabledByDefault() {
        XCTAssertFalse(ConstructorIOConfig(apiKey: TestConstants.testApiKey).debugMode, "Debug mode should be off unless it is asked for.")
    }

    func testDebugMode_CanBeEnabledInTheConfigInitializer() {
        XCTAssertTrue(ConstructorIOConfig(apiKey: TestConstants.testApiKey, debugMode: true).debugMode)
    }

    func testDebugMode_WhenDisabled_RecordsNothing() {
        self.constructor.config.debugMode = false
        let logger = self.installSpyLogger()
        let term = self.uniqueTerm()

        self.trackSearchSubmit(term: term)

        XCTAssertTrue(self.collector.events.isEmpty, "Listeners should receive nothing while debug mode is off.")
        XCTAssertFalse(logger.lines.contains { $0.contains("[Debug]") && $0.contains(term) }, "Nothing should be logged for the event while debug mode is off.")
    }

    func testDebugMode_WhenEnabledAsTheClientIsCreated_RecordsTheEvents() {
        let constructor = TestConstants.testConstructor(ConstructorIOConfig(apiKey: TestConstants.testApiKey, debugMode: true))
        let collector = DebugEventCollector()
        constructor.addDebugEventListener(collector)

        self.trackSearchSubmit(term: self.uniqueTerm(), on: constructor)

        // The client can have started a session as it was created, which is an event of its own
        XCTAssertEqual(collector.events.filter { $0.name == .searchSubmit }.count, 1)
    }

    func testDebugMode_CanBeSwitchedWhileTheClientIsUsed() {
        let terms = [self.uniqueTerm(), self.uniqueTerm(), self.uniqueTerm()]

        self.trackSearchSubmit(term: terms[0])
        self.constructor.config.debugMode = false
        self.trackSearchSubmit(term: terms[1])
        self.constructor.config.debugMode = true
        self.trackSearchSubmit(term: terms[2])

        XCTAssertEqual(self.collector.events.map { $0.url?.path }, ["/autocomplete/\(terms[0])/search", "/autocomplete/\(terms[2])/search"])
        XCTAssertEqual(self.collector.events.map { $0.sequence }, [1, 2], "A call that is made while debug mode is off should not use up a sequence number.")
    }

    // MARK: Recording

    func testDebugMode_RecordsOneEventForATrackingCall() {
        let term = self.uniqueTerm()
        let before = Date()

        self.trackSearchSubmit(term: term)

        XCTAssertEqual(self.collector.events.count, 1, "A tracking call should produce exactly one event.")
        guard let event = self.collector.events.first else { return }
        XCTAssertEqual(event.name, .searchSubmit)
        XCTAssertEqual(event.sequence, 1)
        XCTAssertGreaterThanOrEqual(event.firedAt, before)
        XCTAssertLessThanOrEqual(event.firedAt, Date())
        XCTAssertEqual(event.httpMethod, "GET")
        XCTAssertEqual(event.url?.host, "ac.cnstrc.com")
        XCTAssertEqual(event.url?.path, "/autocomplete/\(term)/search")
        XCTAssertTrue(event.queryItems.contains(URLQueryItem(name: "original_query", value: term)))
        XCTAssertEqual(event.queryValue(for: "key"), TestConstants.testApiKey)
        XCTAssertNil(event.body)
        XCTAssertTrue(event.succeeded)
        XCTAssertEqual(event.statusCode, 200)
        XCTAssertNil(event.error)
        XCTAssertNil(event.errorMessage)
        XCTAssertNil(event.responseBody)
        XCTAssertNil(event.underlyingError)
    }

    func testDebugMode_NumbersTheEventsOfEveryClientOnItsOwn() {
        let otherConstructor = TestConstants.testConstructor()
        otherConstructor.config.debugMode = true
        let otherCollector = DebugEventCollector()
        otherConstructor.addDebugEventListener(otherCollector)

        self.trackSearchSubmit(term: self.uniqueTerm())
        self.trackSearchSubmit(term: self.uniqueTerm())
        self.trackSearchSubmit(term: self.uniqueTerm(), on: otherConstructor)

        XCTAssertEqual(self.collector.events.map { $0.sequence }, [1, 2])
        XCTAssertEqual(otherCollector.events.map { $0.sequence }, [1], "A listener should only receive the events of the client it was added to.")
    }

    func testDebugMode_ReportsTheRequestThatWasSent() {
        let term = self.uniqueTerm()
        var sentRequest: URLRequest?
        self.stubSearchSubmit(term: term) { request in
            sentRequest = request
            return http(200)(request)
        }

        self.trackSearchSubmit(term: term)

        XCTAssertNotNil(sentRequest)
        XCTAssertEqual(self.collector.events.first?.url, sentRequest?.url)
        XCTAssertEqual(self.collector.events.first?.httpMethod, sentRequest?.httpMethod)
    }

    func testDebugMode_ReportsTheRequestBodyThatWasSent_WithoutRedactingIt() {
        // The SDK obfuscates PII in the URL, but sends the body as it is. The event shows what was sent.
        self.constructor.userID = "jane@example.com"
        var sentRequest: URLRequest?
        stub({ $0.url?.path == "/v2/behavioral_action/search_result_load" }, { request in
            sentRequest = request
            return http(200)(request)
        })
        let completed = self.expectation(description: "The completion handler should be called.")

        self.constructor.trackSearchResultsLoaded(searchTerm: "john.doe@example.com", resultCount: 3) { _ in
            completed.fulfill()
        }
        self.wait(for: [completed], timeout: self.timeout)

        let event = self.collector.events.first
        let reportedBody = self.json(event?.body?.data(using: .utf8))
        XCTAssertEqual(event?.name, .searchResultsLoaded)
        XCTAssertEqual(event?.httpMethod, "POST")
        XCTAssertNotNil(reportedBody)
        XCTAssertEqual(reportedBody, self.json(sentRequest?.ohhttpStubs_httpBody), "The event should have the body that was sent.")
        XCTAssertEqual(reportedBody?["search_term"] as? String, "john.doe@example.com")
        XCTAssertEqual(event?.url, sentRequest?.url)
        XCTAssertEqual(event?.queryValue(for: "ui"), "<email_omitted>")
    }

    func testDebugMode_ReportsTheURLWithObfuscatedPII() {
        let email = "john.doe@example.com"
        var sentRequest: URLRequest?
        stub({ $0.url?.path.hasSuffix("/search") == true }, { request in
            sentRequest = request
            return http(200)(request)
        })

        self.trackSearchSubmit(term: email)

        let event = self.collector.events.first
        XCTAssertNotNil(event)
        XCTAssertEqual(event?.url, sentRequest?.url)
        XCTAssertEqual(event?.url?.path, "/autocomplete/<email_omitted>/search")
        XCTAssertEqual(event?.queryValue(for: "original_query"), "<email_omitted>")
        XCTAssertEqual(event?.description.contains(email), false, "The PII that was removed from the request should not show up in the event.")
    }

    // MARK: Failed requests

    func testDebugMode_With400() {
        let term = self.uniqueTerm()
        let responseBody = "{\"message\":\"Invalid parameter\"}"
        self.stubSearchSubmit(term: term, http(400, data: Data(responseBody.utf8)))

        let response = self.trackSearchSubmit(term: term)

        let event = self.collector.events.first
        XCTAssertEqual(response?.error as? CIOError, CIOError(errorType: .badRequest, errorMessage: "Invalid parameter"))
        XCTAssertEqual(event?.succeeded, false)
        XCTAssertEqual(event?.error as? CIOError, CIOError(errorType: .badRequest, errorMessage: "Invalid parameter"))
        XCTAssertEqual(event?.statusCode, 400)
        XCTAssertEqual(event?.responseBody, responseBody)
        XCTAssertEqual(event?.errorMessage, "Invalid parameter")
        XCTAssertNil(event?.underlyingError)
    }

    func testDebugMode_With500() {
        let term = self.uniqueTerm()
        self.stubSearchSubmit(term: term, http(500))

        self.trackSearchSubmit(term: term)

        let event = self.collector.events.first
        XCTAssertEqual(event?.succeeded, false)
        XCTAssertEqual(event?.statusCode, 500)
        XCTAssertEqual(event?.errorMessage, "Error Code 500: Internal Server Error - We had a problem with our server. Try again later.")
    }

    func testDebugMode_WithStatusCodeTheSDKDoesNotReportAsAnError() {
        let term = self.uniqueTerm()
        self.stubSearchSubmit(term: term, http(502, data: Data("Bad Gateway".utf8)))

        let response = self.trackSearchSubmit(term: term)

        let event = self.collector.events.first
        XCTAssertNil(response?.error, "The completion handler should keep receiving a success for this status code.")
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(event?.succeeded, false, "The event should fail for every status code outside of the 2xx range.")
        XCTAssertNil(event?.error)
        XCTAssertEqual(event?.statusCode, 502)
        XCTAssertEqual(event?.responseBody, "Bad Gateway")
        XCTAssertNotNil(event?.errorMessage)
    }

    func testDebugMode_WithNoConnectivity() {
        let term = self.uniqueTerm()
        self.stubSearchSubmit(term: term, noConnectivity())

        let response = self.trackSearchSubmit(term: term)

        let event = self.collector.events.first
        XCTAssertEqual(response?.error as? CIOError, CIOError(errorType: .noConnection))
        XCTAssertEqual(event?.succeeded, false)
        XCTAssertNil(event?.statusCode)
        XCTAssertNil(event?.responseBody)
        XCTAssertEqual((event?.underlyingError as NSError?)?.domain, NSURLErrorDomain)
        XCTAssertEqual((event?.underlyingError as NSError?)?.code, NSURLErrorNotConnectedToInternet)
        XCTAssertNotNil(event?.errorMessage)
    }

    func testDebugMode_WithTimeout_ReportsTheTransportError() {
        let term = self.uniqueTerm()
        self.stubSearchSubmit(term: term) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: [NSLocalizedDescriptionKey: "The request timed out."])
            return OHHTTPStubsResponse(error: error)
        }

        self.trackSearchSubmit(term: term)

        let event = self.collector.events.first
        XCTAssertEqual(event?.succeeded, false)
        XCTAssertEqual((event?.underlyingError as NSError?)?.code, NSURLErrorTimedOut)
        XCTAssertEqual(event?.errorMessage, "The request timed out.")
    }

    // MARK: Delivery

    func testDebugMode_CallsTheListenersOnTheMainQueueBeforeTheCompletionHandler() {
        let completed = self.expectation(description: "The completion handler should be called.")
        var eventsSeenByTheCompletionHandler: Int?

        self.constructor.trackInputFocus(searchTerm: self.uniqueTerm()) { _ in
            eventsSeenByTheCompletionHandler = self.collector.events.count
            completed.fulfill()
        }
        self.wait(for: [completed], timeout: self.timeout)

        XCTAssertEqual(eventsSeenByTheCompletionHandler, 1, "The listeners should have been called by the time the completion handler runs.")
        XCTAssertEqual(self.collector.calledOnMainThread, [true])
    }

    func testDebugMode_WhenTrackingFromABackgroundThread_CallsTheListenersOnTheMainQueueBeforeTheCompletionHandler() {
        let completed = self.expectation(description: "The completion handler should be called.")
        var eventsSeenByTheCompletionHandler: Int?

        DispatchQueue.global().async {
            self.constructor.trackInputFocus(searchTerm: self.uniqueTerm()) { _ in
                eventsSeenByTheCompletionHandler = self.collector.events.count
                completed.fulfill()
            }
        }
        self.wait(for: [completed], timeout: self.timeout)

        XCTAssertEqual(eventsSeenByTheCompletionHandler, 1)
        XCTAssertEqual(self.collector.calledOnMainThread, [true])
    }

    func testDebugMode_WithoutACompletionHandler_CallsTheListeners() {
        self.collector.expectation = self.expectation(description: "The listener should receive the event.")

        self.constructor.trackInputFocus(searchTerm: self.uniqueTerm())
        self.waitForExpectationWithDefaultHandler(self.timeout)

        XCTAssertEqual(self.collector.events.map { $0.name }, [.inputFocus])
    }

    func testDebugMode_LogsTheEventThroughTheLogger() {
        let logger = self.installSpyLogger()
        let term = self.uniqueTerm()

        self.trackSearchSubmit(term: term)

        let debugLines = logger.lines.filter { $0.contains("[Debug]") && $0.contains(term) }
        XCTAssertEqual(debugLines.count, 1, "The event should be logged once.")
        XCTAssertEqual(debugLines.first, self.collector.events.first.map { "[ConstructorIO]: [Debug] \($0)" })
    }

    func testDebugMode_WithoutListeners_LogsTheEvent() {
        self.constructor.removeDebugEventListener(self.collector)
        let logger = self.installSpyLogger()
        let term = self.uniqueTerm()

        self.trackSearchSubmit(term: term)

        let debugLines = logger.lines.filter { $0.contains("[Debug]") && $0.contains(term) }
        XCTAssertEqual(debugLines.count, 1, "The event should be logged when no listener is registered.")
        XCTAssertEqual(debugLines.first?.hasPrefix("[ConstructorIO]: [Debug] #1 search_submit OK"), true)
    }

    func testDebugMode_LogsWhyAnEventFailed() {
        let logger = self.installSpyLogger()
        let term = self.uniqueTerm()
        self.stubSearchSubmit(term: term, http(400, data: Data("{\"message\":\"Invalid parameter\"}".utf8)))

        self.trackSearchSubmit(term: term)

        let debugLine = logger.lines.first { $0.contains("[Debug]") && $0.contains(term) }
        XCTAssertEqual(debugLine?.contains("search_submit FAILED"), true)
        XCTAssertEqual(debugLine?.contains("status code: 400"), true)
        XCTAssertEqual(debugLine?.contains("error: Invalid parameter"), true)
        XCTAssertEqual(debugLine?.contains("response: {\"message\":\"Invalid parameter\"}"), true)
    }

    // MARK: Listeners

    func testDebugMode_DeliversTheEventToEveryListener() {
        let otherCollector = DebugEventCollector()
        self.constructor.addDebugEventListener(otherCollector)

        self.trackSearchSubmit(term: self.uniqueTerm())

        XCTAssertEqual(self.collector.events.map { $0.sequence }, [1])
        XCTAssertEqual(otherCollector.events.map { $0.sequence }, [1])
    }

    func testDebugMode_WithListenerAddedTwice_DeliversTheEventOnce() {
        self.constructor.addDebugEventListener(self.collector)

        self.trackSearchSubmit(term: self.uniqueTerm())

        XCTAssertEqual(self.collector.events.count, 1)
    }

    func testDebugMode_WithRemovedListener_DeliversNothingToIt() {
        let otherCollector = DebugEventCollector()
        self.constructor.addDebugEventListener(otherCollector)
        self.constructor.removeDebugEventListener(self.collector)

        self.trackSearchSubmit(term: self.uniqueTerm())

        XCTAssertTrue(self.collector.events.isEmpty)
        XCTAssertEqual(otherCollector.events.count, 1, "Removing a listener should not affect the other ones.")
    }

    func testDebugMode_DoesNotRetainTheListeners() {
        var listener: DebugEventCollector? = DebugEventCollector()
        weak var weakListener: DebugEventCollector?
        weakListener = listener
        self.constructor.addDebugEventListener(listener!)

        listener = nil

        XCTAssertNil(weakListener, "A listener should be deallocated once the app lets go of it.")
        self.trackSearchSubmit(term: self.uniqueTerm())
        XCTAssertEqual(self.collector.events.count, 1, "The remaining listeners should keep receiving events.")
    }

    // MARK: Helpers

    // Calls trackSearchSubmit and waits for its completion handler, which runs after the listeners were called
    @discardableResult
    private func trackSearchSubmit(term: String, on constructor: ConstructorIO? = nil) -> TrackingTaskResponse? {
        let completed = self.expectation(description: "The completion handler should be called.")
        var taskResponse: TrackingTaskResponse?
        (constructor ?? self.constructor).trackSearchSubmit(searchTerm: term, originalQuery: term) { response in
            taskResponse = response
            completed.fulfill()
        }
        self.wait(for: [completed], timeout: self.timeout)
        return taskResponse
    }

    private func stubSearchSubmit(term: String, _ builder: @escaping Builder) {
        stub({ $0.url?.path == "/autocomplete/\(term)/search" }, builder)
    }

    // A term that no other test uses, to tell the log lines of a test apart from the ones of earlier tests
    private func uniqueTerm() -> String {
        return "term-\(UUID().uuidString.lowercased())"
    }

    private func json(_ data: Data?) -> NSDictionary? {
        return data.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) } as? NSDictionary
    }

    private func installSpyLogger() -> SpyLogger {
        let logger = SpyLogger()
        self.originalLogger = ConstructorIO.logger
        self.setLogger(logger)
        return logger
    }

    // Replaces the logger at a moment at which no request can be logging. The responses are logged on the delegate queue of the shared session,
    // which runs one operation at a time, and nothing is logged on the main thread while it waits here.
    private func setLogger(_ logger: CIOLogger) {
        let operation = BlockOperation {
            ConstructorIO.logger = logger
        }
        URLSession.shared.delegateQueue.addOperations([operation], waitUntilFinished: true)
    }
}

// swiftlint:enable type_body_length file_length
