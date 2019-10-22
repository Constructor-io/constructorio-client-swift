//
//  ConstructorIORecommendationTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class ConstructorIORecommendationTests: XCTestCase {

    var constructor: ConstructorIO!
    let baseURL = "https://ac.cnstrc.com"
    
    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }
    
    // MARK: user featured

    func testRecommendations_featuredItems_createsValidRequest() {
        let builder = CIOBuilder(expectation: "Calling getFeaturedItems should send a valid request", builder: http(200))
        stub(regex("\(self.baseURL)/recommendations/user_featured_items?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), builder.create())
        self.constructor.getUserFeaturedItems { _ in }
        self.wait(for: builder.expectation)
    }
    
    func testRecommendations_featuredItems_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling getFeaturedItems with valid parameters should return a non-nil response.")

        let data = TestResource.load(name: TestResource.Response.recommendationsUserFeaturedItemsJSONFilename)
        stub(regex("\(self.baseURL)/recommendations/user_featured_items?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), http(200, data: data))
        self.constructor.getUserFeaturedItems { response in
            XCTAssertNotNil(response.data, "Calling getFeaturedItems with valid parameter should return a non-nil response.")
            expectation.fulfill()
        }
        self.wait(for: expectation)
    }
 
    func testRecommendations_featuredItems_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling getFeaturedItems returns non-nil error if API errors out.")
        stub(regex("\(self.baseURL)/recommendations/user_featured_items?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), http(404))
        self.constructor.getUserFeaturedItems { response in
            XCTAssertNotNil(response.error, "Calling getFeaturedItems returns non-nil error if API errors out.")
            expectation.fulfill()
        }
        self.wait(for: expectation)
    }
    
    // MARK: recently viewed
    
    func testRecommendations_recentlyViewed_createsValidRequest() {
           let builder = CIOBuilder(expectation: "Calling getRecentlyViewedItems should send a valid request", builder: http(200))
           stub(regex("\(self.baseURL)/recommendations/recently_viewed_items?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), builder.create())
           self.constructor.getRecentlyViewedItems { _ in }
           self.wait(for: builder.expectation)
    }
       
   func testRecommendations_recentlyViewed_WithValidRequest_ReturnsNonNilResponse() {
       let expectation = self.expectation(description: "Calling getRecentlyViewedItems with valid parameters should return a non-nil response.")

       let data = TestResource.load(name: TestResource.Response.recommendationsRecentlyViewedItemsJSONFilename)
       stub(regex("\(self.baseURL)/recommendations/recently_viewed_items?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), http(200, data: data))
       self.constructor.getRecentlyViewedItems { response in
           XCTAssertNotNil(response.data, "Calling getRecentlyViewedItems with valid parameter should return a non-nil response.")
           expectation.fulfill()
       }
       self.wait(for: expectation)
   }
    
   func testRecommendations_recentlyViewed_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
       let expectation = self.expectation(description: "Calling getRecentlyViewedItems returns non-nil error if API errors out.")
       stub(regex("\(self.baseURL)/recommendations/recently_viewed_items?c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), http(404))
       self.constructor.getRecentlyViewedItems { response in
           XCTAssertNotNil(response.error, "Calling getRecentlyViewedItems returns non-nil error if API errors out.")
           expectation.fulfill()
       }
       self.wait(for: expectation)
   }

    // MARK: alternative items
    
    func testRecommendations_alternativeItems_createsValidRequest() {
        let builder = CIOBuilder(expectation: "Calling getAlternativeItems should send a valid request", builder: http(200))
    stub(regex("\(self.baseURL)/recommendations/alternative_items?c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=\(kRegexPositiveInteger)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), builder.create())
        self.constructor.getAlternativeItems(itemID: "123") { _ in }
        self.wait(for: builder.expectation)
     }
        
    func testRecommendations_alternativeItems_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling getAlternativeItems with valid parameters should return a non-nil response.")

        let data = TestResource.load(name: TestResource.Response.recommendationsAlternativeItemsJSONFilename)
       
    stub(regex("\(self.baseURL)/recommendations/alternative_items?c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=\(kRegexPositiveInteger)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), http(200, data: data))
        
        self.constructor.getAlternativeItems(itemID: "123") { response in
            XCTAssertNotNil(response.data, "Calling getAlternativeItems with valid parameter should return a non-nil response.")
            expectation.fulfill()
        }
        self.wait(for: expectation)
    }
     
    func testRecommendations_alternativeItems_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling getAlternativeItems returns non-nil error if API errors out.")
    stub(regex("\(self.baseURL)/recommendations/alternative_items?c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=\(kRegexPositiveInteger)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), http(404))
       
        self.constructor.getAlternativeItems(itemID: "123") { response in
            XCTAssertNotNil(response.error, "Calling getAlternativeItems returns non-nil error if API errors out.")
            expectation.fulfill()
        }
        self.wait(for: expectation)
    }

    // MARK: complementary items
    func testRecommendations_complementaryItems_createsValidRequest() {
        let builder = CIOBuilder(expectation: "Calling getComplementaryItems should send a valid request", builder: http(200))
   stub(regex("\(self.baseURL)/recommendations/complementary_items?c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=\(kRegexPositiveInteger)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), builder.create())
       self.constructor.getComplementaryItems(itemID: "123") { _ in }
       self.wait(for: builder.expectation)
    }
           
    func testRecommendations_complementaryItems_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling getComplementaryItems with valid parameters should return a non-nil response.")

        let data = TestResource.load(name: TestResource.Response.recommendationsComplementaryItemsJSONFilename)
    stub(regex("\(self.baseURL)/recommendations/complementary_items?c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=\(kRegexPositiveInteger)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), http(200, data: data))
       
       self.constructor.getComplementaryItems(itemID: "123") { response in
           XCTAssertNotNil(response.data, "Calling getComplementaryItems with valid parameter should return a non-nil response.")
           expectation.fulfill()
        }
        self.wait(for: expectation)
    }
    
    func testRecommendations_complementaryItems_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling getComplementaryItems returns non-nil error if API errors out.")
    stub(regex("\(self.baseURL)/recommendations/complementary_items?c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=\(kRegexPositiveInteger)&key=\(kRegexAutocompleteKey)&num_results=\(kRegexPositiveInteger)&s=\(kRegexSession)"), http(404))
      
        self.constructor.getComplementaryItems(itemID: "123") { response in
            XCTAssertNotNil(response.error, "Calling getComplementaryItems returns non-nil error if API errors out.")
            expectation.fulfill()
        }
        self.wait(for: expectation)
    }
}
