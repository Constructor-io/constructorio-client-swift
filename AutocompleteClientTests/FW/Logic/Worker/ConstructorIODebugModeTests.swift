//
//  ConstructorIODebugModeTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIODebugModeTests: XCTestCase {

    class MockNetworkClient: NetworkClient {
        var error: Error?

        func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void) {
            if let error = self.error {
                completionHandler(NetworkResponse(error: error))
            } else {
                completionHandler(NetworkResponse(data: Data()))
            }
        }
    }

    class EventCollector: CIODebugEventListener {
        var events: [CIODebugEvent] = []
        var onEvent: ((CIODebugEvent) -> Void)?

        func didTrack(event: CIODebugEvent) {
            XCTAssertTrue(Thread.isMainThread, "Debug listeners should be called on the main queue")
            self.events.append(event)
            self.onEvent?(event)
        }
    }

    var originalNetworkClient: NetworkClient!
    var mockNetworkClient: MockNetworkClient!
    var collector: EventCollector!

    override func setUp() {
        super.setUp()
        self.originalNetworkClient = DependencyContainer.sharedInstance.networkClient()
        self.mockNetworkClient = MockNetworkClient()
        let mock = self.mockNetworkClient!
        DependencyContainer.sharedInstance.networkClient = { mock }
        self.collector = EventCollector()
    }

    override func tearDown() {
        super.tearDown()
        CIODebugOverlay.shared.hide()
        CIODebugEventLog.shared.clear()
        let original = self.originalNetworkClient!
        DependencyContainer.sharedInstance.networkClient = { original }
        OHHTTPStubs.removeAllStubs()
    }

    private func debugConstructor() -> ConstructorIO {
        let constructor = TestConstants.testConstructor(ConstructorIOConfig(apiKey: TestConstants.testApiKey, debugMode: true))
        constructor.addDebugEventListener(self.collector)
        return constructor
    }

    func testDebugMode_isDisabledByDefault() {
        XCTAssertFalse(ConstructorIOConfig(apiKey: TestConstants.testApiKey).debugMode)
    }

    func testDebugMode_recordsTrackingEvent() {
        let constructor = self.debugConstructor()
        let exp = self.expectation(description: "Listener should receive the search submit event")
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackSearchSubmit(searchTerm: "corn", originalQuery: "co", analyticsTags: ["tag1": "value1"])
        self.waitForExpectationWithDefaultHandler()

        XCTAssertEqual(self.collector.events.count, 1)
        let event = self.collector.events[0]
        XCTAssertEqual(event.name, .searchSubmit)
        XCTAssertEqual(event.sequence, 1)
        XCTAssertEqual(event.httpMethod, "GET")
        XCTAssertTrue(event.succeeded)
        XCTAssertEqual(event.url?.path, "/autocomplete/corn/search")
        XCTAssertEqual(event.queryValue(for: "original_query"), "co")
        XCTAssertEqual(event.queryValue(for: "analytics_tags[tag1]"), "value1")
        XCTAssertNotNil(event.queryValue(for: "i"), "Client ID should be captured")
    }

    func testDebugMode_whenDisabled_recordsNothing() {
        let constructor = TestConstants.testConstructor()
        constructor.addDebugEventListener(self.collector)
        let exp = self.expectation(description: "Tracking completion handler should be called")

        constructor.trackSearchSubmit(searchTerm: "corn", originalQuery: "co") { _ in
            // Listeners are dispatched before the completion handler, so if anything were recorded it would be here by now
            exp.fulfill()
        }
        self.waitForExpectationWithDefaultHandler()

        XCTAssertTrue(self.collector.events.isEmpty)
    }

    func testDebugMode_listenerIsCalledBeforeCompletionHandler() {
        let constructor = self.debugConstructor()
        let exp = self.expectation(description: "Tracking completion handler should be called")

        constructor.trackInputFocus(searchTerm: "corn") { _ in
            XCTAssertEqual(self.collector.events.count, 1)
            exp.fulfill()
        }
        self.waitForExpectationWithDefaultHandler()
    }

    func testDebugMode_recordsPOSTBody() {
        let constructor = self.debugConstructor()
        let exp = self.expectation(description: "Listener should receive the purchase event")
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackPurchase(items: [CIOItem(customerID: "item-1", variationID: "var-1")], orderID: "order-1")
        self.waitForExpectationWithDefaultHandler()

        let event = self.collector.events[0]
        XCTAssertEqual(event.name, .purchase)
        XCTAssertEqual(event.httpMethod, "POST")
        XCTAssertTrue(event.body?.contains("order-1") ?? false, "POST body should be captured")
        XCTAssertTrue(event.body?.contains("item-1") ?? false, "POST body should be captured")
    }

    func testDebugMode_recordsEventsInFiringOrder() {
        let constructor = self.debugConstructor()
        let exp = self.expectation(description: "Listener should receive all events")
        exp.expectedFulfillmentCount = 3
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackSearchSubmit(searchTerm: "corn", originalQuery: "corn")
        constructor.trackSearchResultsLoaded(searchTerm: "corn", resultCount: 10)
        constructor.trackItemDetailLoad(customerID: "item-1", itemName: "Corn")
        self.waitForExpectationWithDefaultHandler()

        let names = self.collector.events.sorted(by: { $0.sequence < $1.sequence }).map { $0.name }
        XCTAssertEqual(names, [.searchSubmit, .searchResultsLoaded, .itemDetailLoad])
        XCTAssertEqual(self.collector.events.map { $0.sequence }.sorted(), [1, 2, 3])
    }

    func testDebugMode_recordsFailedRequests() {
        self.mockNetworkClient.error = CIOError(errorType: .badRequest, errorMessage: "missing parameter")
        let constructor = self.debugConstructor()
        let exp = self.expectation(description: "Listener should receive the failed event")
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackSearchSubmit(searchTerm: "corn", originalQuery: "corn")
        self.waitForExpectationWithDefaultHandler()

        let event = self.collector.events[0]
        XCTAssertFalse(event.succeeded)
        XCTAssertEqual((event.error as? CIOError)?.errorType, .badRequest)
        XCTAssertTrue(event.description.contains("FAILED"))
        XCTAssertTrue(event.description.contains("missing parameter"))
    }

    func testDebugMode_obfuscatesPII() {
        let constructor = self.debugConstructor()
        let exp = self.expectation(description: "Listener should receive the search submit event")
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackSearchSubmit(searchTerm: "test@test.com", originalQuery: "test@test.com")
        self.waitForExpectationWithDefaultHandler()

        let event = self.collector.events[0]
        XCTAssertFalse(event.url?.absoluteString.contains("test@test.com") ?? true, "PII must never appear in debug output")
        XCTAssertEqual(event.queryValue(for: "original_query"), "<email_omitted>")
    }

    func testDebugMode_removedListenerReceivesNothing() {
        let constructor = self.debugConstructor()
        constructor.removeDebugEventListener(self.collector)
        let exp = self.expectation(description: "Tracking completion handler should be called")

        constructor.trackInputFocus(searchTerm: "corn") { _ in exp.fulfill() }
        self.waitForExpectationWithDefaultHandler()

        XCTAssertTrue(self.collector.events.isEmpty)
    }

    func testDebugMode_addingSameListenerTwiceDeliversOnce() {
        let constructor = self.debugConstructor()
        constructor.addDebugEventListener(self.collector)
        let exp = self.expectation(description: "Tracking completion handler should be called")

        constructor.trackInputFocus(searchTerm: "corn") { _ in exp.fulfill() }
        self.waitForExpectationWithDefaultHandler()

        XCTAssertEqual(self.collector.events.count, 1)
    }

    func testDebugMode_withRealNetworkClient_recordsStubbedServerError() {
        let original = self.originalNetworkClient!
        DependencyContainer.sharedInstance.networkClient = { original }
        let constructor = self.debugConstructor()
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn&\(TestConstants.defaultSegments)"), http(500))
        let exp = self.expectation(description: "Listener should receive the failed event")
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackInputFocus(searchTerm: "corn")
        self.waitForExpectationWithDefaultHandler()

        XCTAssertEqual(self.collector.events[0].name, .inputFocus)
        XCTAssertEqual((self.collector.events[0].error as? CIOError)?.errorType, .internalServerError)
    }

    func testDebugMode_withRealNetworkClient_capturesServerErrorResponse() {
        let original = self.originalNetworkClient!
        DependencyContainer.sharedInstance.networkClient = { original }
        let constructor = self.debugConstructor()
        let body = "{\"message\":\"Invalid value for parameter: \\\"term\\\"\"}"
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn&\(TestConstants.defaultSegments)"), http(400, data: body.data(using: .utf8)!))
        let exp = self.expectation(description: "Listener should receive the failed event")
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackInputFocus(searchTerm: "corn")
        self.waitForExpectationWithDefaultHandler()

        let event = self.collector.events[0]
        XCTAssertEqual(event.statusCode, 400)
        XCTAssertEqual(event.errorMessage, "Invalid value for parameter: \"term\"")
        XCTAssertEqual(event.responseBody, body)
        XCTAssertTrue(event.description.contains("status code: 400"))
    }

    func testDebugMode_withRealNetworkClient_capturesTransportError() {
        let original = self.originalNetworkClient!
        DependencyContainer.sharedInstance.networkClient = { original }
        let constructor = self.debugConstructor()
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn&\(TestConstants.defaultSegments)"), noConnectivity())
        let exp = self.expectation(description: "Listener should receive the failed event")
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackInputFocus(searchTerm: "corn")
        self.waitForExpectationWithDefaultHandler()

        let event = self.collector.events[0]
        XCTAssertNil(event.statusCode, "No response was received")
        XCTAssertNil(event.responseBody)
        XCTAssertNotNil(event.underlyingError)
        XCTAssertNotNil(event.errorMessage)
    }

    func testDebugMode_errorMessageFallsBackToStatusDescription() {
        self.mockNetworkClient.error = CIOError(errorType: .unauthorized)
        let constructor = self.debugConstructor()
        let exp = self.expectation(description: "Listener should receive the failed event")
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackInputFocus(searchTerm: "corn")
        self.waitForExpectationWithDefaultHandler()

        XCTAssertEqual(self.collector.events[0].errorMessage, "Error Code 401: Unauthorized - Your api key is wrong.")
    }

    // MARK: Event log & overlay

    func testDebugMode_appendsEventsToSharedLog() {
        CIODebugEventLog.shared.clear()
        self.mockNetworkClient.error = CIOError(errorType: .badRequest)
        let constructor = self.debugConstructor()
        let exp = self.expectation(description: "Listener should receive the event")
        self.collector.onEvent = { _ in exp.fulfill() }

        constructor.trackInputFocus(searchTerm: "corn")
        self.waitForExpectationWithDefaultHandler()

        XCTAssertEqual(CIODebugEventLog.shared.events.map { $0.name }, [.inputFocus])
        XCTAssertEqual(CIODebugEventLog.shared.failureCount, 1)
    }

    func testDebugEventLog_isNewestFirstAndBounded() {
        let log = CIODebugEventLog()
        let request = URLRequest(url: URL(string: "https://ac.cnstrc.com/behavior")!)
        for sequence in 1...(CIODebugEventLog.capacity + 5) {
            log.append(CIODebugEvent(sequence: sequence, name: .inputFocus, firedAt: Date(), request: request))
        }

        XCTAssertEqual(log.events.count, CIODebugEventLog.capacity)
        XCTAssertEqual(log.events.first?.sequence, CIODebugEventLog.capacity + 5)
        XCTAssertEqual(log.events.last?.sequence, 6, "Oldest events should be dropped first")
    }

    func testDebugOverlay_followsDebugMode() {
        let constructor = TestConstants.testConstructor()
        self.drainMainQueue()
        XCTAssertFalse(CIODebugOverlay.shared.isVisible, "No overlay without debug mode")

        constructor.config.debugMode = true
        self.drainMainQueue()
        XCTAssertTrue(CIODebugOverlay.shared.isVisible)

        constructor.config.debugMode = false
        self.drainMainQueue()
        XCTAssertFalse(CIODebugOverlay.shared.isVisible)
    }

    func testDebugOverlay_isShownWhenCreatedWithDebugMode() {
        _ = self.debugConstructor()
        self.drainMainQueue()
        XCTAssertTrue(CIODebugOverlay.shared.isVisible)
    }

    func testDebugOverlay_creatingNonDebugClientDoesNotHideIt() {
        _ = self.debugConstructor()
        _ = TestConstants.testConstructor()
        self.drainMainQueue()
        XCTAssertTrue(CIODebugOverlay.shared.isVisible)
    }

    private func drainMainQueue() {
        let exp = self.expectation(description: "Main queue drained")
        DispatchQueue.main.async { exp.fulfill() }
        self.waitForExpectationWithDefaultHandler()
    }
}
