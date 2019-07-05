//
//  QueryItemCollectionTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class QueryItemCollectionTests: XCTestCase {

    func testQueryItemCollection_Remove() {
        var collection = QueryItemCollection()
        collection.remove(name: "key")
    }

    func testQueryItemCollection_SubscriptGetter() {
        var collection = QueryItemCollection()
        let _ = collection["key"]
    }

    func testQueryItemCollection_SubscriptSetter() {
        var collection = QueryItemCollection()
        collection["key"] = [URLQueryItem(name: "name", value: "value")]
    }

}
