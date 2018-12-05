//
//  CurrentTimeDateProvider.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct CurrentTimeDateProvider: DateProvider {

    func provideDate() -> Date {
        return Date()
    }
}
