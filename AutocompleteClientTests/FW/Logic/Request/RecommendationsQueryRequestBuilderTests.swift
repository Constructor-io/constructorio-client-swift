//
//  RecommendationsQueryRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class RecommendationsQueryRequestBuilderTests: XCTestCase {

    fileprivate let podID: String = "test_pod"
    fileprivate let testACKey: String = "abcdefgh123"
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: self.testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testRecommendationsQueryBuilder() {
        let query = CIORecommendationsQuery(podID: self.podID)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pods/\(podID)?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testRecommendationsQueryBuilder_WithNumResults() {
        let query = CIORecommendationsQuery(podID: self.podID, numResults: 10)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pods/\(podID)?"))
        XCTAssertTrue(url.contains("num_results=10"), "URL should contain the num_results URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testRecommendationsQueryBuilder_WithTerm() {
        let query = CIORecommendationsQuery(podID: self.podID, term: "squeeze")
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pods/\(podID)?"))
        XCTAssertTrue(url.contains("term=squeeze"), "URL should contain the term URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testRecommendationsQueryBuilder_WithItemId() {
        let query = CIORecommendationsQuery(podID: self.podID, itemID: "lemon_chicken")
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pods/\(podID)?"))
        XCTAssertTrue(url.contains("item_id=lemon_chicken"), "URL should contain the item_id URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testRecommendationsQueryBuilder_WithFacetFilters() {
        let facetFilters = [
            (key: "Nutrition", value: "Organic"),
            (key: "Nutrition", value: "Natural"),
            (key: "Brand", value: "Kroger")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters)
        let query = CIORecommendationsQuery(podID: self.podID, filters: queryFilters)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pods/\(podID)?"))
        XCTAssertTrue(url.contains("filters%5BNutrition%5D=Organic"), "URL should contain the Nutrition facet filter Organic in the URL parameter.")
        XCTAssertTrue(url.contains("filters%5BNutrition%5D=Natural"), "URL should contain the Nutrition facet filter Natural in the URL parameter.")
        XCTAssertTrue(url.contains("filters%5BBrand%5D=Kroger"), "URL should contain the Brand facet filter Kroger in the URL parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testRecommendationsQueryBuilder_WithGroupFilters() {
        let queryFilters = CIOQueryFilters(groupFilter: "101", facetFilters: nil)
        let query = CIORecommendationsQuery(podID: self.podID, filters: queryFilters)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pods/\(podID)?"))
        XCTAssertTrue(url.contains("filters%5Bgroup_id%5D=101"), "URL should contain the group filter in the URL paramater.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testRecommendationsQueryBuilder_WithFacetAndGroupFilters() {
        let facetFilters = [
            (key: "Nutrition", value: "Organic"),
            (key: "Nutrition", value: "Natural"),
            (key: "Brand", value: "Kroger")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: "101", facetFilters: facetFilters)
        let query = CIORecommendationsQuery(podID: self.podID, filters: queryFilters)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pods/\(podID)?"))
        XCTAssertTrue(url.contains("filters%5BNutrition%5D=Organic"), "URL should contain the Nutrition facet filter Organic in the URL parameter.")
        XCTAssertTrue(url.contains("filters%5BNutrition%5D=Natural"), "URL should contain the Nutrition facet filter Natural in the URL parameter.")
        XCTAssertTrue(url.contains("filters%5BBrand%5D=Kroger"), "URL should contain the Brand facet filter Kroger in the URL parameter.")
        XCTAssertTrue(url.contains("filters%5Bgroup_id%5D=101"), "URL should contain the group filter in the URL paramater.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testRecommendationsQueryBuilder_WithCustomBaseURL() {
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: self.testACKey, baseURL: customBaseURL)

        let query = CIORecommendationsQuery(podID: self.podID)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("\(customBaseURL)/recommendations/v1/pods/\(podID)?"))
    }
    
    func testRecommendationsQueryBuilder_WithHiddenFields() {
        let hiddenFields = ["hiddenField1", "hiddenField2"]
        let query = CIORecommendationsQuery(podID: self.podID, hiddenFields: hiddenFields)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pods/\(podID)?"))
        XCTAssertTrue(url.contains("fmt_options%5Bhidden_fields%5D=hiddenField1&fmt_options%5Bhidden_fields%5D=hiddenField2"), "URL should contain hidden field parameters.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }
}
