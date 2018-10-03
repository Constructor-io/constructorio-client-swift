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
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.builder = RequestBuilder(autocompleteKey: self.testACKey)
    }
    
    func testVersionString_ContainsCorrectPrefix(){
        XCTAssertTrue(Constants.versionString().hasPrefix("cioios-"), "Version string should have the cioios prefix.")
    }
    
    func testAutocompleteQueryBuilder_ContainsVersionString() {
        let query = CIOAutocompleteQuery(query: queryString)
        builder.build(trackData: query)
        let request = builder.getRequest()
        
        let versionString = Constants.versionString()
        let containsVersionString = request.url!.absoluteString.contains(versionString)
        XCTAssertTrue(containsVersionString, "Query should contain the version string.")
    }
    
    func testAutocompleteQueryBuilder_OnlyQueryString() {
        let query = CIOAutocompleteQuery(query: queryString)
        builder.build(trackData: query)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string URL parameter.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResults() {
        let query = CIOAutocompleteQuery(query: queryString, numResults: 20)
        builder.build(trackData: query)
        let request = builder.getRequest()

        XCTAssertTrue(request.url!.absoluteString.contains("num_results=20"), "URL should contain the num_results URL parameter.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResultsForSection() {
        // one section
        let singleSectionQuery = CIOAutocompleteQuery(query: queryString, numResultsForSection: ["section1": 1])
        builder.build(trackData: singleSectionQuery)
        var request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("num_results_section1=1"), "URL should contain the num_results_section URL parameter.")
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testAutocompleteQueryBuilder_WithNumResultsForMultipleSections() {
        // multiple sections
        let multiSectionQuery = CIOAutocompleteQuery(query: queryString, numResultsForSection: ["section1": 3, "section_999": 999])
        builder.build(trackData: multiSectionQuery)
        var request = builder.getRequest()
        print("URL IS \(request.url!.absoluteString)")
        XCTAssertTrue(request.url!.absoluteString.contains("num_results_section_999=999"), "URL should contain the num_results_section URL parameter.")
        XCTAssertTrue(request.url!.absoluteString.contains("num_results_section1=3"), "URL should contain the num_results_section URL parameter.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResultsAndNumResultsForSection() {
        let query = CIOAutocompleteQuery(query: queryString, numResults: 20, numResultsForSection: ["section1": 1, "section_999": 999])
        builder.build(trackData: query)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("num_results_section_999=999"), "URL should contain the num_results_section URL parameter.")
        XCTAssertTrue(request.url!.absoluteString.contains("num_results=20"), "URL should contain the num_results URL parameter.")

        XCTAssertEqual(request.httpMethod, "GET")
    }

}
