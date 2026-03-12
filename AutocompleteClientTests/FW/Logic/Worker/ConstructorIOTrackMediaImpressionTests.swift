//
//  ConstructorIOTrackMediaImpressionTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class ConstructorIOTrackMediaImpressionTests: XCTestCase {

    var constructor: ConstructorIO!
    var bannerAdId: String!

    override func setUp() {
        super.setUp()

        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKeyWithAdPlacements)
        self.constructor = ConstructorIO(config: config)

        // Fetch a valid banner_ad_id from the display ads endpoint
        let fetchExpectation = XCTestExpectation(description: "Fetch display ads to get banner_ad_id")
        let urlString = "https://display.media-cnstrc.com/display-ads?key=\(TestConstants.testApiKeyWithAdPlacements)&placement_ids=\(TestConstants.testPlacementId)"
        let url = URL(string: urlString)!

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                XCTFail("Failed to fetch display ads: \(error?.localizedDescription ?? "unknown error")")
                fetchExpectation.fulfill()
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let displayAds = json["display_ads"] as? [String: Any],
                   let ad = displayAds[TestConstants.testPlacementId] as? [String: Any],
                   let bannerAdId = ad["banner_ad_id"] as? String {
                    self.bannerAdId = bannerAdId
                } else {
                    XCTFail("Failed to parse banner_ad_id from display ads response")
                }
            } catch {
                XCTFail("Failed to parse display ads JSON: \(error.localizedDescription)")
            }

            fetchExpectation.fulfill()
        }
        task.resume()

        wait(for: [fetchExpectation], timeout: 10.0)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTrackMediaImpressionView() {
        let expectation = XCTestExpectation(description: "Tracking media impression view")
        self.constructor.trackMediaImpressionView(bannerAdId: self.bannerAdId, placementId: TestConstants.testPlacementId, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 10.0)
    }

    func testTrackMediaImpressionClick() {
        let expectation = XCTestExpectation(description: "Tracking media impression click")
        self.constructor.trackMediaImpressionClick(bannerAdId: self.bannerAdId, placementId: TestConstants.testPlacementId, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 10.0)
    }
}
