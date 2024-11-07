//
//  CustomSearchController.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

public class CustomSearchController: UISearchController {

    @objc lazy var searchBarPvt: CustomSearchBar = {
        [unowned self] in
        let customSearchBar = CustomSearchBar(frame: CGRect.zero)
        return customSearchBar
    }()

    override public var searchBar: UISearchBar {
        get {
            return searchBarPvt
        }
    }
}
