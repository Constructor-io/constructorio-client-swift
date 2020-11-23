//
//  SortOptionViewModel.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit
import ConstructorAutocomplete

struct SortOptionViewModel{
    var model: CIOSortOption

    let displayName: String
    let image: UIImage?
    var selected: Bool

    init(option: CIOSortOption){
        self.model = option
        self.displayName = option.displayName
        self.image = UIImage.imageForSortOrder(option.sortOrder)
        self.selected = false
    }
}
