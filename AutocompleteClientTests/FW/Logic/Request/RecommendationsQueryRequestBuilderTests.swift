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

    func testRecommendationsQueryBuilder_WithVariationId() {
        let query = CIORecommendationsQuery(podID: self.podID, itemID: "lemon_chicken", variationID: "lemon_chicken_spicy")
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pods/\(podID)?"))
        XCTAssertTrue(url.contains("item_id=lemon_chicken"), "URL should contain the item_id URL parameter.")
        XCTAssertTrue(url.contains("variation_id=lemon_chicken_spicy"), "URL should contain the variation_id URL parameter.")
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

    func testRecommendationPageQueryBuilder() {
        let query = CIORecommendationPageQuery(pageID: "pdp_b2c", itemID: "product-123", shared: CIORecommendationPagePodOverride(numResults: 10))
        builder.build(trackData: query)
        let request = builder.getRequest()
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
        let items = components.queryItems ?? []

        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/recommendations/v1/pages/pdp_b2c?"))
        XCTAssertEqual(items.first { $0.name == "key" }?.value, testACKey)
        XCTAssertEqual(items.first { $0.name == "item_id" }?.value, "product-123")
        XCTAssertEqual(items.first { $0.name == "num_results" }?.value, "10")
        XCTAssertEqual(items.first { $0.name == "section" }?.value, "Products")
        XCTAssertFalse(items.contains { $0.name.hasPrefix("pod_overrides") })
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testRecommendationPageQueryBuilder_WithPodOverrides() {
        let preFilterExpression = "{\"or\":[{\"name\":\"brand\",\"value\":\"acme\"}]}"
        let query = CIORecommendationPageQuery(
            pageID: "pdp_b2c",
            itemID: "product-123",
            shared: CIORecommendationPagePodOverride(numResults: 10),
            podOverrides: [
                "similar_items": CIORecommendationPagePodOverride(numResults: 0),
                "complete_the_look": CIORecommendationPagePodOverride(
                    numResults: 8,
                    filters: CIOQueryFilters(groupFilter: "shoes", facetFilters: [(key: "color", value: "red"), (key: "color", value: "blue")]),
                    filterMatchTypes: ["color": "all"],
                    hiddenFields: ["inventory", "margin"],
                    preFilterExpression: preFilterExpression,
                    fmtOptions: [(key: "groups_max_depth", value: "2")]
                )
            ]
        )
        builder.build(trackData: query)
        let request = builder.getRequest()
        let items = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!.queryItems ?? []
        let values = { (name: String) -> [String] in items.filter { $0.name == name }.compactMap { $0.value } }
        let prefix = "pod_overrides[complete_the_look]"

        XCTAssertEqual(values("num_results"), ["10"])
        XCTAssertEqual(values("pod_overrides[similar_items][num_results]"), ["0"])
        XCTAssertEqual(values("\(prefix)[num_results]"), ["8"])
        XCTAssertEqual(values("\(prefix)[filters][group_id]"), ["shoes"])
        XCTAssertEqual(values("\(prefix)[filters][color]"), ["blue", "red"])
        XCTAssertEqual(values("\(prefix)[filter_match_types][color]"), ["all"])
        XCTAssertEqual(values("\(prefix)[fmt_options][hidden_fields]"), ["inventory", "margin"])
        XCTAssertEqual(values("\(prefix)[fmt_options][groups_max_depth]"), ["2"])
        XCTAssertEqual(values("\(prefix)[pre_filter_expression]"), [preFilterExpression])
        XCTAssertTrue(request.url!.absoluteString.contains("pod_overrides%5Bsimilar_items%5D%5Bnum_results%5D=0"))
    }

    func testRecommendationPageQuery_NestsParameterNames() {
        XCTAssertEqual(CIORecommendationPageQuery.nest(name: "num_results", under: "pod_overrides[p]"), "pod_overrides[p][num_results]")
        XCTAssertEqual(CIORecommendationPageQuery.nest(name: "filters[color]", under: "pod_overrides[p]"), "pod_overrides[p][filters][color]")
    }
}
