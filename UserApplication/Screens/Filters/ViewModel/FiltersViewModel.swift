//
//  FiltersViewModel.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class FiltersViewModel {
    let filters: [FacetViewModel]
    var changed: Bool = false
    weak var delegate: FiltersSelectionDelegate?

    var selectedFilters: [Filter]{
        return self.filters.reduce([Filter]()) { res, next in
            return res + next.options.filter{ $0.selected }
                .map({ return (key: next.title, value: $0.value) as Filter })
        }
    }

    init(filters: [FacetViewModel]){
        self.filters = filters
    }

    func toggle(indexPath: IndexPath){
        self.changed = true
        self.filters[indexPath.section].options[indexPath.row].selected.toggle()
    }

    func dismiss(){
        if self.changed{
            self.delegate?.didSelect(filters: self.selectedFilters)
        }
    }
}
