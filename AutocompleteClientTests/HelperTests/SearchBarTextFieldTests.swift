//
//  SearchBarTextFieldTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/4/19.
//  Copyright © 2019 xd. All rights reserved.
//

import XCTest
import ConstructorAutocomplete

class SearchBarTextFieldTests: XCTestCase {

    func testTextFieldExtractFromSearchBar() {
        let searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.layoutIfNeeded()
        XCTAssertNotNil(searchBar.searchTextField())
    }

}
