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

    func testQuizQuestion_CreatesValidRequest() {
        let query = CIOQuizQuery(quizId: "test-quiz", answers: ["1", "2"])
        
        let builder = CIOBuilder(expectation: "Calling Quiz Question should send a valid request.", builder: http(200))
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/next?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), builder.create())

        self.constructor.getQuizNextQuestion(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }
    
    func testQuizResults_CreatesValidRequest() {
        let query = CIOQuizQuery(quizId: "test-quiz", answers: ["1", "2"], finalize: true)
        
        let builder = CIOBuilder(expectation: "Calling Quiz Results should send a valid request.", builder: http(200))
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/finalize?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), builder.create())

        self.constructor.getQuizResults(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testQuizQuistion_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Quiz Question with valid parameters should return a non-nil response.")

        let query = CIOQuizQuery(quizId: "test-quiz", answers: ["1"])

        let dataToReturn = TestResource.load(name: TestResource.Response.quizNextQuestionJSONFilename)
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/next?_dt=\(kRegexTimestamp)&a=1&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Quiz Question with valid parameters should return a non-nil response.")
            XCTAssertNotNil(response.data?.nextQuestion.options, "Calling Quiz Question with valid parameters should return a non-nil options response.")
            XCTAssertEqual(response.data?.nextQuestion.images?.primaryUrl, "https://example.com/image")
            XCTAssertNil(response.data?.nextQuestion.images?.secondaryUrl, "Calling Quiz Question with valid parameters should return a nil for secondary image url.")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testQuizResults_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Quiz Results with valid parameters should return a non-nil response.")

        let query = CIOQuizQuery(quizId: "test-quiz", answers: ["1", "2, 3"], finalize: true)

        let dataToReturn = TestResource.load(name: TestResource.Response.quizResultsJSONFilename)
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/finalize?_dt=\(kRegexTimestamp)&a=1&a=2,3&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.getQuizResults(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data?.result, "Calling Quiz Results next with valid parameters should return a non-nil response.")
            XCTAssertNotNil(response.data?.result.filterExpressions, "Calling Quiz Results next with valid parameters should return a non-nil filter expressions response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testQuizQuestion_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Quiz Question returns non-nil error if API errors out.")

        let query = CIOQuizQuery(quizId: "test-quiz", answers: ["1", "2"])
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/next?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(404))

        self.constructor.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Quiz Question returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testQuizResults_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Quiz Results returns non-nil error if API errors out.")

        let query = CIOQuizQuery(quizId: "test-quiz", answers: ["1", "2"], finalize: true)
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/finalize?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(404))

        self.constructor.getQuizResults(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Quiz Results returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
}
