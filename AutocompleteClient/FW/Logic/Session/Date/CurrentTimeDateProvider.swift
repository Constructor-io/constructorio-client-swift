//
//  CurrentTimeDateProvider.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct CurrentTimeDateProvider: DateProvider {

    init() {}

    func provideDate() -> Date {
        return Date()
    }
}
