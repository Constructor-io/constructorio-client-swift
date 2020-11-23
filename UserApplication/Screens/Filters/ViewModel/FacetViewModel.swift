//
//  Facet.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class FacetViewModel {
    let title: String
    var options: [FacetOptionViewModel]

    convenience init(facet: CIOFilterFacet){
        self.init(filterName: facet.displayName, options: facet.options.map(FacetOptionViewModel.init))
    }

    init(filterName: String, options: [FacetOptionViewModel]){
        self.title = filterName
        self.options = options
    }
}
