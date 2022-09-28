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
        self.constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: "key_ZEbQUNqnaQZWaHxr", baseURL: "https://quizzes.cnstrc.com"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testQuizzes_CreatesValidRequest() {
        let query = CIOQuizzesQuery(quizId: "etchells-emporium-quiz", answers: ["1", "2"])

        let builder = CIOBuilder(expectation: "Calling Quizzes should send a valid request.", builder: http(200))
        stub(regex("https://quizzes.cnstrc.com/v1/quizzes/etchells-emporium-quiz/next?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_ZEbQUNqnaQZWaHxr&a=1&a=2,3&a=seen&a=true&s=\(kRegexSession)"), builder.create())

        self.constructor.quizzes(forQuery: query, completionHandler: { response in })
//        self.wait(for: builder.expectation)
    }

    func testQuizzesNext_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Quizzes next with valid parameters should return a non-nil response.")

        let query = CIOQuizzesQuery(quizId: "etchells-emporium-quiz", answers: ["1", "2"])

        let dataToReturn = TestResource.load(name: TestResource.Response.quizzesJSONFilenameNext)
        stub(regex("https://quizzes.cnstrc.com/quizzes/etchells-emporium-quiz/next?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_ZEbQUNqnaQZWaHxr&a=1&a=2,3&a=seen&a=true&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.quizzes(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Quizzes next with valid parameters should return a non-nil response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testQuizzesFinalize_WithValidRequest_ReturnsNonNilResponse() {
        let expectation = self.expectation(description: "Calling Quizzes finalize with valid parameters should return a non-nil response.")

        let query = CIOQuizzesQuery(quizId: "etchells-emporium-quiz", answers: ["1", "2"])

        let dataToReturn = TestResource.load(name: TestResource.Response.quizzesJSONFilenameNext)
        stub(regex("https://quizzes.cnstrc.com/quizzes/etchells-emporium-quiz/finalize?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_ZEbQUNqnaQZWaHxr&a=1&a=2,3&a=seen&a=true&s=\(kRegexSession)"), http(200, data: dataToReturn))

        self.constructor.quizzes(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.data, "Calling Quizzes finalize next with valid parameters should return a non-nil response.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testQuizzes_ReturnsErrorObject_IfAPIReturnsInvalidResponse() {
        let expectation = self.expectation(description: "Calling Quizzes returns non-nil error if API errors out.")

        let query = CIOQuizzesQuery(quizId: "etchells-emporium-quiz", answers: ["1", "2"])
        stub(regex("https://quizzes.cnstrc.com/quizzes/etchells-emporium-quiz/next?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=key_ZEbQUNqnaQZWaHxr&a=1&a=2,3&a=seen&a=true&s=\(kRegexSession)"), http(404))

        self.constructor.quizzes(forQuery: query, completionHandler: { response in
            XCTAssertNotNil(response.error, "Quizzes Browse returns non-nil error if API errors out.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
}
