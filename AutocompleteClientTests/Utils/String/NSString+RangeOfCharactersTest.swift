//
//  NSString+RangeOfCharactersTest.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class RangeOfCharactersTest: XCTestCase {

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
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSRange(location: 0, length: 1))
    }

    func testRangeOfCharacters_SingleMatchStartOfString() {
        let testString = NSString(string: "TEST   👌🙌👏🤔")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSRange(location: 0, length: 4))
    }

    func testRangeOfCharacters_SingleMatchLengthOneMiddleOfString() {
        let testString = NSString(string: "-!??h!@##$")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSRange(location: 4, length: 1))
    }

    func testRangeOfCharacters_SingleMatchMiddleOfString() {
        let testString = NSString(string: "$#&$abcde1@#@#!")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSRange(location: 4, length: 6))
    }

    func testRangeOfCharacters_SingleMatchLengthOneEndOfString() {
        let testString = NSString(string: "   !!/ -- 1")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSRange(location: 10, length: 1))
    }

    func testRangeOfCharacters_SingleMatchEndOfString() {
        let testString = NSString(string: " !#@*( #!@*#*(   asdf")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSRange(location: 17, length: 4))
    }

    func testRangeOfCharacters_MultipleMatches_ReturnsFirstMatchRange() {
        let testString = NSString(string: " !#!#abs !@!@ qwewe")
        XCTAssertEqual(testString.rangeOfCharacters(from: .alphanumerics), NSRange(location: 5, length: 3))
    }

}
