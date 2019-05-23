//
//  CIOGroup+Mock.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

public extension CIOGroup {
    public class func mock(withName name: String? = nil) -> CIOGroup {
        let naem = name ?? "group"
        return CIOGroup(displayName: naem, groupID: naem, path: "path/to/group")
    }
}
