//
//  ConstructorIOABTestCellTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
import ConstructorAutocomplete

class ConstructorIOABTestCellTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackInputFocus_WithTwoCells() {
        let config = ConstructorIOConfig(apiKey: "key_OucJxxrfiTVUQx0C", testCells: [
            CIOABTestCell(key: "hi", value: "there"),
            CIOABTestCell(key: "howare", value: "you")
        ])
        let constructor = TestConstants.testConstructor(config)
        let searchTerm = "corn"
        let builder = CIOBuilder(expectation: "Calling trackInputFocus should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&ef-hi=there&ef-howare=you&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn"), builder.create())
        constructor.trackInputFocus(searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }

    func testTrackInputFocus_WithOneCell() {
        let config = ConstructorIOConfig(apiKey: "key_OucJxxrfiTVUQx0C", testCells: [
            CIOABTestCell(key: "hi", value: "there")
        ])
        let constructor = TestConstants.testConstructor(config)
        let searchTerm = "corn"
        let builder = CIOBuilder(expectation: "Calling trackInputFocus should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&ef-hi=there&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&s=\(kRegexSession)&term=corn"), builder.create())
        constructor.trackInputFocus(searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }

}
