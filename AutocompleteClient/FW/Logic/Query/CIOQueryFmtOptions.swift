//
//  CIOQueryFmtOptions.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias FmtOption = (key: String, value: String)

public struct CIOQueryFmtOptions {
    public let fmtOptions: [FmtOption]?

    public init(fmtOptions: [FmtOption]?) {
        self.fmtOptions = fmtOptions
    }
}
