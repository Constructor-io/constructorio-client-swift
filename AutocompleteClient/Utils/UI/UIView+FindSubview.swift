//
//  UIView+FindSubview.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

extension UIView {

    func findSubview(_ filter: (UIView) -> Bool) -> UIView? {
        for view in self.subviews {
            if filter(view) {
                return view
            } else if let subview = view.findSubview(filter) {
                return subview
            }
        }
        return nil
    }
}
