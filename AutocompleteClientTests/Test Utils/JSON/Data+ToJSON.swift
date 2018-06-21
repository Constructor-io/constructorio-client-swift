//
//  String+ToJSON.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 6/21/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation

extension Data{
    func toJSONDictionary() -> [String: Any]?{
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }
}
