//
//  AutocompleteQueryRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class AutocompleteQueryRequestBuilderTests: XCTestCase {

    fileprivate let queryString: String = "testing query?!-123"
    fileprivate var encodedQueryString: String = ""
    fileprivate let testACKey: String = "abcdefgh123"
    fileprivate var builder: AutocompleteQueryRequestBuilder!

    override func setUp() {
        super.setUp()
         self.encodedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
    }
    
    func testAutocompleteQueryBuilder_OnlyQueryString() {
        let query = CIOAutocompleteQuery(query: queryString)
        builder = AutocompleteQueryRequestBuilder(query: query, autocompleteKey: testACKey, session: 1, clientID: nil)
        let request = builder.getRequest()
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedQueryString)?autocomplete_key=\(testACKey)&s=1"))
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResults() {
        let query = CIOAutocompleteQuery(query: queryString, numResults: 20)
        builder = AutocompleteQueryRequestBuilder(query: query, autocompleteKey: testACKey, session: 1, clientID: nil)
        let request = builder.getRequest()
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedQueryString)?autocomplete_key=\(testACKey)&num_results=20&s=1"))
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResultsForSection() {
        // one section
        let singleSectionQuery = CIOAutocompleteQuery(query: queryString, numResultsForSection: ["section1": 1])
        builder = AutocompleteQueryRequestBuilder(query: singleSectionQuery, autocompleteKey: testACKey, session: 1, clientID: nil)
        var request = builder.getRequest()
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedQueryString)?autocomplete_key=\(testACKey)&num_results_section1=1&s=1"))
        XCTAssertEqual(request.httpMethod, "GET")


        // multiple sections
        let multiSectionQuery = CIOAutocompleteQuery(query: queryString, numResultsForSection: ["section1": 1, "section_999": 999])
        builder = AutocompleteQueryRequestBuilder(query: multiSectionQuery, autocompleteKey: testACKey, session: 1, clientID: nil)
        request = builder.getRequest()
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedQueryString)?autocomplete_key=\(testACKey)&num_results_section_999=999&num_results_section1=1&s=1"))
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResultsAndNumResultsForSection() {
        let query = CIOAutocompleteQuery(query: queryString, numResults: 20, numResultsForSection: ["section1": 1, "section_999": 999])
        builder = AutocompleteQueryRequestBuilder(query: query, autocompleteKey: testACKey, session: 1, clientID: nil)
        let request = builder.getRequest()
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedQueryString)?autocomplete_key=\(testACKey)&num_results=20&num_results_section_999=999&num_results_section1=1&s=1"))
        XCTAssertEqual(request.httpMethod, "GET")
    }

}
