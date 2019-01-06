//
//  QueryItemCollection.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct QueryItemCollection {
    private var queryItems = [String: URLQueryItem]()

    public init(){}

    public mutating func add(_ item: URLQueryItem) {
        self[item.name] = item
    }

    public mutating func addMultiple(index: Int, item: URLQueryItem) {
        self[item.name + String(index)] = item
    }

    public mutating func remove(name: String) {
        self[name] = nil
    }

    public subscript(name: String) -> URLQueryItem? {
        get {
            return queryItems[name]
        }
        set {
            queryItems[name] = newValue
        }
    }

    public func all() -> [URLQueryItem] {
        return Array<URLQueryItem>(self.queryItems.values)
    }
}
