//
//  Collection+MapKeys.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension Dictionary {
    public func mapKeys<T>(_ mapping: (_ key: Key) -> T) -> [T: Value] {
        var newDictionary: [T: Value] = [:]
        for (key, value) in self {
            newDictionary[mapping(key)] = value
        }

        return newDictionary
    }
}
