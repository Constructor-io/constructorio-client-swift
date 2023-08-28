//
//  TrackQuizConversionRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackQuizConversionRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"

   // Required Parameters
    let quizID = "coffee quiz"
    let quizVersionID = "1231243"
    let quizSessionID = "13443"
    let customerID = "1123"

    // Optional Parameters
    let variationID = "123"
    let itemName = "espresso"
    let revenue = 24.1
    let conversionType = "add_to_cart_two"
    let isCustomType = true
    let displayName = "bongo"
    let sectionName = "Products"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackQuizConversionBuilder() {
        let tracker = CIOTrackQuizConversionData(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, customerID: self.customerID, variationID: self.variationID, itemName: self.itemName, revenue: self.revenue, conversionType: self.conversionType, isCustomType: self.isCustomType, displayName: self.displayName, sectionName: self.sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["quiz_id"] as? String, self.quizID)
        XCTAssertEqual(payload?["quiz_version_id"] as? String, self.quizVersionID)
        XCTAssertEqual(payload?["quiz_session_id"] as? String, self.quizSessionID)
        XCTAssertEqual(payload?["item_id"] as? String, self.customerID)
        XCTAssertEqual(payload?["variation_id"] as? String, self.variationID)
        XCTAssertEqual(payload?["item_name"] as? String, self.itemName)
        XCTAssertEqual(payload?["revenue"] as? String, String(self.revenue))
        XCTAssertEqual(payload?["type"] as? String, self.conversionType)
        XCTAssertEqual(payload?["is_custom_type"] as? Bool, self.isCustomType)
        XCTAssertEqual(payload?["display_name"] as? String, self.displayName)
        XCTAssertEqual(payload?["section"] as? String, self.sectionName)

        XCTAssertEqual(payload?["key"] as? String, self.testACKey)
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
    }
}
