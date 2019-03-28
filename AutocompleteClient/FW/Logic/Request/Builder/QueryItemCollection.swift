//
//  QueryItemCollection.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct QueryItemCollection {
    private var queryItems = [String: [URLQueryItem]]()

    public init() {} 

    mutating func add(key: String,items: [URLQueryItem]) {
        queryItems[key] = items
    }
    
    public mutating func add(_ item: URLQueryItem) {
        self[item.name] = [item]
    }

    public mutating func addMultiple(index: Int, item: URLQueryItem) {
        self[item.name + String(index)] = [item]
    }
    
    public subscript(value: String) -> [URLQueryItem]? {
        get {
            return queryItems[value]
        }
        set {
            if let newValue = newValue{
                if var existingArray = queryItems[value]{
                    existingArray.append(contentsOf: newValue)
                    queryItems[value] = existingArray
                } else {
                    queryItems[value] = newValue
                }
            } else {
                queryItems.removeValue(forKey: value)
            }   
        }
    }

    public mutating func remove(name: String) {
        self[name] = nil
    }
    
    func all() -> [URLQueryItem] {
        let flattenedArray = self.queryItems.values.reduce([]) { (res, next) -> [URLQueryItem] in
            return res + next.reduce([], { (res, next) in return res + [next] })
        }
        return flattenedArray.sorted(by: { item1, item2 -> Bool in
            if item1.name == item2.name{
                return (item1.value ?? "") < (item2.value ?? "")
            }
            return item1.name < item2.name
        })
    }
}
