//
//  SearchBarTextFieldTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

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
