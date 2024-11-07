//
//  CIOGroup+Mock.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

public extension CIOGroup {
    class func mock(withName name: String? = nil) -> CIOGroup {
        let naem = name ?? "group"
        return CIOGroup(displayName: naem, groupID: naem, path: "path/to/group")
    }
}
