//
//  NSAttributedString+Build.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

extension NSAttributedString {

    static func build(string: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: attributes)
    }
}
