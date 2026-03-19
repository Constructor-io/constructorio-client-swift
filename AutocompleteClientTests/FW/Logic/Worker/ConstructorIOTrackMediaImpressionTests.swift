//
//  ConstructorIOTrackMediaImpressionTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackMediaImpressionTests: XCTestCase {

    private let bannerAdId = "banner-ad-123"
    private let placementId = TestConstants.testPlacementId

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackMediaImpressionView() {
        let builder = CIOBuilder(expectation: "Calling trackMediaImpressionView should send a valid request.", builder: http(200))
        stub(regex("https://behavior.media-cnstrc.com/v2/ad_behavioral_action/display_ad_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackMediaImpressionView(bannerAdId: bannerAdId, placementId: placementId)
        self.wait(for: builder.expectation)
    }

    func testTrackMediaImpressionView_With400() {
        let expectation = self.expectation(description: "Calling trackMediaImpressionView with 400 should return badRequest CIOError.")
        stub(regex("https://behavior.media-cnstrc.com/v2/ad_behavioral_action/display_ad_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(400))
        self.constructor.trackMediaImpressionView(bannerAdId: bannerAdId, placementId: placementId, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackMediaImpressionView_With500() {
        let expectation = self.expectation(description: "Calling trackMediaImpressionView with 500 should return internalServerError CIOError.")
        stub(regex("https://behavior.media-cnstrc.com/v2/ad_behavioral_action/display_ad_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(500))
        self.constructor.trackMediaImpressionView(bannerAdId: bannerAdId, placementId: placementId, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackMediaImpressionView_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackMediaImpressionView with no connectivity should return noConnection CIOError.")
        stub(regex("https://behavior.media-cnstrc.com/v2/ad_behavioral_action/display_ad_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackMediaImpressionView(bannerAdId: bannerAdId, placementId: placementId, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackMediaImpressionClick() {
        let builder = CIOBuilder(expectation: "Calling trackMediaImpressionClick should send a valid request.", builder: http(200))
        stub(regex("https://behavior.media-cnstrc.com/v2/ad_behavioral_action/display_ad_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackMediaImpressionClick(bannerAdId: bannerAdId, placementId: placementId)
        self.wait(for: builder.expectation)
    }

    func testTrackMediaImpressionClick_With400() {
        let expectation = self.expectation(description: "Calling trackMediaImpressionClick with 400 should return badRequest CIOError.")
        stub(regex("https://behavior.media-cnstrc.com/v2/ad_behavioral_action/display_ad_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(400))
        self.constructor.trackMediaImpressionClick(bannerAdId: bannerAdId, placementId: placementId, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackMediaImpressionClick_With500() {
        let expectation = self.expectation(description: "Calling trackMediaImpressionClick with 500 should return internalServerError CIOError.")
        stub(regex("https://behavior.media-cnstrc.com/v2/ad_behavioral_action/display_ad_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(500))
        self.constructor.trackMediaImpressionClick(bannerAdId: bannerAdId, placementId: placementId, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackMediaImpressionClick_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackMediaImpressionClick with no connectivity should return noConnection CIOError.")
        stub(regex("https://behavior.media-cnstrc.com/v2/ad_behavioral_action/display_ad_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackMediaImpressionClick(bannerAdId: bannerAdId, placementId: placementId, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
