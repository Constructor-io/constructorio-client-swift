//
//  AutocompleteQueryRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class AutocompleteQueryRequestBuilderTests: XCTestCase {
    fileprivate let query: String = "testing query?!-123"
    fileprivate var endodedQuery: String = ""
    fileprivate let testACKey: String = "abcdefgh123"
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.endodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.builder = RequestBuilder(apiKey: self.testACKey, baseURL: Constants.Query.baseURLString)
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
        let request = builder.getRequest()
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
        let request = builder.getRequest()
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

    func testAutocompleteQueryBuilder_WithCustomBaseURL() {
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: self.testACKey, baseURL: customBaseURL)

        let query = CIOAutocompleteQuery(query: self.query)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        XCTAssertTrue(url.hasPrefix("\(customBaseURL)/autocomplete/\(endodedQuery)?"))
    }

    func testAutocompleteQueryBuilder_WithAGroupFilter() {
        let facetFilters = [
            (key: "Nutrition", value: "Organic")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters)
        let query = CIOAutocompleteQuery(query: self.query, filters: queryFilters, numResults: 20)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(endodedQuery)?"))
        XCTAssertTrue(url.contains("filters%5BNutrition%5D=Organic"), "URL should contain the Nutrition facet filter.")
        XCTAssertTrue(url.contains("num_results=20"), "URL should contain the num_results URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithAFacetFilter() {
        let queryFilters = CIOQueryFilters(groupFilter: "101", facetFilters: nil)
        let query = CIOAutocompleteQuery(query: self.query, filters: queryFilters, numResults: 20)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(endodedQuery)?"))
        XCTAssertTrue(url.contains("filters%5Bgroup_id%5D=101"), "URL should contain the group filter.")
        XCTAssertTrue(url.contains("num_results=20"), "URL should contain the num_results URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAutocompleteQueryBuilder_WithHiddenFields() {
        let hiddenFields = ["hiddenField1", "hiddenField2"]
        let query = CIOAutocompleteQuery(query: self.query, numResults: 20, hiddenFields: hiddenFields)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(endodedQuery)?"))
        XCTAssertTrue(url.contains("fmt_options%5Bhidden_fields%5D=hiddenField1&fmt_options%5Bhidden_fields%5D=hiddenField2"), "URL should contain hidden field parameters.")
        XCTAssertTrue(url.contains("num_results=20"), "URL should contain the num_results URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }
}
