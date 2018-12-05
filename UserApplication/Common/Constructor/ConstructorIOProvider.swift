//
//  ConstructorIOProvider.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete

protocol ConstructorIOProvider{
    func provideConstructorInstance() -> ConstructorIO
}
