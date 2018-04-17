//
//  Collection+MapKeys.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension Dictionary{
    func mapKeys<T>(_ mapping: (_ key: Key) -> T) -> [T: Value]{
        var newDictionary: [T: Value] = [:]
        for (k,v) in self{
            newDictionary[mapping(k)] = v
        }
        
        return newDictionary
    }
}

