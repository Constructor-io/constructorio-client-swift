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

    mutating func remove(key: String) {
        self[key] = nil
    }

    private subscript(value: String) -> URLQueryItem? {
        get {
            return queryItems[value]
        }
        set {
            queryItems[value] = newValue
        }
    }

    func all() -> [URLQueryItem] {
        return Array<URLQueryItem>(self.queryItems.values)
    }
}
