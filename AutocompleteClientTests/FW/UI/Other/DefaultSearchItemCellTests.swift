//
//  DefaultSearchItemCellTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/6/19.
//  Copyright © 2019 xd. All rights reserved.
//

import XCTest
import ConstructorAutocomplete

class DefaultSearchItemCellTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultSearchCell_InstantiationAndSetup_WithoutGroup() {
        let cell = UINib(nibName: "DefaultSearchItemCell", bundle: Bundle.testBundle()).instantiate(withOwner: nil, options: nil).first as! DefaultSearchItemCell

        let result = CIOResult.mock(withValue: "test")

        let font = UIFont.systemFont(ofSize: 12)
        let color = UIColor.red
        let highlighter = CIOHighlighter(attributesProvider: BoldAttributesProvider(fontNormal: font, fontBold: font, colorNormal: color, colorBold: color))
        cell.setup(result: result, searchTerm: "searchTerm", highlighter: highlighter)
    }

    func testDefaultSearchCell_InstantiationAndSetup_WithGroup() {
        let cell = UINib(nibName: "DefaultSearchItemCell", bundle: Bundle.testBundle()).instantiate(withOwner: nil, options: nil).first as! DefaultSearchItemCell

        let result = CIOResult.mock(withValue: "test", group: CIOGroup.mock())

        let font = UIFont.systemFont(ofSize: 12)
        let color = UIColor.red
        let highlighter = CIOHighlighter(attributesProvider: BoldAttributesProvider(fontNormal: font, fontBold: font, colorNormal: color, colorBold: color))
        cell.setup(result: result, searchTerm: "searchTerm", highlighter: highlighter)
    }

}
