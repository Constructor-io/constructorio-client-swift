//
//  CurrentTimeDateProvider.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct CurrentTimeDateProvider: DateProvider {

    init() {}

    func provideDate() -> Date {
        return Date()
    }
}
