//
//  CIOAutocompleteResult+Mock.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

public extension CIOAutocompleteResult {

    class func mock(withValue value: String, group: CIOGroup? = nil) -> CIOAutocompleteResult {
        let json: [String: Any] = TestResource.load(name: TestResource.Response.singleResultJSONFilename).toJSONDictionary()!
        return CIOAutocompleteResult(result: CIOResult(json: json)!, group: group)
    }

}
