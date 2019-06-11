//
//  NSAttributedString+Build.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

extension NSAttributedString {

    static func build(string: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: attributes)
    }
}
