//
//  CIOResult+Mock.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

public extension CIOResult {

    class func mock(withValue value: String, group: CIOGroup? = nil) -> CIOResult {
        let json: [String: Any] = TestResource.load(name: TestResource.Response.singleResultJSONFilename).toJSONDictionary()!
        return CIOResult(autocompleteResult: CIOAutocompleteResult(json: json)!, group: group)
    }

}
