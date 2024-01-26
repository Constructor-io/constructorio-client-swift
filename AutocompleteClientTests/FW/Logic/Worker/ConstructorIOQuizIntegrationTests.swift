//
//  ConstructorIOQuizIntegrationTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

// swiftlint:disable type_body_length
class ConstructorIOQuizIntegrationTests: XCTestCase {

    fileprivate let unitTestKey = "key_vM4GkLckwiuxwyRA"
    fileprivate let session = 90
    fileprivate let quizVersionID = "bc319700-5ed5-4562-ac45-2bc9d892f801"
    fileprivate let quizSessionID = "session-id"
    fileprivate let sectionName = "Products"

    // For tracking
    fileprivate let quizID = "test-quiz"
    fileprivate let customerID = "960109549"
    fileprivate let variationID = "no variations"
    fileprivate let itemName = "Lucerne Cottage Cheese Small Curd 2% Milkfat Lowfat - 24 Oz"
    fileprivate let url = "www.example.com"
    fileprivate let resultID = "abc"
    fileprivate let resultPage = 1
    fileprivate let resultCount = 12
    fileprivate let numResultsPerPage = 13
    fileprivate let resultPositionOnPage = 6
    fileprivate let revenue = 24.1
    fileprivate let conversionType = "add_to_cart_two"
    fileprivate let isCustomType = true
    fileprivate let displayName = "bongo"

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
        let query = CIOQuizQuery(quizID: "test-quiz")
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotEqual(responseData.quizVersionID, "")
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
            XCTAssertEqual(responseData.nextQuestion.options?[1].id, 2)
            XCTAssertEqual(responseData.nextQuestion.options?[1].value, "No")
            XCTAssertEqual(responseData.nextQuestion.options?[1].attribute?.name, "Brand")
            XCTAssertEqual(responseData.nextQuestion.options?[1].attribute?.value, "XYZ")
            XCTAssertNil(responseData.nextQuestion.options?[1].images?.primaryUrl)

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizNextQuestion_WithVersionIDAndSessionID() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizID: "test-quiz", quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID)
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertEqual(responseData.quizVersionID, self.quizVersionID)
            XCTAssertEqual(responseData.quizSessionID, self.quizSessionID)
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

    func testGetQuizNextQuestion_WithInvalidVersionID() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizID: "test-quiz", quizVersionID: "1")
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "The quiz you requested, \"test-quiz\" was not found with version \"1\", please specify a valid quiz id and remove the quiz_version_id parameter before trying again.")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizNextQuestion_WithSingleTypeUsingSingleAnswer() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizID: "test-quiz", answers: [["1"]])
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotEqual(responseData.quizVersionID, "")
            XCTAssertNotEqual(responseData.quizSessionID, "")
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
        let query = CIOQuizQuery(quizID: "test-quiz", answers: [["1", "2"]])
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
        let query = CIOQuizQuery(quizID: "test-quiz", answers: [["1"], ["1", "2"]])
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotEqual(responseData.quizVersionID, "")
            XCTAssertNotEqual(responseData.quizSessionID, "")
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
        let query = CIOQuizQuery(quizID: "test-quiz", answers: [["1"], ["true"]])
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
        let query = CIOQuizQuery(quizID: "test-quiz", answers: [["1"], ["1", "2"], ["seen"]])
        constructorClient.getQuizNextQuestion(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotEqual(responseData.quizVersionID, "")
            XCTAssertNotEqual(responseData.quizSessionID, "")
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
        let query = CIOQuizQuery(quizID: "test-quiz", answers: [["1"], ["1", "2"], ["true"]])
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
        let query = CIOQuizQuery(quizID: "test-quiz", answers: [["1"], ["1", "2"], ["true"], ["seen"]])
        constructorClient.getQuizResults(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotEqual(responseData.quizVersionID, "")
            XCTAssertNotEqual(responseData.quizSessionID, "")
            XCTAssertEqual(responseData.quizID, "test-quiz")
            XCTAssertNotEqual(responseData.resultID, "")
            XCTAssertGreaterThan(responseData.sortOptions.count, 0)
            XCTAssertGreaterThan(responseData.groups.count, 0)
            XCTAssertGreaterThan(responseData.facets.count, 0)
            XCTAssertGreaterThan(responseData.results.count, 0)
            XCTAssertGreaterThan(responseData.totalNumResults, 0)

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizResults_WithVersionIDAndSessionID() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizID: "test-quiz", answers: [["1"], ["1", "2"], ["true"], ["seen"]], quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID)
        constructorClient.getQuizResults(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertEqual(responseData.quizVersionID, self.quizVersionID)
            XCTAssertEqual(responseData.quizSessionID, self.quizSessionID)
            XCTAssertEqual(responseData.quizID, "test-quiz")
            XCTAssertNotEqual(responseData.resultID, "")
            XCTAssertGreaterThan(responseData.sortOptions.count, 0)
            XCTAssertGreaterThan(responseData.groups.count, 0)
            XCTAssertGreaterThan(responseData.facets.count, 0)
            XCTAssertGreaterThan(responseData.results.count, 0)
            XCTAssertGreaterThan(responseData.totalNumResults, 0)

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testGetQuizResults_WithInvalidVersionID() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOQuizQuery(quizID: "test-quiz", quizVersionID: "1")
        constructorClient.getQuizResults(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "The quiz you requested, \"test-quiz\" was not found with version \"1\", please specify a valid quiz id and remove the quiz_version_id parameter before trying again.")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackQuizResultClick() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackQuizResultClick(quizID: quizID, quizVersionID: quizVersionID, quizSessionID: quizSessionID, customerID: customerID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackQuizResultClick_WithOptionalParams() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackQuizResultClick(quizID: quizID, quizVersionID: quizVersionID, quizSessionID: quizSessionID, customerID: customerID, variationID: variationID, itemName: itemName, resultID: resultID, resultPage: resultPage, resultCount: resultCount, numResultsPerPage: numResultsPerPage, resultPositionOnPage: resultPositionOnPage, sectionName: sectionName, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackQuizResultsLoaded() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackQuizResultsLoaded(quizID: quizID, quizVersionID: quizVersionID, quizSessionID: quizSessionID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }   

    func testTrackQuizResultsLoaded_WithOptionalParams() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackQuizResultsLoaded(quizID: quizID, quizVersionID: quizVersionID, quizSessionID: quizSessionID,  resultID: resultID, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackQuizConversion() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackQuizConversion(quizID: quizID, quizVersionID: quizVersionID, quizSessionID: quizSessionID, customerID: customerID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackQuizConversion_WithOptionalParams() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackQuizConversion(quizID: quizID, quizVersionID: quizVersionID, quizSessionID: quizSessionID, customerID: customerID, variationID: variationID, itemName: itemName, revenue: revenue, conversionType: conversionType, isCustomType: isCustomType, displayName: displayName, sectionName: sectionName, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
}
