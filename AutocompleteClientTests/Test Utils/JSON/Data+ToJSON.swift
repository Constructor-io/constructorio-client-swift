//
//  String+ToJSON.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import XCTest

public extension Data {
    func toJSONDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }
}
