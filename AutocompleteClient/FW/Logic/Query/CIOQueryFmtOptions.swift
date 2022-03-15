//
//  CIOQueryFmtOptions.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias FmtOptions = (key: String, value: String)

public struct CIOQueryFmtOptions {
    public let fmtOptions: [FmtOptions]?

    public init(fmtOptions: [FmtOptions]?) {
        self.fmtOptions = fmtOptions;
    }
}
