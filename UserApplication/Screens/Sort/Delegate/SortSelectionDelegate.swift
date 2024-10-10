//
//  SortSelectionDelegate.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete

protocol SortSelectionDelegate: AnyObject{
    func didSelect(sortOption: CIOSortOption?)
}
