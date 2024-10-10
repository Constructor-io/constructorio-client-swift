//
//  SearchBarTextFieldTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class SearchBarTextFieldTests: XCTestCase {

    func testTextFieldExtractFromSearchBar() {
        let searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.layoutIfNeeded()
        XCTAssertNotNil(searchBar.searchTextField())
    }

    func testCustomSearchBar_WithDefaultInitializer() {
        let searchBar = CustomSearchBar()
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func testCustomSearchBar_WithFrameInitializer() {
        let searchBar = CustomSearchBar(frame: .zero)
        searchBar.setShowsCancelButton(true, animated: true)
    }
}
