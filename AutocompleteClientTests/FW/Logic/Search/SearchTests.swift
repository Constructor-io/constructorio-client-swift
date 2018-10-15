//
//  SearchTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class SearchTests: XCTestCase {
    
    var constructor: ConstructorIO!
    
    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCallingSearch_CreatesValidRequest(){
        let query = CIOSearchQuery(query: "potato")
        
        let builder = CIOBuilder(expectation: "Calling Search should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?page=1&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&num_results_per_page=20&_dt=\(kRegexTimestamp)"), builder.create())
        
        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
    
    func testCallingSearch_WithValidRequest_ReturnsNonNilResponse(){
        let expectation = self.expectation(description: "Calling Search with valid parameters should return a non-nil response.")
        
        let query = CIOSearchQuery(query: "potato")
        
        let dataToReturn = TestResource.load(name: TestResource.Response.searchJSONFilename)
        stub(regex("https://ac.cnstrc.com/search/potato?page=1&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&num_results_per_page=20&_dt=\(kRegexTimestamp)"), http(200, data: dataToReturn))
        
        self.constructor.search(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Search with valid parameters should return a non-nil response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testCallingSearch_ReturnsErrorObject_IfAPIReturnsInvalidResponse(){
        let expectation = self.expectation(description: "Calling Search returns non-nil error if API errors out.")
        
        let query = CIOSearchQuery(query: "potato")
        
        stub(regex("https://ac.cnstrc.com/search/potato?page=1&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&num_results_per_page=20&_dt=\(kRegexTimestamp)"), http(404))
        
        self.constructor.search(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Calling Search returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testCallingSearch_AttachesPageParameter(){
        let query = CIOSearchQuery(query: "potato", page: 5)
        
        let builder = CIOBuilder(expectation: "Calling Search should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?num_results_per_page=20&s=1&key=key_OucJxxrfiTVUQx0C&i=\(kRegexClientID)&c=cioios-&page=5&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
    
    func testCallingSearch_AttachesNumResultsParameter(){
        let query = CIOSearchQuery(query: "potato", numResultsPerPage: 11)
        
        let builder = CIOBuilder(expectation: "Calling Search should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?page=1&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&num_results_per_page=11&_dt=\(kRegexTimestamp)"), builder.create())
        
        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
    
    func testCallingSearch_AttachesGroupFilter(){
        let query = CIOSearchQuery(query: "potato", filters: SearchFilters(groupFilter: "151", facetFilters: nil))
        
        let builder = CIOBuilder(expectation: "Calling Search with a group filter should have a group_id URL query item.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?page=1&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&filters%5Bgroup_id%5D=151&num_results_per_page=20&_dt=\(kRegexTimestamp)"), builder.create())
        
        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
    
    func testCallingSearch_AttachesFacetFilter(){
        let facetFilters = [(key: "facet1", value: "Organic")]
        let query = CIOSearchQuery(query: "potato", filters: SearchFilters(groupFilter: nil, facetFilters: facetFilters))
        
        let builder = CIOBuilder(expectation: "Calling Search with a facet filter should have a facet filter URL query item.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?page=1&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&filters%5Bfacet1%5D=Organic&num_results_per_page=20&_dt=\(kRegexTimestamp)"), builder.create())
        
        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
    
    func testCallingSearch_AttachesMultipleFacetFilters(){
        let facetFilters = [(key: "facet1", value: "Organic"),
                            (key: "facet2", value: "Natural"),
                            (key: "facet10", value: "Whole-grain")]
        let query = CIOSearchQuery(query: "potato", filters: SearchFilters(groupFilter: nil, facetFilters: facetFilters))
        
        let builder = CIOBuilder(expectation: "Calling Search with multiple facet filters should have a multiple facet URL query items.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?page=1&i=\(kRegexClientID)&filters%5Bfacet2%5D=Natural&key=key_OucJxxrfiTVUQx0C&c=cioios-&filters%5Bfacet10%5D=Whole-grain&s=1&filters%5Bfacet1%5D=Organic&num_results_per_page=20&_dt=\(kRegexTimestamp)"), builder.create())
        
        self.constructor.search(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
    
    func testCallingSearch_AttachesMultipleFacetFiltersWithSameNameButDifferentValues(){
        let facetFilters = [(key: "facetOne", value: "Organic"),
                            (key: "facetOne", value: "Natural"),
                            (key: "facetOne", value: "Whole-grain")]
        let query = CIOSearchQuery(query: "potato", filters: SearchFilters(groupFilter: nil, facetFilters: facetFilters))
        
        let builder = CIOBuilder(expectation: "Calling Search with multiple facet filters with the same name should have a multiple facet URL query items", builder: http(200))
        stub(regex("https://ac.cnstrc.com/search/potato?page=1&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&filters%5BfacetOne%5D=Organic&filters%5BfacetOne%5D=Natural&filters%5BfacetOne%5D=Whole-grain&num_results_per_page=20&_dt=\(kRegexTimestamp)"), builder.create())
        
        self.constructor.search(forQuery: query, completionHandler: { response in })
        
        self.wait(for: builder.expectation)
    }
    
    
}
