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
        let query = CIORecommendationsQuery(podId: "movie_pod_best_sellers")

        let builder = CIOBuilder(expectation: "Calling Recommendations should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v1/recommendations/pods/movie_pod_best_sellers?_dt=\(kRegexTimestamp)&c=cioios-&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&num_results_per_page=30&page=1&s=\(kRegexSession)&section=Products"), builder.create())

        self.constructor.recommendations(forQuery: query, completionHandler: {
            response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            builder.expectation.fulfill()
        })
        self.wait(for: builder.expectation)
    }
}
