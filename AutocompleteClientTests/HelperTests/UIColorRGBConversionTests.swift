//
//  UIColorRGBConversionTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/4/19.
//  Copyright © 2019 xd. All rights reserved.
//

import XCTest
import ConstructorAutocomplete

class UIColorRGBConversionTests: XCTestCase {

    func testColor_RGBInitializer() {
        let color = UIColor.RGB(250, green: 200, blue: 33)
        XCTAssertNotNil(color)
    }

    func testColor_RGBAInitializer() {
        let color = UIColor.RGBA(250, green: 200, blue: 33, alpha: 0.5)
        XCTAssertNotNil(color)
    }

    func testColor_HexInitializer() {
        let color = UIColor.hex(rgb: 123456)
        XCTAssertNotNil(color)
    }

}
