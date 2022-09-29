//
//  ConstructorIOQuizzesTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class ConstructorIOQuizzesTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: "ZqXaOfXuBWD4s3XzCI1q", baseURL: "https://quizzes.cnstrc.com"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testQuizzes_CreatesValidRequest() {
        let query = CIOQuizzesQuery(quizId: "test-quiz", answers: ["1", "2"])
        
        let builder = CIOBuilder(expectation: "Calling Quizzes should send a valid request.", builder: http(200))
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/next?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), builder.create())

        self.constructor.quizzes(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testQuizzesNext_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Quizzes next with valid parameters should return a non-nil response.")

        let query = CIOQuizzesQuery(quizId: "test-quiz", answers: ["1"])

        let dataToReturn = TestResource.load(name: TestResource.Response.quizzesJSONFilenameNext)
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/next?_dt=\(kRegexTimestamp)&a=1&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.quizzes(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Quizzes next with valid parameters should return a non-nil response.")
            XCTAssertNotNil(response.data?.nextQuestion?.options, "Calling Quizzes next with valid parameters should return a non-nil options response.")
            XCTAssertEqual(response.data?.nextQuestion?.images?.primaryUrl, "https://example.com/image")
            XCTAssertNil(response.data?.nextQuestion?.images?.secondaryUrl, "Calling Quizzes next with valid parameters should return a nil for secondary image url.")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testQuizzesFinalize_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Quizzes finalize with valid parameters should return a non-nil response.")

        var query = CIOQuizzesQuery(quizId: "test-quiz", answers: ["1", "2, 3"])
        query.finalize = true

        let dataToReturn = TestResource.load(name: TestResource.Response.quizzesJSONFilenameFinalize)
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/finalize?_dt=\(kRegexTimestamp)&a=1&a=2,3&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.quizzes(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data?.result, "Calling Quizzes finalize next with valid parameters should return a non-nil response.")
            XCTAssertNotNil(response.data?.result?.filterExpressions, "Calling Quizzes finalize next with valid parameters should return a non-nil filter expressions response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testQuizzes_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Quizzes returns non-nil error if API errors out.")

        let query = CIOQuizzesQuery(quizId: "test-quiz", answers: ["1", "2"])
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/next?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(404))

        self.constructor.quizzes(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Quizzes returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
}
