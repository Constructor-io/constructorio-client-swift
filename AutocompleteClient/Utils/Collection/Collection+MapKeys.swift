//
//  Collection+MapKeys.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension Dictionary {
    func mapKeys<T>(_ mapping: (_ key: Key) -> T) -> [T: Value] {
        var newDictionary: [T: Value] = [:]
        for (key, value) in self {
            newDictionary[mapping(key)] = value
        }

        return newDictionary
    }
}
