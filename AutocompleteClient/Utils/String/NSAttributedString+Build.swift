//
//  NSAttributedString+Build.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

extension NSAttributedString{
    
    static func build(string: String, attributes: [String: Any]) -> NSAttributedString{
        #if swift(>=4.0)
            let stringKeyAttributes = attributes.mapKeys({ (str) -> NSAttributedStringKey in
                return NSAttributedStringKey(str)
            })
            return NSAttributedString(string: string, attributes: stringKeyAttributes)
        #else
            return NSAttributedString(string: string, attributes: attributes)
        #endif
    }
}
