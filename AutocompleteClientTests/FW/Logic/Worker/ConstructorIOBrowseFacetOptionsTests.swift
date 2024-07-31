//
//  ConstructorIOBrowseFacetOptionsTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class ConstructorIOBrowseFacetOptionsTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBrowseFacetOptions_CreatesValidRequest() {
        let query = CIOBrowseFacetOptionsQuery(facetName: "price")

        let builder = CIOBuilder(expectation: "Calling Browse Facet Options should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facet_options?c=\(kRegexVersion)&facet_name=price&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseFacetOptions(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowseFacetOptions_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Browse Facet Options with valid parameters should return a non-nil response.")

        let query = CIOBrowseFacetOptionsQuery(facetName: "price")

        let dataToReturn = TestResource.load(name: TestResource.Response.browseFacetOptionsJSONFilename)
        stub(regex("https://ac.cnstrc.com/browse/facet_options?c=\(kRegexVersion)&facet_name=price&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(200, data: dataToReturn))

        self.constructor.browseFacetOptions(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Browse Facet Options with valid parameters should return a non-nil response.")

            XCTAssertNotNil(response.data?.facets)
            XCTAssertTrue(response.data?.facets.count == 1)
            XCTAssertTrue(response.data?.facets[0].options.count == 3)
            XCTAssertTrue(response.data?.facets[0].name == "brand")
            XCTAssertTrue(response.data?.facets[0].displayName == "Brand")
            XCTAssertTrue(response.data?.facets[0].type == "multiple")
            XCTAssertNotNil(response.data?.facets[0].options)
            XCTAssertTrue(((response.data?.facets[0].options[0].status.isEmpty) != nil))
            XCTAssertTrue(response.data?.facets[0].options[0].count == 2460)
            XCTAssertTrue(response.data?.facets[0].options[0].displayName == "Brand1")
            XCTAssertTrue(response.data?.facets[0].options[0].value == "brand1")
            XCTAssertTrue(((response.data?.facets[0].options[0].data.isEmpty) != nil))
            XCTAssertNotNil(response.data?.resultID)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacetOptions_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Browse Facet Options returns non-nil error if API errors out.")

        let query = CIOBrowseFacetOptionsQuery(facetName: "price")
    stub(regex("https://ac.cnstrc.com/browse/facet_options?c=\(kRegexVersion)&facet_name=price&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(404))

        self.constructor.browseFacetOptions(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Calling Browse returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacetOptions_AttachesShowHiddenFacetsParameter() {
        let query = CIOBrowseFacetOptionsQuery(facetName: "price", showHiddenFacets: true)

        let builder = CIOBuilder(expectation: "Calling Browse Facet Options should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facet_options?c=\(kRegexVersion)&facet_name=price&fmt_options%5Bshow_hidden_facets%5D=true&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.browseFacetOptions(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowseFacetOptions_UsingQueryBuilder_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Browse Facet Options with valid parameters should return a non-nil response.")

        let query = CIOBrowseFacetOptionsQueryBuilder(facetName: "price").build()

        let dataToReturn = TestResource.load(name: TestResource.Response.browseFacetOptionsJSONFilename)
        stub(regex("https://ac.cnstrc.com/browse/facet_options?c=\(kRegexVersion)&facet_name=price&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(200, data: dataToReturn))

        self.constructor.browseFacetOptions(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Browse Facet Options with valid parameters should return a non-nil response.")

            XCTAssertNotNil(response.data?.facets)
            XCTAssertTrue(response.data?.facets.count == 1)
            XCTAssertTrue(response.data?.facets[0].options.count == 3)
            XCTAssertTrue(response.data?.facets[0].name == "brand")
            XCTAssertTrue(response.data?.facets[0].displayName == "Brand")
            XCTAssertTrue(response.data?.facets[0].type == "multiple")
            XCTAssertNotNil(response.data?.facets[0].options)
            XCTAssertTrue(((response.data?.facets[0].options[0].status.isEmpty) != nil))
            XCTAssertTrue(response.data?.facets[0].options[0].count == 2460)
            XCTAssertTrue(response.data?.facets[0].options[0].displayName == "Brand1")
            XCTAssertTrue(response.data?.facets[0].options[0].value == "brand1")
            XCTAssertTrue(((response.data?.facets[0].options[0].data.isEmpty) != nil))
            XCTAssertNotNil(response.data?.resultID)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacetOptions_UsingQueryBuilder_AttachesShowHiddenFacetsParameter() {
        let query = CIOBrowseFacetOptionsQueryBuilder(facetName: "price").setShowHiddenFacets(true).build()

        let builder = CIOBuilder(expectation: "Calling Browse Facet Options should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facet_options?c=\(kRegexVersion)&facet_name=price&fmt_options%5Bshow_hidden_facets%5D=true&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.browseFacetOptions(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
}
