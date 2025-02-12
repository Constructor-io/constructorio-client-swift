//
//  DefaultSearchItemCellTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class DefaultSearchItemCellTests: XCTestCase {

    func testDefaultSearchCell_InstantiationAndSetup_WithoutGroup() {
        if let cell = UINib(nibName: "DefaultSearchItemCell", bundle: Bundle.testBundle()).instantiate(withOwner: nil, options: nil).first as? DefaultSearchItemCell {
            let result = CIOAutocompleteResult.mock(withValue: "test")

            let font = UIFont.systemFont(ofSize: 12)
            let color = UIColor.red
            let highlighter = CIOHighlighter(attributesProvider: BoldAttributesProvider(fontNormal: font, fontBold: font, colorNormal: color, colorBold: color))
            cell.setup(result: result, searchTerm: "searchTerm", highlighter: highlighter)
        }
    }

    func testDefaultSearchCell_InstantiationAndSetup_WithGroup() {
        if let cell = UINib(nibName: "DefaultSearchItemCell", bundle: Bundle.testBundle()).instantiate(withOwner: nil, options: nil).first as? DefaultSearchItemCell {
            let result = CIOAutocompleteResult.mock(withValue: "test", group: CIOGroup.mock())

            let font = UIFont.systemFont(ofSize: 12)
            let color = UIColor.red
            let highlighter = CIOHighlighter(attributesProvider: BoldAttributesProvider(fontNormal: font, fontBold: font, colorNormal: color, colorBold: color))
            cell.setup(result: result, searchTerm: "searchTerm", highlighter: highlighter)
        }

    }

}
