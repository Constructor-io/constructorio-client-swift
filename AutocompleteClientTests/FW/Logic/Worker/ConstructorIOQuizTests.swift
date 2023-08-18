//
//  ConstructorIOQuizzesTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class ConstructorIOQuizTests: XCTestCase {

    var constructor: ConstructorIO!
    var quizSessionId = "session-id"
    var quizVersionId = "dd10eea4-f765-4bb1-b8e5-46b09a190cfe"

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: "ZqXaOfXuBWD4s3XzCI1q", baseURL: "https://quizzes.cnstrc.com"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testQuizNextQuestion_CreatesValidRequest() {
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["2"]], quizVersionId: self.quizVersionId, quizSessionId: self.quizSessionId)

        let builder = CIOBuilder(expectation: "Calling Quiz Question should send a valid request.", builder: http(200))
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/next?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&quiz_session_id=\(self.quizSessionId)&quiz_version_id=\(self.quizVersionId)&s=\(kRegexSession)"), builder.create())

        self.constructor.getQuizNextQuestion(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testQuizResults_CreatesValidRequest() {
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["2"]], quizVersionId: self.quizVersionId, quizSessionId: self.quizSessionId)

        let builder = CIOBuilder(expectation: "Calling Quiz Results should send a valid request.", builder: http(200))
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/results?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&quiz_session_id=\(self.quizSessionId)&quiz_version_id=\(self.quizVersionId)&s=\(kRegexSession)"), builder.create())

        self.constructor.getQuizResults(forQuery: query, completionHandler: { response in })
        self.wait(for: builder.expectation)
    }

    func testQuizNextQuestion_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Quiz Question with valid parameters should return a non-nil response.")

        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"]])

        let dataToReturn = TestResource.load(name: TestResource.Response.quizQuestionJSONFilename)
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

        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["2, 3"]])

        let dataToReturn = TestResource.load(name: TestResource.Response.quizResultsJSONFilename)
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/results?_dt=\(kRegexTimestamp)&a=1&a=2,3&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.getQuizResults(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data?.results, "Calling Quiz Results next with valid parameters should return a non-nil response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testQuizResults_WithValidRequest_ReturnsNonNilResponseWithRequestObject() {
        let expectation = self.expectation(description: "Calling Quiz Results with valid parameters should return a non-nil response with the request object.")

        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["2, 3"]])

        let dataToReturn = TestResource.load(name: TestResource.Response.quizResultsJSONFilename)
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/results?_dt=\(kRegexTimestamp)&a=1&a=2,3&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.getQuizResults(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data?.results, "Calling Quiz Results next with valid parameters should return a non-nil response with request object")
            XCTAssertEqual(response.data?.request["page"] as? Int, 1, "Valid page should be correctly parsed")
            XCTAssertEqual(response.data?.request["num_results_per_page"] as? Int, 20, "Valid num_results_per_page should be correctly parsed")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testQuizNextQuestion_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Quiz Question returns non-nil error if API errors out.")

        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["2"]])
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/next?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(404))

        self.constructor.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Quiz Question returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testQuizResults_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Quiz Results returns non-nil error if API errors out.")

        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["2"]])
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/test-quiz/results?_dt=\(kRegexTimestamp)&a=1&a=2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=ZqXaOfXuBWD4s3XzCI1q&s=\(kRegexSession)"), http(404))

        self.constructor.getQuizResults(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Quiz Results returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
}
