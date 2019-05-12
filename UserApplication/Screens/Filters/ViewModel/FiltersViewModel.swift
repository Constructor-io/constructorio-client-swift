//
//  FiltersViewModel.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/12/19.
//  Copyright © 2019 xd. All rights reserved.
//

import UIKit
import ConstructorAutocomplete

class FiltersViewModel {
    let filters: [FacetViewModel]
    var changed: Bool = false
    weak var delegate: FiltersSelectionDelegate?

    init(filters: [FacetViewModel]){
        self.filters = filters
    }

    func toggle(indexPath: IndexPath){
        self.changed = true
        self.filters[indexPath.section].options[indexPath.row].selected.toggle()
    }

    func dismiss(){
        if self.changed{

            let filters: [Filter] = self.filters.reduce([Filter]()) { res, next in
                return res + next.options.filter{ $0.selected }
                                         .map({ return (key: next.title, value: $0.value) as Filter })

            }

            self.delegate?.didSelectFilters(filters: filters)
        }
    }
}
