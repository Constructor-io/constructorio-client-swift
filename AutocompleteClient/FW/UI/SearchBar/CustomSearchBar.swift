//
//  CustomSearchBar.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public class CustomSearchBar: UISearchBar {

    var shouldShowCancelButton: Bool = false

    override public func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(self.shouldShowCancelButton && self.isFirstResponder, animated: animated)
    }

}
