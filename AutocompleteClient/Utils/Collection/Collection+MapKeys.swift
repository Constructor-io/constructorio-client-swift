//
//  Collection+MapKeys.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 3/9/18.
//  Copyright © 2018 xd. All rights reserved.
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

extension Dictionary where Key == String, Value == Any{
    
    func mapToAttributedStringKeys() -> [NSAttributedStringKey: Any]{
        let keyMapping: (String) -> NSAttributedStringKey = { key in return NSAttributedStringKey(rawValue: key) }
        return self.mapKeys(keyMapping)
    }
}
