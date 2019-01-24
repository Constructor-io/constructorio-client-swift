//
//  SearchTermValidatorTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/24/19.
//  Copyright © 2019 xd. All rights reserved.
//

import XCTest
import ConstructorAutocomplete

class SearchTermValidatorTests: XCTestCase {

    let validator = SearchTermValidator()
    let termUnknown = Constants.Track.unknownTerm

    func testSearchTerm_Nil_ReturnsTermUnknown(){
        XCTAssertEqual(self.validator.validateSearchTerm(nil), self.termUnknown)
    }

    func testSearchTerm_Empty_ReturnsTermUnknown(){
        XCTAssertEqual(self.validator.validateSearchTerm(""), self.termUnknown)
    }

    func testSearchTerm_ContainingSingleSpace_ReturnsTermUnknown(){
        XCTAssertEqual(self.validator.validateSearchTerm(" "), self.termUnknown)
    }

    func testSearchTerm_ContainingSpaces_ReturnsTermUnknown(){
        XCTAssertEqual(self.validator.validateSearchTerm("     "), self.termUnknown)
    }

    func testSearchTerm_ContainingPunctuationCharacters_ReturnsTermUnknown(){
        XCTAssertEqual(self.validator.validateSearchTerm("!@#$%^&*()_+±-}[{]|'/?,.<>~`"), self.termUnknown)
    }

    func testSearchTerm_ContainingSingleLetter_ReturnsValidTerm(){
        let term = "a"
        XCTAssertEqual(self.validator.validateSearchTerm(term), term)
    }

    func testSearchTerm_ContainingMultipleLetters_ReturnsValidTerm(){
        let term = "abcd"
        XCTAssertEqual(self.validator.validateSearchTerm(term), term)
    }

    func testSearchTerm_ContainingSingleNumber_ReturnsValidTerm(){
        let term = "1"
        XCTAssertEqual(self.validator.validateSearchTerm(term), term)
    }

    func testSearchTerm_ContainingMultipleNumbers_ReturnsValidTerm(){
        let term = "1234"
        XCTAssertEqual(self.validator.validateSearchTerm(term), term)
    }

    func testSearchTerm_ContainingLettersPrefixedBySpace_ReturnsValidTerm(){
        let term = " abc"
        XCTAssertEqual(self.validator.validateSearchTerm(term), term)
    }

    func testSearchTerm_ContainingNumbersPrefixedBySpace_ReturnsValidTerm(){
        let term = " 123"
        XCTAssertEqual(self.validator.validateSearchTerm(term), term)
    }

    func testSearchTerm_ContainingLettersAndNumbers_ReturnsValidTerm(){
        let term = "abc123"
        XCTAssertEqual(self.validator.validateSearchTerm(term), term)
    }

    func testSearchTerm_ContainingLettersAndNumbersPrefixedBySpaces_ReturnsValidTerm(){
        let term = "   abc123 "
        XCTAssertEqual(self.validator.validateSearchTerm(term), term)
    }

}
