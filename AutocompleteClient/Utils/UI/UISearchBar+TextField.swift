//
//  UISearchBar+TextField.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

public extension UISearchBar {
    func searchTextField() -> UITextField? {
        return self.findSubview({ view -> Bool in view is UITextField }) as? UITextField
    }
}
