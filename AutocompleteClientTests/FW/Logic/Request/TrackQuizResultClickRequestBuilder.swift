//
//  TrackQuizResultClickRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackQuizResultClickRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"

   // Required Parameters
    let quizID = "coffee quiz"
    let quizVersionID = "1231243"
    let quizSessionID = "13443"
    let customerID = "1123"

    // Optional Parameters
    let variationID = "123"
    let itemName = "espresso"
    let resultID = "abc"
    let resultPage = 1
    let resultCount = 12
    let numResultsPerPage = 13
    let resultPositionOnPage = 6
    let sectionName = "Products"
    let analyticsTags = ["test": "testing", "version": "123"]


    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackQuizResultClickBuilder() {
        let tracker = CIOTrackQuizResultClickData(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, customerID: self.customerID, variationID: self.variationID, itemName: self.itemName, resultID: self.resultID, resultPage: self.resultPage, resultCount: self.resultCount, numResultsPerPage: self.numResultsPerPage, resultPositionOnPage: self.resultPositionOnPage, sectionName: self.sectionName, analyticsTags: self.analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let analyticsTagsPayload = payload?["analytics_tags"] as? [String: String] ?? [:]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["quiz_id"] as? String, self.quizID)
        XCTAssertEqual(payload?["quiz_version_id"] as? String, self.quizVersionID)
        XCTAssertEqual(payload?["quiz_session_id"] as? String, self.quizSessionID)
        XCTAssertEqual(payload?["item_id"] as? String, self.customerID)
        XCTAssertEqual(payload?["variation_id"] as? String, self.variationID)
        XCTAssertEqual(payload?["item_name"] as? String, self.itemName)
        XCTAssertEqual(payload?["result_id"] as? String, self.resultID)
        XCTAssertEqual(payload?["result_page"] as? Int, self.resultPage)
        XCTAssertEqual(payload?["result_count"] as? Int, self.resultCount)
        XCTAssertEqual(payload?["num_results_per_page"] as? Int, self.numResultsPerPage)
        XCTAssertEqual(payload?["result_position_on_page"] as? Int, self.resultPositionOnPage)
        XCTAssertEqual(payload?["section"] as? String, self.sectionName)

        XCTAssertEqual(payload?["key"] as? String, self.testACKey)
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
        XCTAssertEqual(analyticsTagsPayload, self.analyticsTags)
    }
}
