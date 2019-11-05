//
//  FiltersDelegate.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete

protocol FiltersSelectionDelegate: AnyObject{
    func didSelect(filters: [Filter])
}
