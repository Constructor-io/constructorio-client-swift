//
//  DefaultSearchItemCellTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class DefaultSearchItemCellTests: XCTestCase {

    func testDefaultSearchCell_InstantiationAndSetup_WithoutGroup() {
        if let cell = UINib(nibName: "DefaultSearchItemCell", bundle: Bundle.testBundle()).instantiate(withOwner: nil, options: nil).first as? DefaultSearchItemCell {
            let result = CIOResult.mock(withValue: "test")

            let font = UIFont.systemFont(ofSize: 12)
            let color = UIColor.red
            let highlighter = CIOHighlighter(attributesProvider: BoldAttributesProvider(fontNormal: font, fontBold: font, colorNormal: color, colorBold: color))
            cell.setup(result: result, searchTerm: "searchTerm", highlighter: highlighter)
        }
    }

    func testDefaultSearchCell_InstantiationAndSetup_WithGroup() {
        if let cell = UINib(nibName: "DefaultSearchItemCell", bundle: Bundle.testBundle()).instantiate(withOwner: nil, options: nil).first as? DefaultSearchItemCell {
            let result = CIOResult.mock(withValue: "test", group: CIOGroup.mock())

            let font = UIFont.systemFont(ofSize: 12)
            let color = UIColor.red
            let highlighter = CIOHighlighter(attributesProvider: BoldAttributesProvider(fontNormal: font, fontBold: font, colorNormal: color, colorBold: color))
            cell.setup(result: result, searchTerm: "searchTerm", highlighter: highlighter)
        }

    }

}
