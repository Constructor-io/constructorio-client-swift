//
//  ConstructorIORecommendationsTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class ConstructorIORecommendationsTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRecommendations_CreatesValidRequest() {
        let query = CIORecommendationsQuery(podId: "item_page_1")

        let builder = CIOBuilder(expectation: "Calling Recommendations should send a valid request.", builder: http(200))
        print(kRegexVersion)
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
    
    func testRecommendations_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Recommendations with valid parameters should return a non-nil response.")

        let query = CIORecommendationsQuery(podId: "item_page_1")

        let dataToReturn = TestResource.load(name: TestResource.Response.recommendationsJSONFilename)
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=Products"), http(200, data: dataToReturn))

        self.constructor.recommendations(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Recommendations with valid parameters should return a non-nil response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testRecommendations_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Recommendations returns non-nil error if API errors out.")

        let query = CIORecommendationsQuery(podId: "item_page_1")

        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=Products"), http(404))

        self.constructor.recommendations(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Calling Recommendations returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendations_AttachesCustomSectionParameter() {
        let itemId = "P910293"
        let query = CIORecommendationsQuery(podId: "item_page_1", itemId: itemId)

        let builder = CIOBuilder(expectation: "Calling Recommendations with an item id should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=\(itemId)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
    
    func testRecommendations_AttachesItemIdParameter() {
        let term = "pizza"
        let query = CIORecommendationsQuery(podId: "item_page_1", term: term)

        let builder = CIOBuilder(expectation: "Calling Recommendations with a term should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=Products&term=\(term)"), builder.create())

        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testRecommendations_AttachesNumResultsParameter() {
        let customNumResults = 13
        let query = CIORecommendationsQuery(podId: "item_page_1", numResults: customNumResults)

        let builder = CIOBuilder(expectation: "Calling Recommendations with a custom num results count should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=\(customNumResults)&s=\(kRegexSession)&section=Products"), builder.create())
        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testRecommendations_AttachesTermParameter() {
        let customSection = "customSection"
        let query = CIORecommendationsQuery(podId: "item_page_1", section: customSection)

        let builder = CIOBuilder(expectation: "Calling Recommendations with a custom section should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=\(customSection)"), builder.create())

        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testRecommendations_AttachesGroupFilter() {
        let query = CIORecommendationsQuery(podId: "item_page_1", filters: CIOQueryFilters(groupFilter: "151", facetFilters: nil))

        let builder = CIOBuilder(expectation: "Calling Recommendations with a group filter should have a group_id URL query item.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bgroup_id%5D=151&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testRecommendations_AttachesFacetFilter() {
        let facetFilters = [(key: "facet1", value: "facet_value_1")]
        let query = CIORecommendationsQuery(podId: "item_page_1", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))

        let builder = CIOBuilder(expectation: "Calling Recommendations with a facet filter should have a facet filter URL query item.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bfacet1%5D=facet_value_1&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testRecommendations_AttachesMultipleFacetFilters() {
        let facetFilters = [(key: "facet1", value: "Organic"),
                            (key: "facet2", value: "Natural"),
                            (key: "facet10", value: "Whole-grain")]
        let query = CIORecommendationsQuery(podId: "item_page_1", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))

        let builder = CIOBuilder(expectation: "Calling Recommendations with multiple facet filters should have a multiple facet URL query items.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bfacet10%5D=Whole-grain&filters%5Bfacet1%5D=Organic&filters%5Bfacet2%5D=Natural&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testRecommendations_AttachesMultipleFacetFiltersWithSameNameButDifferentValues() {
        let facetFilters = [(key: "facet1", value: "Natural"),
                            (key: "facet1", value: "Organic"),
                            (key: "facet1", value: "Whole-grain")]
        let query = CIORecommendationsQuery(podId: "item_page_1", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))

        let builder = CIOBuilder(expectation: "Calling Recommendations with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
        stub(regex("https://ac.cnstrc.com/recommendations/v1/pods/item_page_1?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bfacet1%5D=Natural&filters%5Bfacet1%5D=Organic&filters%5Bfacet1%5D=Whole-grain&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=5&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.recommendations(forQuery: query, completionHandler: { response in })

        self.wait(for: builder.expectation)
    }

}
