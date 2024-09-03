//
//  ClosureDateProvider.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import UIKit

class ClosureDateProvider: DateProvider {

    var provideDateClosure: () -> Date

    init(provideDateClosure: @escaping () -> Date) {
        self.provideDateClosure = provideDateClosure
    }

    func provideDate() -> Date {
        return self.provideDateClosure()
    }
}
