//
//  CustomSearchController.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class CustomSearchController: UISearchController {

    @objc lazy var searchBarPvt: CustomSearchBar = {
        [unowned self] in
        let customSearchBar = CustomSearchBar(frame: CGRect.zero)
        return customSearchBar
    }()

    override var searchBar: UISearchBar {
        get {
            return searchBarPvt
        }
    }
}
