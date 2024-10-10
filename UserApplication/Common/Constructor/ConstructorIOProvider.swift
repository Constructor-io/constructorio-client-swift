//
//  ConstructorIOProvider.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete

protocol ConstructorIOProvider{
    func provideConstructorInstance() -> ConstructorIO
}
