//
//  QueryItemCollectionTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class QueryItemCollectionTests: XCTestCase {

    func testQueryItemCollection_Remove() {
        var collection = QueryItemCollection()
        collection.remove(name: "key")
    }

    func testQueryItemCollection_SubscriptGetter() {
        let collection = QueryItemCollection()
        _ = collection["key"]
    }

    func testQueryItemCollection_SubscriptSetter() {
        var collection = QueryItemCollection()
        collection["key"] = [URLQueryItem(name: "name", value: "value")]
    }

}
