//
//  QuizzesQueryRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class QuizzesQueryRequestBuilderTests: XCTestCase {
    fileprivate let quizId: String = "1"
    fileprivate let answers: [[String]] = [["1"], ["2", "3"], ["seen"], ["true"]]
    fileprivate let versionId: String = "version-id"
    fileprivate var endodedQuery: String = ""
    fileprivate let testACKey: String = "abcdefgh123"
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: self.testACKey, baseQuizURL: "https://quizzes.cnstrc.com")
    }

    func testQuizQueryBuilder_NextQuestion() {
        let query = CIOQuizQuery(quizId: self.quizId, answers: self.answers, versionId: self.versionId)
        builder.build(trackData: query)
        let request = builder.getQuizRequest(finalize: false)
        let url = request.url!.absoluteString
        print(url)
        XCTAssertTrue(url.hasPrefix("https://quizzes.cnstrc.com/v1/quizzes/\(quizId)/next"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertTrue(url.contains("version_id=version-id"), "URL should contain the quiz version id")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testQuizQueryBuilder_QuizResults() {
        let query = CIOQuizQuery(quizId: self.quizId, answers: self.answers, versionId: self.versionId)
        builder.build(trackData: query)
        let request = builder.getQuizRequest(finalize: true)
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("https://quizzes.cnstrc.com/v1/quizzes/\(quizId)/finalize"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertTrue(url.contains("version_id=version-id"), "URL should contain the quiz version id")
        XCTAssertEqual(request.httpMethod, "GET")
    }
}
