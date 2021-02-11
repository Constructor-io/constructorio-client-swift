//
//  ConstructorIORecommendationsTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
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
        let query = CIORecommendationsQuery(podId: "movie_pod_best_sellers")

        let builder = CIOBuilder(expectation: "Calling Recommendations should send a valid  request.", builder: http(200))
            stub(regex("https://ac.cnstrc.com/v1/recommendations/pods/potato_pod_1?_dt=\(kRegexTimestamp)&c=cioios-&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)&section=Products"), builder.create())
    
        self.constructor.recommendations(forQuery: query, completionHandler: {
            response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            builder.expectation.fulfill()
        })
        self.wait(for: builder.expectation)
    }

    func testRecommendations_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Recommendations with valid parameters should return a non-nil response.")

        let query = CIORecommendationsQuery(podId: "movie_pod_best_sellers")

        let dataToReturn = TestResource.load(name: TestResource.Response.recommendationsJSONFilename)
            stub(regex("https://ac.cnstrc   .com/recommendations/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(200, data: dataToReturn))

        self.constructor.recommendations(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Recommendations with valid parameters should return a non-nil response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
//
//    func testRecommendations_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
//        let expectation = self.expectation(description: "Calling Recommendations returns non-nil error if API errors out.")
//
//        let query = CIORecommendationsQuery(query: "potato")
//
//        stub(regex("https://ac.cnstrc.com/recommendations/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(404))
//
//        self.constructor.recommendations(forQuery: query, completionHandler: { response in
//            XCTAssertNotNil(response.error, "Calling Recommendations returns non-nil error if API errors out.")
//            expectation.fulfill()
//        })
//        self.wait(for: expectation)
//    }
//
//    func testRecommendations_AttachesPageParameter() {
//        let query = CIORecommendationsQuery(query: "potato", page: 5)
//
//        let builder = CIOBuilder(expectation: "Calling Recommendations should send a valid request.", builder: http(200))
//        stub(regex("https://ac.cnstrc.com/recommendations/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=5&s=\(kRegexSession)&section=Products"), builder.create())
//        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
//        self.wait(for: builder.expectation)
//    }
//
//    func testRecommendations_AttachesCustomSectionParameter() {
//        let customSection = "customSection"
//        let query = CIORecommendationsQuery(query: "potato", section: customSection)
//
//        let builder = CIOBuilder(expectation: "Calling Recommendations should send a valid request.", builder: http(200))
//        stub(regex("https://ac.cnstrc.com/recommendations/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=\(customSection)"), builder.create())
//
//        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
//        self.wait(for: builder.expectation)
//    }
//
//    func testRedirect_hasCorrectURL() {
//        let exp = self.expectation(description: "Redirect response should have a correct URL.")
//
//        stub(regex("https://ac.cnstrc.com/recommendations/dior?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(200, data: TestResource.load(name: TestResource.Response.recommendationsJSONRedirectFile)))
//
//        self.constructor.recommendations(forQuery: CIORecommendationsQuery(query: "dior")) { response in
//            guard let redirectInfo = response.data?.redirectInfo else {
//                XCTFail("Invalid response")
//                return
//            }
//            XCTAssertEqual(redirectInfo.url, "/brand/dior")
//            exp.fulfill()
//        }
//
//        self.waitForExpectationWithDefaultHandler()
//    }
//
//    func testRedirect_hasCorrectMatchID() {
//        let exp = self.expectation(description: "Redirect response should have a correct Match ID.")
//        stub(regex("https://ac.cnstrc.com/recommendations/dior?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(200, data: TestResource.load(name: TestResource.Response.recommendationsJSONRedirectFile)))
//
//        self.constructor.recommendations(forQuery: CIORecommendationsQuery(query: "dior")) { response in
//            guard let redirectInfo = response.data?.redirectInfo else {
//                XCTFail("Invalid response")
//                return
//            }
//            XCTAssertEqual(redirectInfo.matchID, 16257)
//            exp.fulfill()
//        }
//        self.waitForExpectationWithDefaultHandler()
//    }
//
//    func testRedirect_hasCorrectRuleID() {
//        let exp = self.expectation(description: "Redirect response should have a correct Rule ID.")
//
//        stub(regex("https://ac.cnstrc.com/recommendations/dior?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), http(200, data: TestResource.load(name: TestResource.Response.recommendationsJSONRedirectFile)))
//
//        self.constructor.recommendations(forQuery: CIORecommendationsQuery(query: "dior")) { response in
//            guard let redirectInfo = response.data?.redirectInfo else {
//                XCTFail("Invalid response")
//                return
//            }
//            XCTAssertEqual(redirectInfo.ruleID, 8860)
//            exp.fulfill()
//        }
//
//        self.waitForExpectationWithDefaultHandler()
//    }
//
//    func testRecommendations_AttachesGroupFilter() {
//        let query = CIORecommendationsQuery(query: "potato", filters: CIOQueryFilters(groupFilter: "151", facetFilters: nil))
//
//        let builder = CIOBuilder(expectation: "Calling Recommendations with a group filter should have a group_id URL query item.", builder: http(200))
//        stub(regex("https://ac.cnstrc.com/recommendations/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bgroup_id%5D=151&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())
//
//        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
//        self.wait(for: builder.expectation)
//    }
//
//    func testRecommendations_AttachesFacetFilter() {
//        let facetFilters = [(key: "facet1", value: "Organic")]
//        let query = CIORecommendationsQuery(query: "potato", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
//
//        let builder = CIOBuilder(expectation: "Calling Recommendations with a facet filter should have a facet filter URL query item.", builder: http(200))
//        stub(regex("https://ac.cnstrc.com/recommendations/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bfacet1%5D=Organic&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())
//
//        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
//        self.wait(for: builder.expectation)
//    }
//
//    func testRecommendations_AttachesMultipleFacetFilters() {
//        let facetFilters = [(key: "facet1", value: "Organic"),
//                            (key: "facet2", value: "Natural"),
//                            (key: "facet10", value: "Whole-grain")]
//        let query = CIORecommendationsQuery(query: "potato", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
//
//        let builder = CIOBuilder(expectation: "Calling Recommendations with multiple facet filters should have a multiple facet URL query items.", builder: http(200))
//        stub(regex("https://ac.cnstrc.com/recommendations/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5Bfacet10%5D=Whole-grain&filters%5Bfacet1%5D=Organic&filters%5Bfacet2%5D=Natural&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())
//
//        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
//        self.wait(for: builder.expectation)
//    }
//
//    func testRecommendations_AttachesMultipleFacetFiltersWithSameNameButDifferentValues() {
//        let facetFilters = [(key: "facetOne", value: "Organic"),
//                            (key: "facetOne", value: "Natural"),
//                            (key: "facetOne", value: "Whole-grain")]
//        let query = CIORecommendationsQuery(query: "potato", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
//
//        let builder = CIOBuilder(expectation: "Calling Recommendations with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
//        stub(regex("https://ac.cnstrc.com/recommendations/potato?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&filters%5BfacetOne%5D=Natural&filters%5BfacetOne%5D=Organic&filters%5BfacetOne%5D=Whole-grain&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())
//
//        self.constructor.recommendations(forQuery: query, completionHandler: { response in })
//
//        self.wait(for: builder.expectation)
//    }

}
