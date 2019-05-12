//
//  Facet.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/12/19.
//  Copyright © 2019 xd. All rights reserved.
//

import UIKit
import ConstructorAutocomplete

class FacetViewModel {
    let title: String
    var options: [FacetOptionViewModel]

    convenience init(facet: Facet){
        self.init(filterName: facet.displayName, options: facet.options.map(FacetOptionViewModel.init))
    }

    init(filterName: String, options: [FacetOptionViewModel]){
        self.title = filterName
        self.options = options
    }
}
