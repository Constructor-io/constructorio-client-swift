//
//  TrackAutocompleteClickRequestBuilderTests.swift
//  SearchFWTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorIO

class TrackAutocompleteClickRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"
    fileprivate let clickedItemName = "testing#@#??!!asd"
    fileprivate let sectionName = "product"

    fileprivate lazy var encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    fileprivate lazy var encodedClickedItemName = clickedItemName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
    fileprivate lazy var encodedSectionName = sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    fileprivate var builder: TrackAutocompleteClickRequestBuilder!

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
    

    
}
