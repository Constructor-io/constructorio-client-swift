//
//  ConstructorIOQuizIntegrationTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

// swiftlint:disable type_body_length
class ConstructorIOQuizIntegrationTests: XCTestCase {

    fileprivate let unitTestKey = "ZqXaOfXuBWD4s3XzCI1q"
    fileprivate let session = 90
    fileprivate let sectionName = "Products"

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetQuizNextQuestion() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz")
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotNil(responseData.versionId)
            XCTAssertEqual(responseData.isLastQuestion, false)
            XCTAssertEqual(responseData.nextQuestion.id, 1)
            XCTAssertEqual(responseData.nextQuestion.title, "This is a test quiz.")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")
            XCTAssertEqual(responseData.nextQuestion.type, "single")
            XCTAssertEqual(responseData.nextQuestion.ctaText, nil)
            XCTAssertEqual(responseData.nextQuestion.description, "This is a test description")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")
            XCTAssertNotNil(responseData.nextQuestion.options)
            XCTAssertEqual(responseData.nextQuestion.options?[0].id, 1)
            XCTAssertEqual(responseData.nextQuestion.options?[0].value, "Yes")
            XCTAssertEqual(responseData.nextQuestion.options?[0].attribute?.name, "group_id")
            XCTAssertEqual(responseData.nextQuestion.options?[0].attribute?.value, "BrandX")
            XCTAssertEqual(responseData.nextQuestion.options?[0].images?.primaryUrl, "/test-asset")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testGetQuizNextQuestion_WithVersionId() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", versionId: "160ff14a-bf30-4fd0-b8f1-ad0a58d0b2f0")
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotNil(responseData.versionId)
            XCTAssertEqual(responseData.isLastQuestion, false)
            XCTAssertEqual(responseData.nextQuestion.id, 1)
            XCTAssertEqual(responseData.nextQuestion.title, "This is a test quiz.")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")
            XCTAssertEqual(responseData.nextQuestion.type, "single")
            XCTAssertEqual(responseData.nextQuestion.ctaText, nil)
            XCTAssertEqual(responseData.nextQuestion.description, "This is a test description")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")
            XCTAssertNotNil(responseData.nextQuestion.options)
            XCTAssertEqual(responseData.nextQuestion.options?[0].id, 1)
            XCTAssertEqual(responseData.nextQuestion.options?[0].value, "Yes")
            XCTAssertEqual(responseData.nextQuestion.options?[0].attribute?.name, "group_id")
            XCTAssertEqual(responseData.nextQuestion.options?[0].attribute?.value, "BrandX")
            XCTAssertEqual(responseData.nextQuestion.options?[0].images?.primaryUrl, "/test-asset")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizNextQuestion_WithInvalidVersionId() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", versionId: "1")
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "The quiz you requested, \"test-quiz\" was not found with version \"1\", please specify a valid quiz id and remove the version_id parameter before trying again.")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizNextQuestion_WithSingleTypeUsingSingleAnswer() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"]])
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotNil(responseData.versionId)
            XCTAssertEqual(responseData.isLastQuestion, false)
            XCTAssertEqual(responseData.nextQuestion.id, 2)
            XCTAssertEqual(responseData.nextQuestion.title, "This is a multiple select question")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")
            XCTAssertEqual(responseData.nextQuestion.type, "multiple")
            XCTAssertEqual(responseData.nextQuestion.ctaText, nil)
            XCTAssertEqual(responseData.nextQuestion.description, "This is a multiple select description")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")
            XCTAssertNotNil(responseData.nextQuestion.options)
            XCTAssertEqual(responseData.nextQuestion.options?[0].id, 1)
            XCTAssertEqual(responseData.nextQuestion.options?[0].value, "Yes")
            XCTAssertEqual(responseData.nextQuestion.options?[0].attribute?.name, "Color")
            XCTAssertEqual(responseData.nextQuestion.options?[0].attribute?.value, "Blue")
            XCTAssertEqual(responseData.nextQuestion.options?[0].images?.primaryUrl, "/test-asset")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizNextQuestion_WithSingleTypeUsingWrongAnswerType() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1", "2"]])
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "A single select question can only accept a single selection. Please provide a valid answer.")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizNextQuestion_WithMultipleTypeUsingMultipleAnswer() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["1", "2"]])
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotNil(responseData.versionId)
            XCTAssertEqual(responseData.isLastQuestion, false)
            XCTAssertEqual(responseData.nextQuestion.id, 3)
            XCTAssertEqual(responseData.nextQuestion.title, "Test Cover")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")
            XCTAssertEqual(responseData.nextQuestion.type, "cover")
            XCTAssertEqual(responseData.nextQuestion.ctaText, "Test Cover Cta")
            XCTAssertEqual(responseData.nextQuestion.description, "This is a test cover")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizNextQuestion_WithMultipleTypeUsingWrongAnswerType() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["true"]])
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "Answers supplied must be of type integer or left empty if the question is skipped.")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizNextQuestion_WithCoverTypeUsingCoverAnswer() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["1", "2"], ["seen"]])
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotNil(responseData.versionId)
            XCTAssertEqual(responseData.isLastQuestion, true)
            XCTAssertEqual(responseData.nextQuestion.id, 4)
            XCTAssertEqual(responseData.nextQuestion.title, "Test Open Text")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")
            XCTAssertEqual(responseData.nextQuestion.type, "open")
            XCTAssertEqual(responseData.nextQuestion.ctaText, nil)
            XCTAssertEqual(responseData.nextQuestion.description, "This is a open text test.")
            XCTAssertEqual(responseData.nextQuestion.images?.primaryUrl, "/test-asset")
            XCTAssertEqual(responseData.nextQuestion.inputPlaceholder, "Input Placeholder test")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizNextQuestion_WithCoverTypeUsingWrongAnswerType() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["1", "2"], ["true"]])
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "Cover page can have only \"seen\" as answer. It cannot be skipped")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizResults() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["1", "2"], ["true"], ["seen"]])
        constructorClient.getQuizResults(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotNil(responseData.versionId)
            XCTAssertNotNil(responseData.result)
            XCTAssertNotNil(responseData.result.filterExpressions)
            XCTAssertTrue(responseData.result.resultsUrl.contains("https://ac.cnstrc.com/browse/items?key=ZqXaOfXuBWD4s3XzCI1q&num_results_per_page=10&collection_filter_expression=%7B%22and%22%3A%5B%7B%22name%22%3A%22group_id%22%2C%22value%22%3A%22BrandX%22%7D%2C%7B%22or%22%3A%5B%7B%22name%22%3A%22Color%22%2C%22value%22%3A%22Blue%22%7D%2C%7B%22name%22%3A%22Color%22%2C%22value%22%3A%22red%22%7D%5D%7D%5D%7D"))

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizResults_WithVersionId() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", answers: [["1"], ["1", "2"], ["true"], ["seen"]], versionId: "160ff14a-bf30-4fd0-b8f1-ad0a58d0b2f0")
        constructorClient.getQuizResults(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotNil(responseData.versionId)
            XCTAssertNotNil(responseData.result)
            XCTAssertNotNil(responseData.result.filterExpressions)
            XCTAssertTrue(responseData.result.resultsUrl.contains("https://ac.cnstrc.com/browse/items?key=ZqXaOfXuBWD4s3XzCI1q&num_results_per_page=10&collection_filter_expression=%7B%22and%22%3A%5B%7B%22name%22%3A%22group_id%22%2C%22value%22%3A%22BrandX%22%7D%2C%7B%22or%22%3A%5B%7B%22name%22%3A%22Color%22%2C%22value%22%3A%22Blue%22%7D%2C%7B%22name%22%3A%22Color%22%2C%22value%22%3A%22red%22%7D%5D%7D%5D%7D"))

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizResults_WithInvalidVersionId() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizId: "test-quiz", versionId: "1")
        constructorClient.getQuizResults(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "The quiz you requested, \"test-quiz\" was not found with version \"1\", please specify a valid quiz id and remove the version_id parameter before trying again.")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
}
