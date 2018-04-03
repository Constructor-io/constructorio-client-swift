//
//  ClosureDateProvider.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 3/12/18.
//  Copyright © 2018 xd. All rights reserved.
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
