//
//  ClosureDateProvider.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
@testable import ConstructorAutocomplete

class ClosureDateProvider: DateProvider {

    var provideDateClosure: () -> Date
    
    init(provideDateClosure: @escaping () -> Date){
        self.provideDateClosure = provideDateClosure
    }
    
    func provideDate() -> Date {
        return self.provideDateClosure()
    }
}
