//
//  QueryItemCollectionTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class QueryItemCollectionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
