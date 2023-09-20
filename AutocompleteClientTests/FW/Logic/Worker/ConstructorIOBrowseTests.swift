//
//  ConstructorIOBrowseTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class ConstructorIOBrowseTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBrowse_CreatesValidRequest() {
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet")

        let builder = CIOBuilder(expectation: "Calling Browse should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowse_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Browse with valid parameters should return a non-nil response.")

        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet")

        let dataToReturn = TestResource.load(name: TestResource.Response.searchJSONFilename)
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(200, data: dataToReturn))

        self.constructor.browse(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Browse with valid parameters should return a non-nil response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Browse returns non-nil error if API errors out.")

        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet")
    stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(404))

        self.constructor.browse(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Calling Browse returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_AttachesPageParameter() {
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", page: 5)

        let builder = CIOBuilder(expectation: "Calling Browse should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=5&s=\(kRegexSession)&section=Products"), builder.create())
        self.constructor.browse(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowse_AttachesCustomSectionParameter() {
        let customSection = "customSection"
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", section: customSection)

        let builder = CIOBuilder(expectation: "Calling Browse should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=\(customSection)"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowse_AttachesGroupFilter() {
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", filters: CIOQueryFilters(groupFilter: "151", facetFilters: nil))

        let builder = CIOBuilder(expectation: "Calling Browse with a group filter should have a group_id URL query item.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bgroup_id%5D=151&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowse_AttachesFacetFilter() {
        let facetFilters = [(key: "facet1", value: "Organic")]
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))

        let builder = CIOBuilder(expectation: "Calling Browse with a facet filter should have a facet filter URL query item.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bfacet1%5D=Organic&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowse_AttachesMultipleFacetFilters() {
        let facetFilters = [(key: "facet1", value: "Organic"),
                            (key: "facet2", value: "Natural"),
                            (key: "facet10", value: "Whole-grain")]
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))

        let builder = CIOBuilder(expectation: "Calling Browse with multiple facet filters should have a multiple facet URL query items.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bfacet10%5D=Whole-grain&filters%5Bfacet1%5D=Organic&filters%5Bfacet2%5D=Natural&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowse_AttachesMultipleFacetFiltersWithSameNameButDifferentValues() {
        let facetFilters = [(key: "facetOne", value: "Organic"),
                            (key: "facetOne", value: "Natural"),
                            (key: "facetOne", value: "Whole-grain")]
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))

        let builder = CIOBuilder(expectation: "Calling Browse with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5BfacetOne%5D=Natural&filters%5BfacetOne%5D=Organic&filters%5BfacetOne%5D=Whole-grain&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_AttachesVariationsMap() {
        let groupByOptions = [GroupByOption(name: "Country", field: "data.facets.Country")]
        let valueOption = ValueOption(aggregation: "min", field: "data.facets.price")
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["price": valueOption], Dtype: "array"))

        let builder = CIOBuilder(expectation: "Calling Browse with variations map should have a URL query variations map", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products&variations_map=%7B%22dtype%22:%22array%22,%22group_by%22:%5B%7B%22name%22:%22Country%22,%22field%22:%22data.facets.Country%22%7D%5D,%22values%22:%7B%22price%22:%7B%22field%22:%22data.facets.price%22,%22aggregation%22:%22min%22%7D%7D%7D"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_AttachesVariationsMapWithFilterBy() {
        let groupByOptions = [GroupByOption(name: "Country", field: "data.Country")]
        let valueOption = ValueOption(aggregation: "min", field: "data.price")

        let filterValueA = FilterByExpressionValue(fieldPath: "data.size", value: "M")
        let filterValueB = FilterByExpressionValue(fieldPath: "data.size", value: "L")
        let filterValueC = FilterByExpressionValue(fieldPath: "data.length", value: 25)
        let filterValueD = FilterByExpressionValue(fieldPath: "data.in_stock", value: false)
        let filterConditionsNot = FilterByExpressionNot(not: filterValueD)
        let filterConditionsAnd = FilterByExpressionAnd(exprArr: [filterValueA, filterValueC])
        let filterConditionsOr = FilterByExpressionOr(exprArr: [filterValueB, filterConditionsAnd, filterConditionsNot])

        let variationsMap = CIOQueryVariationsMap(GroupBy: groupByOptions, FilterBy: filterConditionsOr, Values: ["price": valueOption], Dtype: "array")

        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", variationsMap: variationsMap)
        let builder = CIOBuilder(expectation: "Calling Browse with variations map should have a URL query variations map", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products&variations_map=%7B%22values%22:%7B%22price%22:%7B%22field%22:%22data.price%22,%22aggregation%22:%22min%22%7D%7D,%22dtype%22:%22array%22,%22filter_by%22:%7B%22or%22:%5B%7B%22field%22:%22data.size%22,%22value%22:%22L%22%7D,%7B%22and%22:%5B%7B%22field%22:%22data.size%22,%22value%22:%22M%22%7D,%7B%22field%22:%22data.length%22,%22value%22:25%7D%5D%7D,%7B%22not%22:%7B%22field%22:%22data.in_stock%22,%22value%22:false%7D%7D%5D%7D,%22group_by%22:%5B%7B%22name%22:%22Country%22,%22field%22:%22data.Country%22%7D%5D%7D"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_AttachesPreFilterExpression() {
        let preFilterExpression = "{\"or\":[{\"and\":[{\"name\":\"group_id\",\"value\":\"electronics-group-id\"},{\"name\":\"Price\",\"range\":[\"-inf\",200.0]}]},{\"and\":[{\"name\":\"Type\",\"value\":\"Laptop\"},{\"not\":{\"name\":\"Price\",\"range\":[800.0,\"inf\"]}}]}]}"
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", preFilterExpression: preFilterExpression)

        let builder = CIOBuilder(expectation: "Calling Browse with pre filter expression should have a URL query pre_filter_expression", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&pre_filter_expression=%7B%22or%22:%5B%7B%22and%22:%5B%7B%22name%22:%22group_id%22,%22value%22:%22electronics-group-id%22%7D,%7B%22name%22:%22Price%22,%22range%22:%5B%22-inf%22,200.0%5D%7D%5D%7D,%7B%22and%22:%5B%7B%22name%22:%22Type%22,%22value%22:%22Laptop%22%7D,%7B%22not%22:%7B%22name%22:%22Price%22,%22range%22:%5B800.0,%22inf%22%5D%7D%7D%5D%7D%5D%7D&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_WithPlusSignInQueryParams_ShouldBeEncoded() {
        let facetFilters = [
            (key: "size", value: "6+"),
            (key: "age", value: "10+")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters)
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", filters: queryFilters)

        let builder = CIOBuilder(expectation: "Calling Browse with 200 should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bage%5D=10%2B&filters%5Bsize%5D=6%2B&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }

    func testBrowse_AttachesGroupsSortOption() {
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .ascending)
        let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet", groupsSortOption: groupsSortOption)

        let builder = CIOBuilder(expectation: "Calling Browse with groups sort option should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&fmt_options%5Bgroups_sort_by%5D=value&fmt_options%5Bgroups_sort_order%5D=ascending&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }

    func testBrowse_UsingBrowseQueryBuilder_WithValidRequest_ReturnsNonNilResponse() {
        let query = CIOBrowseQueryBuilder(filterName: "potato", filterValue: "russet").build()

        let builder = CIOBuilder(expectation: "Calling Browse with valid parameters should return a non-nil response.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_UsingBrowseQueryBuilder_AttachesPageParams() {
        let query = CIOBrowseQueryBuilder(filterName: "potato", filterValue: "russet")
            .setPage(5)
            .setPerPage(50)
            .build()

        let builder = CIOBuilder(expectation: "Calling Browse with valid parameters should return a non-nil response.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=50&page=5&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_UsingBrowseQueryBuilder_AttachesSortOption() {
        let sortOption = CIOSortOption(json: [
            "sort_by": "relevance",
            "sort_order": "descending",
            "status": "selected",
            "display_name": "Relevance"
        ])
        let query = CIOBrowseQueryBuilder(filterName: "potato", filterValue: "russet")
            .setSortOption(sortOption!)
            .build()

        let builder = CIOBuilder(expectation: "Calling Browse with valid parameters should return a non-nil response.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products&sort_by=relevance&sort_order=descending"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_UsingBrowseQueryBuilder_AttachesFacetFilters() {
        let facetFilters = [(key: "facetOne", value: "Organic"),
                            (key: "facetOne", value: "Natural"),
                            (key: "facetOne", value: "Whole-grain")]
        let query = CIOBrowseQueryBuilder(filterName: "potato", filterValue: "russet")
            .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
            .build()

        let builder = CIOBuilder(expectation: "Calling Browse with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))

        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5BfacetOne%5D=Natural&filters%5BfacetOne%5D=Organic&filters%5BfacetOne%5D=Whole-grain&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_UsingBrowseQueryBuilder_AttachesHiddenFields() {
        let hiddenFields = ["hidden_field_1", "hidden_field_2"]
        let query = CIOBrowseQueryBuilder(filterName: "potato", filterValue: "russet")
            .setHiddenFields(hiddenFields)
            .build()

        let builder = CIOBuilder(expectation: "Calling Browse with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&fmt_options%5Bhidden_fields%5D=hidden_field_1&fmt_options%5Bhidden_fields%5D=hidden_field_2&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_UsingBrowseQueryBuilder_AttachesHiddenFacets() {
        let hiddenFacets = ["hidden_facet_1", "hidden_facet_2"]
        let query = CIOBrowseQueryBuilder(filterName: "potato", filterValue: "russet")
            .setHiddenFacets(hiddenFacets)
            .build()

        let builder = CIOBuilder(expectation: "Calling Browse with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&fmt_options%5Bhidden_facets%5D=hidden_facet_1&fmt_options%5Bhidden_facets%5D=hidden_facet_2&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testBrowse_UsingBrowseQueryBuilder_AttachesGroupsSortOption() {
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .ascending)
        let query = CIOBrowseQueryBuilder(filterName: "potato", filterValue: "russet")
            .setGroupsSortOption(groupsSortOption)
            .build()

        let builder = CIOBuilder(expectation: "Calling Browse with groups sort option should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/potato/russet?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&fmt_options%5Bgroups_sort_by%5D=value&fmt_options%5Bgroups_sort_order%5D=ascending&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.browse(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }
}
