//
//  NSString+RangeOfCharactersTest.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class NSString_RangeOfCharactersTest: XCTestCase {
    
    func testRangeOfCharacters_EmptyString_LocationNotFound() {
        let emptyString = NSString(string: "")
        let allCharSet = CharacterSet.alphanumerics.inverted.union(.alphanumerics)
        XCTAssertEqual(emptyString.rangeOfCharacters(from: allCharSet).location, NSNotFound)
    }

    func testRangeOfCharacters_NoMatch_LocationNotFound() {
        let testString = NSString(string: "~!@#$%^&*()_+`-=[]\\{}|;':\",./<>?")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics).location, NSNotFound)
    }

    func testRangeOfCharacters_SingleMatchLengthOneStartOfString() {
        let testString = NSString(string: "a-!!😂😂")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSMakeRange(0, 1))
    }

    func testRangeOfCharacters_SingleMatchStartOfString() {
        let testString = NSString(string: "TEST   👌🙌👏🤔")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSMakeRange(0, 4))
    }

    func testRangeOfCharacters_SingleMatchLengthOneMiddleOfString() {
        let testString = NSString(string: "-!??h!@##$")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSMakeRange(4, 1))
    }

    func testRangeOfCharacters_SingleMatchMiddleOfString() {
        let testString = NSString(string: "$#&$abcde1@#@#!")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSMakeRange(4, 6))
    }

    func testRangeOfCharacters_SingleMatchLengthOneEndOfString() {
        let testString = NSString(string: "   !!/ -- 1")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSMakeRange(10, 1))
    }

    func testRangeOfCharacters_SingleMatchEndOfString() {
        let testString = NSString(string: " !#@*( #!@*#*(   asdf")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSMakeRange(17, 4))
    }

    func testRangeOfCharacters_MultipleMatches_ReturnsFirstMatchRange() {
        let testString = NSString(string: " !#!#abs !@!@ qwewe")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSMakeRange(5, 3))
    }
    
}
