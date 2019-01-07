//
//  ConstructorIOUserIDTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class ConstructorIOUserIDTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
        self.constructor.userID = "abcdefg"
    }

    func testAutocomplete() {
        let term = "a term"
        let query = CIOAutocompleteQuery(query: term)
        let builder = CIOBuilder(expectation: "Calling Autocomplete with 200 should return a response", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/a%20term?s=1&i=\(kRegexClientID)&ui=abcdefg&key=key_OucJxxrfiTVUQx0C&c=cioios-&_dt=\(kRegexTimestamp)"), builder.create())

        self.constructor.autocomplete(forQuery: query) { (_) in }
        self.wait(for: builder.expectation)
    }

    func testTrackInputFocus() {
        let searchTerm = "corn"
        let builder = CIOBuilder(expectation: "Calling trackInputFocus should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?action=focus&i=\(kRegexClientID)&ui=abcdefg&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&term=corn&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackInputFocus(searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }
}
