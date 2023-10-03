//
//  ConstructorIOSearchTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class ConstructorIOSearchTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSearch_CreatesValidRequest() {
        let query = CIOSearchQuery(query: "potato")

        let builder = CIOBuilder(expectation: "Calling Search should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testSearch_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Search with valid parameters should return a non-nil response.")

        let query = CIOSearchQuery(query: "potato")

        let dataToReturn = TestResource.load(name: TestResource.Response.searchJSONFilename)
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(200, data: dataToReturn))

        self.constructor.search(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Search with valid parameters should return a non-nil response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Search returns non-nil error if API errors out.")

        let query = CIOSearchQuery(query: "potato")

        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(404))

        self.constructor.search(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Calling Search returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_AttachesPageParameter() {
        let query = CIOSearchQuery(query: "potato", page: 5)

        let builder = CIOBuilder(expectation: "Calling Search should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=5&s=\(kRegexSession)&section=Products"), builder.create())
        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testSearch_AttachesCustomSectionParameter() {
        let customSection = "customSection"
        let query = CIOSearchQuery(query: "potato", section: customSection)

        let builder = CIOBuilder(expectation: "Calling Search should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=\(customSection)"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testRedirect_hasCorrectURL() {
        let exp = self.expectation(description: "Redirect response should have a correct URL.")

        stub(regex("https://ac.cnstrc.com/search/dior?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(200, data: TestResource.load(name: TestResource.Response.searchJSONRedirectFile)))

        self.constructor.search(forQuery: CIOSearchQuery(query: "dior")) { response in
            guard let redirectInfo = response.data?.redirectInfo else {
                XCTFail("Invalid response")
                return
            }
            XCTAssertEqual(redirectInfo.url, "/brand/dior")
            exp.fulfill()
        }

        self.waitForExpectationWithDefaultHandler()
    }

    func testRedirect_hasCorrectMatchID() {
        let exp = self.expectation(description: "Redirect response should have a correct Match ID.")
        stub(regex("https://ac.cnstrc.com/search/dior?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(200, data: TestResource.load(name: TestResource.Response.searchJSONRedirectFile)))

        self.constructor.search(forQuery: CIOSearchQuery(query: "dior")) { response in
            guard let redirectInfo = response.data?.redirectInfo else {
                XCTFail("Invalid response")
                return
            }
            XCTAssertEqual(redirectInfo.matchID, 16257)
            exp.fulfill()
        }
        self.waitForExpectationWithDefaultHandler()
    }

    func testRedirect_hasCorrectRuleID() {
        let exp = self.expectation(description: "Redirect response should have a correct Rule ID.")

        stub(regex("https://ac.cnstrc.com/search/dior?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(200, data: TestResource.load(name: TestResource.Response.searchJSONRedirectFile)))

        self.constructor.search(forQuery: CIOSearchQuery(query: "dior")) { response in
            guard let redirectInfo = response.data?.redirectInfo else {
                XCTFail("Invalid response")
                return
            }
            XCTAssertEqual(redirectInfo.ruleID, 8860)
            exp.fulfill()
        }

        self.waitForExpectationWithDefaultHandler()
    }

    func testSearch_AttachesGroupFilter() {
        let query = CIOSearchQuery(query: "potato", filters: CIOQueryFilters(groupFilter: "151", facetFilters: nil))

        let builder = CIOBuilder(expectation: "Calling Search with a group filter should have a group_id URL query item.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bgroup_id%5D=151&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testSearch_AttachesFacetFilter() {
        let facetFilters = [(key: "facet1", value: "Organic")]
        let query = CIOSearchQuery(query: "potato", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))

        let builder = CIOBuilder(expectation: "Calling Search with a facet filter should have a facet filter URL query item.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bfacet1%5D=Organic&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testSearch_AttachesMultipleFacetFilters() {
        let facetFilters = [(key: "facet1", value: "Organic"),
                            (key: "facet2", value: "Natural"),
                            (key: "facet10", value: "Whole-grain")]
        let query = CIOSearchQuery(query: "potato", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))

        let builder = CIOBuilder(expectation: "Calling Search with multiple facet filters should have a multiple facet URL query items.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bfacet10%5D=Whole-grain&filters%5Bfacet1%5D=Organic&filters%5Bfacet2%5D=Natural&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testSearch_AttachesMultipleFacetFiltersWithSameNameButDifferentValues() {
        let facetFilters = [(key: "facetOne", value: "Organic"),
                            (key: "facetOne", value: "Natural"),
                            (key: "facetOne", value: "Whole-grain")]
        let query = CIOSearchQuery(query: "potato", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))

        let builder = CIOBuilder(expectation: "Calling Search with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5BfacetOne%5D=Natural&filters%5BfacetOne%5D=Organic&filters%5BfacetOne%5D=Whole-grain&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_AttachesVariationsMap() {
        let groupByOptions = [GroupByOption(name: "Country", field: "data.facets.Country")]
        let valueOption = ValueOption(aggregation: "min", field: "data.facets.price")
        let query = CIOSearchQuery(query: "potato", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["price": valueOption], Dtype: "array"))

        let builder = CIOBuilder(expectation: "Calling Search with variations map should have a URL query variations map", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products&variations_map=%7B%22dtype%22:%22array%22,%22group_by%22:%5B%7B%22name%22:%22Country%22,%22field%22:%22data.facets.Country%22%7D%5D,%22values%22:%7B%22price%22:%7B%22field%22:%22data.facets.price%22,%22aggregation%22:%22min%22%7D%7D%7D"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_AttachesVariationsMapWithFilterBy() {
        let groupByOptions = [GroupByOption(name: "Country", field: "data.facets.Country")]
        let valueOption = ValueOption(aggregation: "min", field: "data.facets.price")

        let filterValueA = FilterByExpressionValue(fieldPath: "data.size", value: "M")
        let filterValueB = FilterByExpressionValue(fieldPath: "data.size", value: "L")
        let filterValueC = FilterByExpressionValue(fieldPath: "data.length", value: 25)
        let filterValueD = FilterByExpressionValue(fieldPath: "data.in_stock", value: false)
        let filterConditionsNot = FilterByExpressionNot(not: filterValueD)
        let filterConditionsAnd = FilterByExpressionAnd(exprArr: [filterValueA, filterValueC])
        let filterConditionsOr = FilterByExpressionOr(exprArr: [filterValueB, filterConditionsAnd, filterConditionsNot])

        let variationsMap = CIOQueryVariationsMap(GroupBy: groupByOptions, FilterBy: filterConditionsOr, Values: ["price": valueOption], Dtype: "array")

        let query = CIOSearchQuery(query: "potato", variationsMap: variationsMap)
        let builder = CIOBuilder(expectation: "Calling Search with variations map should have a URL query variations map", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products&variations_map=%7B%22values%22:%7B%22price%22:%7B%22field%22:%22data.facets.price%22,%22aggregation%22:%22min%22%7D%7D,%22dtype%22:%22array%22,%22filter_by%22:%7B%22or%22:%5B%7B%22field%22:%22data.size%22,%22value%22:%22L%22%7D,%7B%22and%22:%5B%7B%22field%22:%22data.size%22,%22value%22:%22M%22%7D,%7B%22field%22:%22data.length%22,%22value%22:25%7D%5D%7D,%7B%22not%22:%7B%22field%22:%22data.in_stock%22,%22value%22:false%7D%7D%5D%7D,%22group_by%22:%5B%7B%22name%22:%22Country%22,%22field%22:%22data.facets.Country%22%7D%5D%7D"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_AttachesVariationsMapWithFilterByEscapedJsonString() {
        let groupByOptions = [GroupByOption(name: "Country", field: "data.facets.Country")]
        let valueOption = ValueOption(aggregation: "min", field: "data.facets.price")
        let FilterByJsonStr = "{\"or\":[{\"field\":\"data.size\",\"value\":\"L\"},{\"and\":[{\"field\":\"data.size\",\"value\":\"M\"},{\"field\":\"data.length\",\"value\":25}]},{\"not\":{\"field\":\"data.in_stock\",\"value\":false}}]}"

        let variationsMap = CIOQueryVariationsMap(GroupBy: groupByOptions, FilterBy: FilterByJsonStr, Values: ["price": valueOption], Dtype: "array")

        let query = CIOSearchQuery(query: "potato", variationsMap: variationsMap)
        let builder = CIOBuilder(expectation: "Calling Search with variations map should have a URL query variations map", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products&variations_map=%7B%22dtype%22:%22array%22,%22group_by%22:%5B%7B%22name%22:%22Country%22,%22field%22:%22data.facets.Country%22%7D%5D,%22values%22:%7B%22price%22:%7B%22field%22:%22data.facets.price%22,%22aggregation%22:%22min%22%7D%7D,%22filter_by%22:%7B%22or%22:%5B%7B%22field%22:%22data.size%22,%22value%22:%22L%22%7D,%7B%22and%22:%5B%7B%22field%22:%22data.size%22,%22value%22:%22M%22%7D,%7B%22field%22:%22data.length%22,%22value%22:25%7D%5D%7D,%7B%22not%22:%7B%22field%22:%22data.in_stock%22,%22value%22:false%7D%7D%5D%7D%7D"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_AttachesPreFilterExpression() {
        let preFilterExpression = "{\"or\":[{\"and\":[{\"name\":\"group_id\",\"value\":\"electronics-group-id\"},{\"name\":\"Price\",\"range\":[\"-inf\",200.0]}]},{\"and\":[{\"name\":\"Type\",\"value\":\"Laptop\"},{\"not\":{\"name\":\"Price\",\"range\":[800.0,\"inf\"]}}]}]}"
        let query = CIOSearchQuery(query: "potato", preFilterExpression: preFilterExpression)

        let builder = CIOBuilder(expectation: "Calling Search with pre filter expression should have a URL query pre_filter_expression", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&pre_filter_expression=%7B%22or%22:%5B%7B%22and%22:%5B%7B%22name%22:%22group_id%22,%22value%22:%22electronics-group-id%22%7D,%7B%22name%22:%22Price%22,%22range%22:%5B%22-inf%22,200.0%5D%7D%5D%7D,%7B%22and%22:%5B%7B%22name%22:%22Type%22,%22value%22:%22Laptop%22%7D,%7B%22not%22:%7B%22name%22:%22Price%22,%22range%22:%5B800.0,%22inf%22%5D%7D%7D%5D%7D%5D%7D&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_WithPlusSignInQueryParams_ShouldBeEncoded() {
        let facetFilters = [
            (key: "size", value: "6+"),
            (key: "age", value: "10+")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters)
        let query = CIOSearchQuery(query: "potato", filters: queryFilters)

        let builder = CIOBuilder(expectation: "Calling Search with 200 should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bage%5D=10%2B&filters%5Bsize%5D=6%2B&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }

    func testSearch_AttachesGroupsSortOption() {
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .ascending)
        let query = CIOSearchQuery(query: "potato", groupsSortOption: groupsSortOption)

        let builder = CIOBuilder(expectation: "Calling Search with 200 should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&fmt_options%5Bgroups_sort_by%5D=value&fmt_options%5Bgroups_sort_order%5D=ascending&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }

    func testSearch_UsingSearchQueryBuilder_WithValidRequest_ReturnsNonNilResponse() {
        let query = CIOSearchQueryBuilder(query: "potato").build()

        let builder = CIOBuilder(expectation: "Calling Search with valid parameters should return a non-nil response.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_UsingSearchQueryBuilder_AttachesPageParams() {
        let query = CIOSearchQueryBuilder(query: "potato")
            .setPage(5)
            .setPerPage(50)
            .build()

        let builder = CIOBuilder(expectation: "Calling Search with valid parameters should return a non-nil response.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=50&page=5&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_UsingSearchQueryBuilder_AttachesSortOption() {
        let sortOption = CIOSortOption(json: [
            "sort_by": "relevance",
            "sort_order": "descending",
            "status": "selected",
            "display_name": "Relevance"
        ])
        let query = CIOSearchQueryBuilder(query: "potato")
            .setSortOption(sortOption!)
            .build()

        let builder = CIOBuilder(expectation: "Calling Search with valid parameters should return a non-nil response.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products&sort_by=relevance&sort_order=descending"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_UsingSearchQueryBuilder_AttachesFacetFilters() {
        let facetFilters = [(key: "facetOne", value: "Organic"),
                            (key: "facetOne", value: "Natural"),
                            (key: "facetOne", value: "Whole-grain")]
        let query = CIOSearchQueryBuilder(query: "potato")
            .setPage(5)
            .setPerPage(50)
            .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
            .build()

        let builder = CIOBuilder(expectation: "Calling Search with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5BfacetOne%5D=Natural&filters%5BfacetOne%5D=Organic&filters%5BfacetOne%5D=Whole-grain&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=50&page=5&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_UsingSearchQueryBuilder_AttachesHiddenFields() {
        let hiddenFields = ["hidden_field_1", "hidden_field_2"]
        let query = CIOSearchQueryBuilder(query: "potato")
            .setHiddenFields(hiddenFields)
            .build()

        let builder = CIOBuilder(expectation: "Calling Search with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&fmt_options%5Bhidden_fields%5D=hidden_field_1&fmt_options%5Bhidden_fields%5D=hidden_field_2&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testSearch_UsingSearchQueryBuilder_AttachesHiddenFacets() {
        let hiddenFacets = ["hidden_facet_1", "hidden_facet_2"]
        let query = CIOSearchQueryBuilder(query: "potato")
            .setHiddenFacets(hiddenFacets)
            .build()

        let builder = CIOBuilder(expectation: "Calling Search with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&fmt_options%5Bhidden_facets%5D=hidden_facet_1&fmt_options%5Bhidden_facets%5D=hidden_facet_2&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testSearch_UsingSearchQueryBuilder_AttachesGroupsSortOption() {
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .ascending)
        let query = CIOSearchQueryBuilder(query: "potato")
            .setGroupsSortOption(groupsSortOption)
            .build()

        let builder = CIOBuilder(expectation: "Calling Search with 200 should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&fmt_options%5Bgroups_sort_by%5D=value&fmt_options%5Bgroups_sort_order%5D=ascending&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.search(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }
}
