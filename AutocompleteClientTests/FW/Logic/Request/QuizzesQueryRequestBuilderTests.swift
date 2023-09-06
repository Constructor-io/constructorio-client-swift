//
//  QuizzesQueryRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class QuizzesQueryRequestBuilderTests: XCTestCase {
    fileprivate let quizID: String = "1"
    fileprivate let answers: [[String]] = [["1"], ["2", "3"], ["seen"], ["true"]]
    fileprivate let quizVersionID: String = "version-id"
    fileprivate let quizSessionID: String = "session-id"
    fileprivate var endodedQuery: String = ""
    fileprivate let testACKey: String = "abcdefgh123"
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: self.testACKey, baseQuizURL: "https://quizzes.cnstrc.com")
    }

    func testQuizQueryBuilder_NextQuestion() {
        let query = CIOQuizQuery(quizID: self.quizID, answers: self.answers, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID)
        builder.build(trackData: query)
        let request = builder.getQuizRequest(finalize: false)
        let url = request.url!.absoluteString
        print(url)
        XCTAssertTrue(url.hasPrefix("https://quizzes.cnstrc.com/v1/quizzes/\(quizID)/next"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertTrue(url.contains("quiz_version_id=version-id"), "URL should contain the quiz version id")
        XCTAssertTrue(url.contains("quiz_session_id=session-id"), "URL should contain the quiz session id")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testQuizQueryBuilder_QuizResults() {
        let query = CIOQuizQuery(quizID: self.quizID, answers: self.answers, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID)
        builder.build(trackData: query)
        let request = builder.getQuizRequest(finalize: true)
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://quizzes.cnstrc.com/v1/quizzes/\(quizID)/results"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertTrue(url.contains("quiz_version_id=version-id"), "URL should contain the quiz version id")
        XCTAssertTrue(url.contains("quiz_session_id=session-id"), "URL should contain the quiz session id")
        XCTAssertEqual(request.httpMethod, "GET")
    }
}
