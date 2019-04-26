//
//  CurrentTimeDateProvider.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CurrentTimeDateProvider: DateProvider {

    public init() {}

    public func provideDate() -> Date {
        return Date()
    }
}
