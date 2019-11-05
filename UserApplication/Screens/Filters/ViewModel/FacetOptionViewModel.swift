//
//  FacetOptonViewModel.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
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
    init(option: FacetOption){
        self.init(value: option.value, title: option.displayName, selected: false)
    }
}
