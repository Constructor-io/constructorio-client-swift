//
//  TrackInputFocusRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class TrackInputFocusRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey)
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
}
