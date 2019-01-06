//
//  CIOGroup+Mock.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/6/19.
//  Copyright © 2019 xd. All rights reserved.
//

import Foundation
import ConstructorAutocomplete

public extension CIOGroup{
    public class func mock(withName name: String? = nil) -> CIOGroup{
        let naem = name ?? "group"
        return CIOGroup(displayName: naem, groupID: naem, path: "path/to/group")
    }
}
