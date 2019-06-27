//
//  String+CharacterSetIteratorTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class CharacterSetIteratorTests: XCTestCase {

    func testStringCharacterSetIterator_EmptyString_EmptyIterator() {
        var iterator = "".makeIterator(characterSet: .alphanumerics)
        XCTAssertNil(iterator.next())
    }

    func testStringCharacterSetIterator_NoMatches() {
        var iterator = "!@#@###+×⊈".makeIterator(characterSet: .alphanumerics)
        assertPairEqual(iterator.next()!, (false, "!@#@###+×⊈"))
        XCTAssertNil(iterator.next())
    }

    func testStringCharacterSetIterator_FirstTokenMatch() {
        var iterator = "test!@!@2131#()@(#".makeIterator(characterSet: .alphanumerics)
        assertPairEqual(iterator.next()!, (true, "test"))
        assertPairEqual(iterator.next()!, (false, "!@!@"))
        assertPairEqual(iterator.next()!, (true, "2131"))
        assertPairEqual(iterator.next()!, (false, "#()@(#"))
    }

    func testStringCharacterSetIterator_SecondTokenMatch() {
        var iterator = ")#&(@!#match#@(#(asd".makeIterator(characterSet: .alphanumerics)
        assertPairEqual(iterator.next()!, (false, ")#&(@!#"))
        assertPairEqual(iterator.next()!, (true, "match"))
        assertPairEqual(iterator.next()!, (false, "#@(#("))
        assertPairEqual(iterator.next()!, (true, "asd"))
    }

    func testStringCharacterSetIterator_FinalTokenMatch() {
        var iterator = "!@#@!#>:match".makeIterator(characterSet: .alphanumerics)
        assertPairEqual(iterator.next()!, (false, "!@#@!#>:"))
        assertPairEqual(iterator.next()!, (true, "match"))
    }

    func testStringCharacterSetIterator() {
        var iterator = "abc-def-ghijk--lm  nopq".makeIterator(characterSet: .alphanumerics)
        assertPairEqual(iterator.next()!, (true, "abc"))
        assertPairEqual(iterator.next()!, (false, "-"))
        assertPairEqual(iterator.next()!, (true, "def"))
        assertPairEqual(iterator.next()!, (false, "-"))
        assertPairEqual(iterator.next()!, (true, "ghijk"))
        assertPairEqual(iterator.next()!, (false, "--"))
        assertPairEqual(iterator.next()!, (true, "lm"))
        assertPairEqual(iterator.next()!, (false, "  "))
        assertPairEqual(iterator.next()!, (true, "nopq"))
    }

    fileprivate func assertPairEqual<S: Equatable, T: Equatable>(_ first: (S, T), _ second: (S, T)) {
        XCTAssertEqual(first.0, second.0)
        XCTAssertEqual(first.1, second.1)
    }

}
