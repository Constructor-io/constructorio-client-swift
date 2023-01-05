//
//  ConstructorIOUserSegmentsTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOUserSegmentsTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testAutocompleteWithOneSegment() {
        let config = ConstructorIOConfig(apiKey: "key_OucJxxrfiTVUQx0C", segments: ["Europe"])
        let constructor = TestConstants.testConstructor(config)
        let searchTerm = "boba"
        let query = CIOAutocompleteQuery(query: searchTerm)
        let builder = CIOBuilder(expectation: "Calling Autocomplete with a single segment should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/boba?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&us=Europe"), builder.create())
        constructor.autocomplete(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }

    func testAutocompleteWithsMultipleSegments() {
        let config = ConstructorIOConfig(apiKey: "key_OucJxxrfiTVUQx0C", segments: ["Europe", "Mobile"])
        let constructor = TestConstants.testConstructor(config)
        let searchTerm = "boba"
        let query = CIOAutocompleteQuery(query: searchTerm)
        let builder = CIOBuilder(expectation: "Calling Autocomplete with multiple segments should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/boba?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&us=Europe&us=Mobile"), builder.create())
        constructor.autocomplete(forQuery: query) { _ in }
        self.wait(for: builder.expectation)
    }

    func testTrackInputFocusWithOneSegment() {
        let config = ConstructorIOConfig(apiKey: "key_OucJxxrfiTVUQx0C", segments: ["America"])
        let constructor = TestConstants.testConstructor(config)
        let searchTerm = "corn"
        let builder = CIOBuilder(expectation: "Calling trackInputFocus with a single segment should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn&us=America"), builder.create())
        constructor.trackInputFocus(searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }

    func testTrackInputFocusWithMultipleSegments() {
        let config = ConstructorIOConfig(apiKey: "key_OucJxxrfiTVUQx0C", segments: ["America", "Desktop"])
        let constructor = TestConstants.testConstructor(config)
        let searchTerm = "corn"
        let builder = CIOBuilder(expectation: "Calling trackInputFocus with a single segment should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn&us=America&us=Desktop"), builder.create())
        constructor.trackInputFocus(searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }
}
