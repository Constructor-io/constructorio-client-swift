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

    fileprivate let query: String = "testing query?!-123"
    fileprivate var endodedQuery: String = ""
    fileprivate let testACKey: String = "abcdefgh123"
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.endodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.builder = RequestBuilder(autocompleteKey: self.testACKey)
    }
    
    func testAutocompleteQueryBuilder() {
        let query = CIOAutocompleteQuery(query: self.query)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(endodedQuery)?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("autocomplete_key=\(testACKey)"), "URL should contain autocomplete key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResults() {
        let query = CIOAutocompleteQuery(query: self.query, numResults: 20)
        builder.build(trackData: query)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("num_results=20"), "URL should contain the num_results URL parameter.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResultsForSection() {
        let singleSectionQuery = CIOAutocompleteQuery(query: self.query, numResultsForSection: ["section1": 1])
        builder.build(trackData: singleSectionQuery)
        var request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("num_results_section1=1"), "URL should contain the num_results_section URL parameter.")
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testAutocompleteQueryBuilder_WithNumResultsForMultipleSections() {
        let multiSectionQuery = CIOAutocompleteQuery(query: self.query, numResultsForSection: ["section1": 3, "section_999": 999])
        builder.build(trackData: multiSectionQuery)
        var request = builder.getRequest()
        print("URL IS \(request.url!.absoluteString)")
        XCTAssertTrue(request.url!.absoluteString.contains("num_results_section_999=999"), "URL should contain the num_results_section URL parameter.")
        XCTAssertTrue(request.url!.absoluteString.contains("num_results_section1=3"), "URL should contain the num_results_section URL parameter.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResultsAndNumResultsForSection() {
        let query = CIOAutocompleteQuery(query: self.query, numResults: 20, numResultsForSection: ["section1": 1, "section_999": 999])
        builder.build(trackData: query)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("num_results_section_999=999"), "URL should contain the num_results_section URL parameter.")
        XCTAssertTrue(request.url!.absoluteString.contains("num_results=20"), "URL should contain the num_results URL parameter.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

}
