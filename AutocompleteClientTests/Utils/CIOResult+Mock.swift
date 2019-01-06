//
//  CIOResult+Mock.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/6/19.
//  Copyright © 2019 xd. All rights reserved.
//

import Foundation
import ConstructorAutocomplete

public extension CIOResult{

    public class func mock(withValue value: String, group: CIOGroup? = nil) -> CIOResult {
        let json: [String: Any] = TestResource.load(name: TestResource.Response.singleResultJSONFilename).toJSONDictionary()!
        return CIOResult(autocompleteResult: CIOAutocompleteResult(json: json)!, group: group)
    }
    
}
