//
//  String+URLEncode.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension String {
    func URLEncode() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? self
    }
}
