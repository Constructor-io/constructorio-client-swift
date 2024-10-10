//
//  FacetOptonViewModel.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete

struct FacetOptionViewModel{
    let value: String
    let title: String
    var selected: Bool
}

extension FacetOptionViewModel{
    init(option: CIOFilterFacetOption){
        self.init(value: option.value, title: option.displayName, selected: false)
    }
}
