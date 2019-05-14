//
//  SortOptionViewModel.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/14/19.
//  Copyright © 2019 xd. All rights reserved.
//

import Foundation
import UIKit
import ConstructorAutocomplete

struct SortOptionViewModel{
    var model: SortOption

    let displayName: String
    let image: UIImage?
    var selected: Bool

    init(option: SortOption){
        self.model = option
        self.displayName = option.displayName
        self.image = UIImage.imageForSortOrder(option.sortOrder)
        self.selected = false
    }
}
