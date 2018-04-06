//
//  TrackAutocompleteClickRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackAutocompleteClickRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"
    fileprivate let clickedItemName = "testing#@#??!!asd"
    fileprivate let sectionName = "product"

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedClickedItemName: String = ""
    fileprivate var encodedSectionName: String = ""
    fileprivate var builder: TrackAutocompleteClickRequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedClickedItemName = clickedItemName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedSectionName = sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func testTrackACClickBuilder_sectionNameSpecified_selectType() {
        let tracker = CIOAutocompleteClickTracker(searchTerm: searchTerm, clickedItemName: clickedItemName, sectionName: sectionName)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedClickedItemName)/select?autocomplete_key=\(testACKey)&original_query=\(encodedSearchTerm)&autocomplete_section=\(encodedSectionName)&tr=click&_dt=\(requestDate)"))
    }

    func testTrackACClickBuilder_sectionNameUnspecified_searchType() {
        let tracker = CIOAutocompleteClickTracker(searchTerm: searchTerm, clickedItemName: clickedItemName)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedClickedItemName)/search?autocomplete_key=\(testACKey)&original_query=\(encodedSearchTerm)&tr=click&_dt=\(requestDate)"))
    }
    
    func testTrackACClickBuilder_containsVersionString() {
        let tracker = CIOAutocompleteClickTracker(searchTerm: searchTerm, clickedItemName: clickedItemName)
        builder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        
        let versionString = Constants.versionString()
        let containsVersionString = request.url!.absoluteString.contains(versionString)
        XCTAssertTrue(containsVersionString, "Track call should contain the version string.")
    }
    
}
