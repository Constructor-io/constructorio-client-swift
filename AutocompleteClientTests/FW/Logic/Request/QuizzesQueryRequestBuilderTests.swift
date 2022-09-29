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
    fileprivate let answers: [String] = ["1", "2,3", "seen", "true"]
    fileprivate var endodedQuery: String = ""
    fileprivate let testACKey: String = "abcdefgh123"
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
//        self.endodedQuery = answers.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.builder = RequestBuilder(apiKey: self.testACKey, baseURL: "https://quizzes.cnstrc.com")
    }

    func testQuizzesQueryBuilder() {
        let query = CIOQuizzesQuery(quizId: self.quizId, answers: self.answers)
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        print(url)
        XCTAssertTrue(url.hasPrefix("https://quizzes.cnstrc.com/v1/quizzes/\(quizId)/next"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testQuizzesQueryBuilder_next() {
        var query = CIOQuizzesQuery(quizId: self.quizId, answers: self.answers)
        query.finalize = true
        builder.build(trackData: query)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        print(url)
        XCTAssertTrue(url.hasPrefix("https://quizzes.cnstrc.com/v1/quizzes/\(quizId)/finalize"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain api key.")
        XCTAssertEqual(request.httpMethod, "GET")
    }
}
