//
//  CIOHighlighterTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class CIOHighlighterTests: XCTestCase {

    fileprivate let fontSize: CGFloat = 16
    fileprivate var provider: BoldAttributesProvider!
    fileprivate var highlighter: CIOHighlighter!

    override func setUp() {
        super.setUp()
        provider = BoldAttributesProvider(fontNormal: .systemFont(ofSize: fontSize),
                                          fontBold: .boldSystemFont(ofSize: fontSize),
                                          colorNormal: UIColor.black,
                                          colorBold: UIColor.black)
        highlighter = CIOHighlighter(attributesProvider: provider)
    }

    func testHighlighter_NoMatches_NoHighlights() {
        let result = highlighter.highlight(searchTerm: "this is a test", itemTitle: "no matches in item!")
        XCTAssertEqual(result, NSAttributedString(string: "no matches in item!", attributes: [NSAttributedString.Key.font: provider.fontBold,
                                                                                              NSAttributedString.Key.foregroundColor: provider.colorBold]))
    }

    func testHighlighter_AllMatch_AllHighlighted() {
        let exactMatch = "match every word"
        let result = highlighter.highlight(searchTerm: exactMatch, itemTitle: exactMatch)
        XCTAssertEqual(result, highlight(onEvenTokens: true, strings: ["match", " ", "every", " ", "word"]))
    }

    func testHighlighter_FullMatch_MatchFullHighlighted() {
        let result = highlighter.highlight(searchTerm: "test term", itemTitle: "term test 100")
        XCTAssertEqual(result, highlight(onEvenTokens: true, strings: ["term", " ", "test", " 100"]))
    }

    func testHighlighter_PrefixMatch_MatchPrefixHighlighted() {
        let result = highlighter.highlight(searchTerm: "pref matches wo", itemTitle: "prefix matches!!--wow!!")
        XCTAssertEqual(result, highlight(onEvenTokens: true, strings: ["pref", "ix ", "matches", "!!--", "wo", "w!!"]))
    }

    func testHighlighter_PrefixAndFullMatch() {
        let result = highlighter.highlight(searchTerm: "pref-an-fullmatch", itemTitle: "abc-prefix-and-fullmatch")
        XCTAssertEqual(result, highlight(onEvenTokens: false, strings: ["abc-", "pref", "ix-", "an", "d-", "fullmatch"]))
    }

    fileprivate func highlight(onEvenTokens: Bool, strings: [String]) -> NSAttributedString {
        let highlightedString = NSMutableAttributedString()
        var shouldHighlight = onEvenTokens
        for string in strings {
            guard shouldHighlight else {
                highlightedString.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: provider.fontBold,
                                                                                        NSAttributedString.Key.foregroundColor: provider.colorBold]))
                shouldHighlight = !shouldHighlight
                continue
            }

            highlightedString.append(NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: provider.fontNormal,
                                                                                     NSAttributedString.Key.foregroundColor: provider.colorNormal]))
            shouldHighlight = !shouldHighlight
        }

        return highlightedString
    }

}
