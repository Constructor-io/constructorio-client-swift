//
//  TrackSearchResultsLoadedRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackSearchResultsLoadedRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"
    fileprivate let resultCount = 123

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackSearchResultsLoadedBuilder() {
        let tracker = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/behavior?"))
        XCTAssertTrue(url.contains("action=search-results"), "URL should contain the search-results action")
        XCTAssertTrue(url.contains("term=\(encodedSearchTerm)"), "URL should contain the search term")
        XCTAssertTrue(url.contains("num_results=\(resultCount)"), "URL should contain the number of results")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }
}
