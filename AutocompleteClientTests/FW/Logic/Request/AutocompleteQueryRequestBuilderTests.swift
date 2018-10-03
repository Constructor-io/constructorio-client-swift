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
        self.builder = RequestBuilder(apiKey: self.testACKey)
    }
    
    func testAutocompleteQueryBuilder() {
        let query = CIOAutocompleteQuery(query: self.query)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(endodedQuery)?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResults() {
        let query = CIOAutocompleteQuery(query: self.query, numResults: 20)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(endodedQuery)?"))
        XCTAssertTrue(url.contains("num_results=20"), "URL should contain the num_results URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResultsForSection() {
        let singleSectionQuery = CIOAutocompleteQuery(query: self.query, numResultsForSection: ["section1": 1])
        builder.build(trackData: singleSectionQuery)
        var request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(endodedQuery)?"))
        XCTAssertTrue(url.contains("num_results_section1=1"), "URL should contain the num_results_section URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testAutocompleteQueryBuilder_WithNumResultsForMultipleSections() {
        let multiSectionQuery = CIOAutocompleteQuery(query: self.query, numResultsForSection: ["section1": 3, "section_999": 999])
        builder.build(trackData: multiSectionQuery)
        var request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(endodedQuery)?"))
        XCTAssertTrue(url.contains("num_results_section_999=999"), "URL should contain the num_results_section URL parameter.")
        XCTAssertTrue(url.contains("num_results_section1=3"), "URL should contain the num_results_section URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithNumResultsAndNumResultsForSection() {
        let query = CIOAutocompleteQuery(query: self.query, numResults: 20, numResultsForSection: ["section1": 1, "section_999": 999])
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(endodedQuery)?"))
        XCTAssertTrue(url.contains("num_results_section_999=999"), "URL should contain the num_results_section URL parameter.")
        XCTAssertTrue(url.contains("num_results=20"), "URL should contain the num_results URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testAutocompleteQueryBuilder_ContainsTwoDecimalPlacesForRevenue() {
        let query = CIOAutocompleteQuery(query: self.query, numResults: 20, numResultsForSection: ["section1": 1, "section_999": 999])
        let revenue: Double = 43.58473012
        builder.set(revenue: revenue)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        
        XCTAssertTrue(regex(url, regex: "revenue=43.58[\\D]"), "URL should contain revenue with two decimal places.")
    }

}
