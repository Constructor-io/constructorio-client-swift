//
//  ConstructorIOAutocompleteTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class ConstructorIOAutocompleteTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    func testAutocomplete_With200() {
        let term = "heart"
        let query = CIOAutocompleteQuery(query: term)

        let builder = CIOBuilder(expectation: "Calling Autocomplete with 200 should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/a%20autocompleteterm?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())

        self.constructor.autocomplete(forQuery: query) { (res) in
            let data = res.data! as CIOAutocompleteResponse
            let sections = data.sections as [String: [CIOAutocompleteResult]]
            let json = data.json as JSONObject
            print(sections)
            print(json)
        }
        self.wait(for: builder.expectation)
    }

    func testAutocomplete_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling autocomplete with no connectvity should return noConnectivity CIOError.")
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)

        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), noConnectivity())

        self.constructor.autocomplete(forQuery: query) { (response) in
            if let error = response.error as? CIOError {
                XCTAssertEqual(error, CIOError.noConnection, "Returned error from network client should be type CIOError.noConnection.")
                expectation.fulfill()
            }
        }
        self.wait(for: expectation)
    }

    func testAutocomplete_With400() {
        let expectation = self.expectation(description: "Calling autocomplete with 400 should return badRequest CIOError.")
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)

        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(400))

        self.constructor.autocomplete(forQuery: query) { (response) in
            if let error = response.error as? CIOError {
                XCTAssertEqual(error, CIOError.badRequest, "Returned error from network client should be type CIOError.badRequest.")
                expectation.fulfill()
            }
        }
        self.wait(for: expectation)
    }

    func testAutocomplete_With500() {
        let expectation = self.expectation(description: "Calling autocomplete with 500 should return internalServerError CIOError.")
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)

        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(500))

        self.constructor.autocomplete(forQuery: query) { (response) in
            if let error = response.error as? CIOError {
                XCTAssertEqual(error, CIOError.internalServerError, "Returned error from network client should be type CIOError, internalServerError.")
                expectation.fulfill()
            }
        }
        self.wait(for: expectation)
    }

}
