//
//  TrackQuizResultsLoadedRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackQuizResultsLoadedRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"

    // Required Parameters
    let quizID = "coffee quiz"
    let quizVersionID = "1231243"
    let quizSessionID = "13443"
    let url = "www.example.com"

    // Optional Parameters
    let resultID = "12312"
    let resultPage = 1
    let resultCount = 12
    let sectionName = "Products"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackQuizResultsLoadedBuilder() {
        let tracker = CIOTrackQuizResultsLoadedData(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, url: self.url, resultID: self.resultID, resultPage: self.resultPage, resultCount: self.resultCount, sectionName: self.sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["quiz_id"] as? String, self.quizID)
        XCTAssertEqual(payload?["quiz_version_id"] as? String, self.quizVersionID)
        XCTAssertEqual(payload?["quiz_session_id"] as? String, self.quizSessionID)
        XCTAssertEqual(payload?["url"] as? String, self.url)
        XCTAssertEqual(payload?["result_id"] as? String, self.resultID)
        XCTAssertEqual(payload?["result_page"] as? Int, self.resultPage)
        XCTAssertEqual(payload?["result_count"] as? Int, self.resultCount)
        XCTAssertEqual(payload?["section"] as? String, self.sectionName)
        
        XCTAssertEqual(payload?["key"] as? String, self.testACKey)
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
    }
}
