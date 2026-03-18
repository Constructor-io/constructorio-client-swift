//
//  TrackMediaImpressionViewRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackMediaImpressionViewRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "testKey123213"
    fileprivate let bannerAdId = "banner-ad-123"
    fileprivate let placementId = "home"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseMediaURL: Constants.Query.baseMediaURLString)
    }

    func testTrackMediaImpressionViewBuilder() {
        let tracker = CIOTrackMediaImpressionData(bannerAdId: bannerAdId, placementId: placementId, action: .view)
        builder.build(trackData: tracker)
        let request = builder.getMediaRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://behavior.media-cnstrc.com/v2/ad_behavioral_action/display_ad_view?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["banner_ad_id"] as? String, bannerAdId)
        XCTAssertEqual(payload?["placement_id"] as? String, placementId)
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackMediaImpressionViewBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackMediaImpressionData(bannerAdId: bannerAdId, placementId: placementId, action: .view)
        let customBaseURL = "https://custom-media-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseMediaURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getMediaRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertTrue(url.hasPrefix(customBaseURL))
        XCTAssertEqual(payload?["banner_ad_id"] as? String, bannerAdId)
        XCTAssertEqual(payload?["placement_id"] as? String, placementId)
    }
}
