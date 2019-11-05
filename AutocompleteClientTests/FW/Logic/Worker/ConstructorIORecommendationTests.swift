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

    func testRecommendations_createsValidRequest() {
        let builder = CIOBuilder(expectation: "Calling getRecommendations should send a valid request", builder: http(200))
        let numResults = 10
        stub(regex("\(self.baseURL)/recommendations/v1/pods/testPod?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=itemID&key=\(kRegexAutocompleteKey)&num_results=\(numResults)&s=\(kRegexSession)"), builder.create())
        let query = CIORecommendationsQuery(pod: "testPod", itemID: "itemID", maximumNumberOfResult: numResults)
        self.constructor.getRecommendations(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }
    
    func testRecommendations_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling getRecommendations with valid parameters should return a non-nil response.")

        let data = TestResource.load(name: TestResource.Response.recommendationsJSONFilename)
    stub(regex("\(self.baseURL)/recommendations/v1/pods/testPod?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=itemID&key=\(kRegexAutocompleteKey)&num_results=10&s=\(kRegexSession)"), http(200, data: data))
        stub(regex("\(self.baseURL)/recommendations/v1/pods/"), http(200, data: data))
        self.constructor.getRecommendations(forQuery: CIORecommendationsQuery(pod: "testPod", itemID: "itemID", maximumNumberOfResult: 10)) { (response) in
            if response.data != nil {
                expectation.fulfill()
            } else {
                XCTFail("Calling getRecommendations with valid parameters should return a non-nil response.")
            }
        }
        self.wait(for: expectation)
    }
    
    func testRecommendations_WithValidRequest_ReturnsValidPod() {
        let expectation = self.expectation(description: "Calling getRecommendations with valid parameters should return a valid pod.")

        let data = TestResource.load(name: TestResource.Response.recommendationsJSONFilename)
    stub(regex("\(self.baseURL)/recommendations/v1/pods/testPod?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&item_id=itemID&key=\(kRegexAutocompleteKey)&num_results=10&s=\(kRegexSession)"), http(200, data: data))
        stub(regex("\(self.baseURL)/recommendations/v1/pods/"), http(200, data: data))
        self.constructor.getRecommendations(forQuery: CIORecommendationsQuery(pod: "testPod", itemID: "itemID", maximumNumberOfResult: 10)) { (response) in
            if let data = response.data {
                XCTAssertEqual(data.pod.displayName, "testPod", "Pod with invalid displayName returned.")
                XCTAssertEqual(data.pod.id, "test_pod_id", "Pod with invalid id returned.")
                expectation.fulfill()
            } else {
                XCTFail("Calling getRecommendations with valid parameters should return a non-nil response.")
            }
        }
        self.wait(for: expectation)
    }
}
