//
//  SearchJourneyUITests.swift
//  ConstructorDemoUITests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import XCTest

/// Walks the shop's search journey, then checks the SDK's debug overlay recorded every step.
/// Hits the real API. Timeouts allow for the SDK's default 60s request timeout when the API is unreachable.
final class SearchJourneyUITests: XCTestCase {

    private let networkTimeout: TimeInterval = 90

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }

    private func launch(debugMode: Bool) -> XCUIApplication {
        let app = XCUIApplication()
        // Overrides the app's stored setting through NSArgumentDomain
        app.launchArguments = ["-demo.debugMode", debugMode ? "YES" : "NO"]
        app.launch()
        return app
    }

    private func search(_ term: String, in app: XCUIApplication) {
        // The app opens on Home
        app.tabBars.buttons["Shop"].tap()
        let searchField = app.textFields["Search products"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        searchField.tap()
        searchField.typeText("\(term)\n")
    }

    func testSearchJourney_isRecordedByDebugOverlay() {
        let app = self.launch(debugMode: true)

        self.search("apple", in: app)

        let firstResult = app.buttons.matching(identifier: "search-result").firstMatch
        XCTAssertTrue(firstResult.waitForExistence(timeout: self.networkTimeout), "Search results should appear")
        firstResult.tap()

        let addToCart = app.buttons["Add to Cart"]
        XCTAssertTrue(addToCart.waitForExistence(timeout: 10))
        addToCart.tap()

        app.tabBars.buttons["Cart"].tap()
        let placeOrder = app.buttons["Place Order"]
        XCTAssertTrue(placeOrder.waitForExistence(timeout: 10))
        placeOrder.tap()
        app.alerts.buttons["OK"].tap()

        // The SDK's overlay, not anything in the app
        let debugButton = app.buttons["cio-debug-button"]
        XCTAssertTrue(debugButton.waitForExistence(timeout: 10), "SDK debug button should be shown in debug mode")
        debugButton.tap()

        for event in ["input_focus", "search_submit", "search_results_loaded", "search_result_click", "item_detail_load", "conversion", "purchase"] {
            let row = app.cells["cio-debug-event-\(event)"]
            XCTAssertTrue(row.waitForExistence(timeout: self.networkTimeout), "\(event) should be recorded")
        }

        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "SDK event log after search journey"
        screenshot.lifetime = .keepAlways
        self.add(screenshot)

        // Event detail
        app.cells["cio-debug-event-search_submit"].tap()
        XCTAssertTrue(app.staticTexts["original_query"].waitForExistence(timeout: 10))
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Closing the log returns to the shop
        app.navigationBars.buttons["Done"].tap()
        XCTAssertTrue(app.tabBars.buttons["Shop"].waitForExistence(timeout: 10))
    }

    func testDebugOverlay_doesNotBlockTheApp() {
        let app = self.launch(debugMode: true)

        XCTAssertTrue(app.buttons["cio-debug-button"].waitForExistence(timeout: 10))

        // Tabs and the search field sit under the overlay window and must still respond
        app.tabBars.buttons["Cart"].tap()
        XCTAssertTrue(app.navigationBars["Cart"].waitForExistence(timeout: 10))
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 10))
        self.search("milk", in: app)
        XCTAssertTrue(app.buttons.matching(identifier: "search-result").firstMatch.waitForExistence(timeout: self.networkTimeout))
    }

    func testHomeLogo_returnsToHome() {
        let app = self.launch(debugMode: false)

        app.tabBars.buttons["Cart"].tap()
        XCTAssertTrue(app.navigationBars["Cart"].waitForExistence(timeout: 10))
        app.buttons["home-logo"].tap()
        XCTAssertTrue(app.buttons["Start shopping"].waitForExistence(timeout: 10), "Should be back on Home")
    }

    func testPopularSearch_tracksSelectAndSubmit() {
        let app = self.launch(debugMode: true)

        app.tabBars.buttons["Shop"].tap()
        let searchField = app.textFields["Search products"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        searchField.tap()

        let popular = app.buttons.matching(identifier: "popular-search").firstMatch
        XCTAssertTrue(popular.waitForExistence(timeout: 10), "Popular searches should show while the field is empty")
        popular.tap()
        XCTAssertTrue(app.buttons.matching(identifier: "search-result").firstMatch.waitForExistence(timeout: self.networkTimeout))

        app.buttons["cio-debug-button"].tap()
        for event in ["input_focus", "autocomplete_select", "search_submit", "search_results_loaded"] {
            XCTAssertTrue(app.cells["cio-debug-event-\(event)"].waitForExistence(timeout: self.networkTimeout), "\(event) should be recorded")
        }
    }

    func testStartShopping_resetsSearch() {
        let app = self.launch(debugMode: false)

        self.search("apple", in: app)
        let firstResult = app.buttons.matching(identifier: "search-result").firstMatch
        XCTAssertTrue(firstResult.waitForExistence(timeout: self.networkTimeout))
        firstResult.tap()
        XCTAssertTrue(app.buttons["Add to Cart"].waitForExistence(timeout: 10))

        app.tabBars.buttons["Home"].tap()
        app.buttons["Start shopping"].tap()

        let searchField = app.textFields["Search products"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10), "Shop should be back at its root")
        XCTAssertEqual(searchField.value as? String, "Search products", "Search field should be empty")
        XCTAssertTrue(app.staticTexts["What are you looking for?"].exists)
        XCTAssertFalse(app.buttons.matching(identifier: "search-result").firstMatch.exists)
    }

    func testHomeCarousel_opensProduct() {
        let app = self.launch(debugMode: false)

        let card = app.buttons.matching(identifier: "featured-product").firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: self.networkTimeout))
        card.tap()
        XCTAssertTrue(app.buttons["Add to Cart"].waitForExistence(timeout: 10))
    }

    func testDebugModeOff_showsNoOverlay() {
        let app = self.launch(debugMode: false)

        self.search("apple", in: app)
        XCTAssertTrue(app.buttons.matching(identifier: "search-result").firstMatch.waitForExistence(timeout: self.networkTimeout))
        XCTAssertFalse(app.buttons["cio-debug-button"].exists, "No SDK UI should appear without debug mode")
    }

    func testTogglingDebugMode_showsAndHidesOverlay() {
        let app = self.launch(debugMode: false)

        app.tabBars.buttons["Settings"].tap()
        let toggle = app.switches["SDK debug mode"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 10))
        toggle.switches.firstMatch.tap()
        XCTAssertTrue(app.buttons["cio-debug-button"].waitForExistence(timeout: 10), "Turning debug mode on should show the overlay")

        toggle.switches.firstMatch.tap()
        let gone = NSPredicate(format: "exists == false")
        self.wait(for: [self.expectation(for: gone, evaluatedWith: app.buttons["cio-debug-button"])], timeout: 10)
    }
}
