//
//  FiltersDelegate.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/12/19.
//  Copyright © 2019 xd. All rights reserved.
//

import Foundation
import ConstructorAutocomplete

protocol FiltersSelectionDelegate: class{
    func didSelectFilters(filters: [Filter])
}
