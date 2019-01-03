//
//  DateProvider.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol DateProvider {
    func provideDate() -> Date
}
