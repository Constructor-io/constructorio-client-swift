//
//  TrackInputFocusRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackInputFocusRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackInputFocusBuilder() {
        let tracker = CIOTrackInputFocusData(searchTerm: searchTerm)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/behavior?"))
        XCTAssertTrue(url.contains("action=focus"), "URL should contain the focus action")
        XCTAssertTrue(url.contains("term=\(encodedSearchTerm)"), "URL should contain the search term")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }

    func testTrackInputFocusBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackInputFocusData(searchTerm: searchTerm)
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix(customBaseURL))
    }

}
