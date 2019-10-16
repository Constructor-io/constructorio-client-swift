//
//  SortSelectionDelegate.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete

protocol SortSelectionDelegate: AnyObject{
    func didSelect(sortOption: SortOption?)
}
