//
//  FacetOptonViewModel.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/12/19.
//  Copyright © 2019 xd. All rights reserved.
//

import Foundation
import ConstructorAutocomplete

struct FacetOptionViewModel{
    let value: String
    let title: String
    var selected: Bool
}

extension FacetOptionViewModel{
    init(option: FacetOption){
        self.init(value: option.value, title: option.displayName, selected: false)
    }
}
