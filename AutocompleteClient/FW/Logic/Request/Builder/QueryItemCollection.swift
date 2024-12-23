//
//  QueryItemCollection.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct QueryItemCollection {
    private var queryItems = [String: [URLQueryItem]]()

    init() {}

    mutating func add(key: String, items: [URLQueryItem]) {
        queryItems[key] = items
    }

    mutating func add(_ item: URLQueryItem) {
        self[item.name] = [item]
    }

    mutating func addMultiple(index: Int, item: URLQueryItem) {
        self[item.name + String(index)] = [item]
    }

    subscript(value: String) -> [URLQueryItem]? {
        get {
            return queryItems[value]
        }
        set {
            if let newValue = newValue {
                if var existingArray = queryItems[value] {
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

    mutating func remove(name: String) {
        self[name] = nil
    }

    func all() -> [URLQueryItem] {
        let flattenedArray = self.queryItems.values.reduce([]) { res, next -> [URLQueryItem] in
            return res + next.reduce([], { res, next in return res + [next] })
        }
        return flattenedArray.sorted(by: { item1, item2 -> Bool in
            if item1.name == item2.name {
                return (item1.value ?? "") < (item2.value ?? "")
            }
            return item1.name < item2.name
        })
    }

    func allAsDictionary() -> [String: Any] {
        let flattenedArray = self.queryItems.values.reduce([]) { res, next -> [URLQueryItem] in
            return res + next.reduce([], { res, next in return res + [next] })
        }
        var dict: [String: Any] = [:]
        flattenedArray.forEach { item in
            if item.value != nil {
                dict[item.name] = item.value
            }
        }
        dict["us"] = nil
        // swiftlint:disable force_cast
        if dict["s"] != nil {
            dict["s"] = Int64(dict["s"] as! String)
        }
        if dict["_dt"] != nil {
            dict["_dt"] = Int64(dict["_dt"] as! String)
        }
        // swiftlint:enable force_cast
        return dict
    }
}
