//
//  CIOAutocompleteResult+Mock.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

public extension CIOAutocompleteResult {

    class func mock(withValue value: String, group: CIOGroup? = nil) -> CIOAutocompleteResult {
        let json: [String: Any] = TestResource.load(name: TestResource.Response.singleResultJSONFilename).toJSONDictionary()!
        return CIOAutocompleteResult(result: CIOResult(json: json)!, group: group)
    }

}
