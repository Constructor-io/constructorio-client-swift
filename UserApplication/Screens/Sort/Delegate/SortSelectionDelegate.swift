//
//  SortSelectionDelegate.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/22/19.
//  Copyright © 2019 xd. All rights reserved.
//

import Foundation
import ConstructorAutocomplete

protocol SortSelectionDelegate: AnyObject{
    func didSelect(sortOption: SortOption?)
}
