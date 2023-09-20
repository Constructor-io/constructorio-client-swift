//
//  ConstructorIOAutocompleteTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class ConstructorIOAutocompleteTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    func testAutocomplete_With200() {
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)

        let builder = CIOBuilder(expectation: "Calling Autocomplete with 200 should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())

        self.constructor.autocomplete(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }

    func testAutocomplete_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling autocomplete with no connectvity should return noConnectivity CIOError.")
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)

        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), noConnectivity())

        self.constructor.autocomplete(forQuery: query) { response in
            if let error = response.error as? CIOError {
                XCTAssertEqual(error, CIOError(errorType: .noConnection), "Returned error from network client should be type CIOError.noConnection.")
                expectation.fulfill()
            }
        }
        self.wait(for: expectation)
    }

    func testAutocomplete_With400() {
        let expectation = self.expectation(description: "Calling autocomplete with 400 should return badRequest CIOError.")
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)

        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(400))

        self.constructor.autocomplete(forQuery: query) { response in
            if let error = response.error as? CIOError {
                XCTAssertEqual(error.errorType, .badRequest, "Returned error from network client should be type CIOError.badRequest.")
                expectation.fulfill()
            }
        }
        self.wait(for: expectation)
    }

    func testAutocomplete_With400AndErrorMessage() {
        let expectation = self.expectation(description: "Calling autocomplete with 500 should return internalServerError CIOError.")
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)
        let errorData = "{\"message\":\"Unknown parameter has been supplied in the request\"}".data(using: .utf8)!

        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(400, data: errorData))

        self.constructor.autocomplete(forQuery: query) { response in
            if let error = response.error as? CIOError {
                XCTAssertEqual(error, CIOError(errorType: .badRequest, errorMessage: "Unknown parameter has been supplied in the request"), "Returned error from network client should be type CIOError, badRequest, and contain an error message.")
                expectation.fulfill()
            }
        }
        self.wait(for: expectation)
    }

    func testAutocomplete_With500() {
        let expectation = self.expectation(description: "Calling autocomplete with 500 should return internalServerError CIOError.")
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)

        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(500))

        self.constructor.autocomplete(forQuery: query) { response in
            if let error = response.error as? CIOError {
                XCTAssertEqual(error.errorType, .internalServerError, "Returned error from network client should be type CIOError, internalServerError.")
                expectation.fulfill()
            }
        }
        self.wait(for: expectation)
    }

    func testAutocomplete_AttachesVariationsMap() {
        let groupByOptions = [GroupByOption(name: "Country", field: "data.facets.Country")]
        let valueOption = ValueOption(aggregation: "min", field: "data.facets.price")
        let query = CIOAutocompleteQuery(query: "potato", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["price": valueOption], Dtype: "array"))

        let builder = CIOBuilder(expectation: "Calling Autocomplete with variations map should have a URL query variations map", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&variations_map=%7B%22dtype%22:%22array%22,%22group_by%22:%5B%7B%22name%22:%22Country%22,%22field%22:%22data.facets.Country%22%7D%5D,%22values%22:%7B%22price%22:%7B%22field%22:%22data.facets.price%22,%22aggregation%22:%22min%22%7D%7D%7D"), builder.create())

        self.constructor.autocomplete(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testAutocomplete_AttachesVariationsMapWithFilterBy() {
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

        let query = CIOAutocompleteQuery(query: "potato", variationsMap: variationsMap)
        let builder = CIOBuilder(expectation: "Calling Autocomplete with variations map should have a URL query variations map", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&variations_map=%7B%22values%22:%7B%22price%22:%7B%22field%22:%22data.price%22,%22aggregation%22:%22min%22%7D%7D,%22dtype%22:%22array%22,%22filter_by%22:%7B%22or%22:%5B%7B%22field%22:%22data.size%22,%22value%22:%22L%22%7D,%7B%22and%22:%5B%7B%22field%22:%22data.size%22,%22value%22:%22M%22%7D,%7B%22field%22:%22data.length%22,%22value%22:25%7D%5D%7D,%7B%22not%22:%7B%22field%22:%22data.in_stock%22,%22value%22:false%7D%7D%5D%7D,%22group_by%22:%5B%7B%22name%22:%22Country%22,%22field%22:%22data.Country%22%7D%5D%7D"), builder.create())

        self.constructor.autocomplete(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testAutocomplete_WithPlusSignInQueryParams_ShouldBeEncoded() {
        let facetFilters = [
            (key: "size", value: "6+"),
            (key: "age", value: "10+")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters)
        let query = CIOAutocompleteQuery(query: "potato", filters: queryFilters)

        let builder = CIOBuilder(expectation: "Calling Autocomplete with 200 should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bage%5D=10%2B&filters%5Bsize%5D=6%2B&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())

        self.constructor.autocomplete(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }

    func testAutocomplete_UsingAutocompleteQueryBuilder_WithValidRequest_ReturnsNonNilResponse() {
        let query = CIOAutocompleteQueryBuilder(query: "potato").build()

        let builder = CIOBuilder(expectation: "Calling autocomplete with valid parameters should return a non-nil response.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/autocomplete/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())

        self.constructor.autocomplete(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testAutocomplete_UsingAutocompleteQueryBuilder_AttachesNumParams() {
        let query = CIOAutocompleteQueryBuilder(query: "potato")
            .setNumResults(10)
            .setNumResultsForSection([
                "Products": 5,
                "Search Suggestions": 6
            ])
            .build()

        let builder = CIOBuilder(expectation: "Calling autocomplete with num result parameters should return a non-nil response.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=10&num_results_Products=5&num_results_Search%20Suggestions=6&s=\(kRegexSession)"), builder.create())

        self.constructor.autocomplete(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testAutocomplete_UsingAutocompleteQueryBuilder_AttachesFacetFilters() {
        let facetFilters = [(key: "facetOne", value: "Organic"),
                            (key: "facetOne", value: "Natural"),
                            (key: "facetOne", value: "Whole-grain")]
        let query = CIOAutocompleteQueryBuilder(query: "potato")
            .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
            .build()

        let builder = CIOBuilder(expectation: "Calling Autocomplete with multiple facet filters with the same name should have multiple filters in the URL", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5BfacetOne%5D=Natural&filters%5BfacetOne%5D=Organic&filters%5BfacetOne%5D=Whole-grain&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())

        self.constructor.autocomplete(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

    func testAutocomplete_UsingAutocompleteQueryBuilder_AttachesHiddenFields() {
        let hiddenFields = ["hidden_field_1", "hidden_field_2"]
        let query = CIOAutocompleteQueryBuilder(query: "potato")
            .setHiddenFields(hiddenFields)
            .build()

        let builder = CIOBuilder(expectation: "Calling Autocomplete with multiple facet filters with the same name should have multiple filters in the URL", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&fmt_options%5Bhidden_fields%5D=hidden_field_1&fmt_options%5Bhidden_fields%5D=hidden_field_2&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())

        self.constructor.autocomplete(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }
}
