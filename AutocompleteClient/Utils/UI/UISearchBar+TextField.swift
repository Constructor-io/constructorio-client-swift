//
//  UISearchBar+TextField.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public extension UISearchBar {
    func searchTextField() -> UITextField? {
        return self.findSubview({ view -> Bool in view is UITextField }) as? UITextField
    }
}
