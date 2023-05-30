//
//  ConstructorIOBrowseFacetsTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class ConstructorIOBrowseFacetsTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBrowseFacets_CreatesValidRequest() {
        let query = CIOBrowseFacetsQuery()

        let builder = CIOBuilder(expectation: "Calling Browse Facets should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)"), builder.create())

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowseFacets_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Browse Facets with valid parameters should return a non-nil response.")

        let query = CIOBrowseFacetsQuery()

        let dataToReturn = TestResource.load(name: TestResource.Response.browseFacetsJSONFilename)
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Browse Facets with valid parameters should return a non-nil response.")

            XCTAssertTrue(response.data?.totalNumResults == 9)
            XCTAssertTrue(response.data?.facets.count == 5)
            XCTAssertTrue(response.data?.facets[0].name == "brand")
            XCTAssertTrue(response.data?.facets[0].displayName == "Brand")
            XCTAssertTrue(response.data?.facets[0].type == "multiple")
            XCTAssertNotNil(response.data?.resultID)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacets_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Browse Facets returns non-nil error if API errors out.")

        let query = CIOBrowseFacetsQuery()
    stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)"), http(404))

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Calling Browse returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacets_AttachesPageParameter() {
        let query = CIOBrowseFacetsQuery(page: 100)

        let builder = CIOBuilder(expectation: "Calling Browse Facets should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&page=100&s=\(kRegexSession)"), builder.create())
        self.constructor.browseFacets(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowseFacets_AttachesOffsetParameter() {
        let query = CIOBrowseFacetsQuery(offset: 100)

        let builder = CIOBuilder(expectation: "Calling Browse Facets should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&offset=100&s=\(kRegexSession)"), builder.create())

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowseFacets_AttachesPerPageParameter() {
        let query = CIOBrowseFacetsQuery(perPage: 100)

        let builder = CIOBuilder(expectation: "Calling Browse Facets should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&num_results_per_page=100&s=\(kRegexSession)"), builder.create())

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowseFacets_AttachesShowHiddenFacetsParameter() {
        let query = CIOBrowseFacetsQuery(showHiddenFacets: true)

        let builder = CIOBuilder(expectation: "Calling Browse Facets should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&fmt_options%5Bshow_hidden_facets%5D=true&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)"), builder.create())

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }


    func testBrowseFacets_UsingQueryBuilder_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Browse Facets with valid parameters should return a non-nil response.")

        let query = CIOBrowseFacetsQueryBuilder().build()

        let dataToReturn = TestResource.load(name: TestResource.Response.browseFacetsJSONFilename)
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Browse Facets with valid parameters should return a non-nil response.")

            XCTAssertTrue(response.data?.totalNumResults == 9)
            XCTAssertTrue(response.data?.facets.count == 5)
            XCTAssertTrue(response.data?.facets[0].name == "brand")
            XCTAssertTrue(response.data?.facets[0].displayName == "Brand")
            XCTAssertTrue(response.data?.facets[0].type == "multiple")
            XCTAssertNotNil(response.data?.resultID)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacets_UsingQueryBuilder_AttachesPageParameter() {
        let query = CIOBrowseFacetsQueryBuilder().setPage(100).build()

        let builder = CIOBuilder(expectation: "Calling Browse Facets should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&page=100&s=\(kRegexSession)"), builder.create())
        self.constructor.browseFacets(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowseFacets_UsingQueryBuilder_AttachesOffsetParameter() {
        let query = CIOBrowseFacetsQueryBuilder().setOffset(100).build()

        let builder = CIOBuilder(expectation: "Calling Browse Facets should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&offset=100&s=\(kRegexSession)"), builder.create())

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowseFacets_UsingQueryBuilder_AttachesPerPageParameter() {
        let query = CIOBrowseFacetsQueryBuilder().setPerPage(100).build()

        let builder = CIOBuilder(expectation: "Calling Browse Facets should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&num_results_per_page=100&s=\(kRegexSession)"), builder.create())

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testBrowseFacets_UsingQueryBuilder_AttachesShowHiddenFacetsParameter() {
        let query = CIOBrowseFacetsQueryBuilder().setShowHiddenFacets(true).build()

        let builder = CIOBuilder(expectation: "Calling Browse Facets should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/browse/facets?c=\(kRegexVersion)&fmt_options%5Bshow_hidden_facets%5D=true&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)"), builder.create())

        self.constructor.browseFacets(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
}
