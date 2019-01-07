//
//  QueryItemCollection.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct QueryItemCollection {
    private var queryItems = [String: URLQueryItem]()

    mutating func add(_ item: URLQueryItem) {
        self[item.name] = item
    }

    mutating func addMultiple(index: Int, item: URLQueryItem) {
        self[item.name + String(index)] = item
    }

    mutating func remove(name: String) {
        self[name] = nil
    }

    private subscript(name: String) -> URLQueryItem? {
        get {
            return queryItems[name]
        }
        set {
            queryItems[name] = newValue
        }
    }

    func all() -> [URLQueryItem] {
        return Array<URLQueryItem>(self.queryItems.values)
    }
}
