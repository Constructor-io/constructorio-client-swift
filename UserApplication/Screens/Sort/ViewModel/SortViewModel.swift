//
//  SortViewModel.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/14/19.
//  Copyright © 2019 xd. All rights reserved.
//

import Foundation
import ConstructorAutocomplete

class SortViewModel{
    var items: [SortOptionViewModel]
    var selectedItem: SortOptionViewModel?
    var changed: Bool

    weak var delegate: FiltersSelectionDelegate?

    init(items: [SortOptionViewModel]){
        self.items = items
        self.changed = false
        self.selectedItem = nil
    }

    func toggle(indexPath: IndexPath){
        self.changed = true
        for idx in 0..<self.items.count{
            self.items[idx].selected = (idx == indexPath.row)
        }
    }

    func dismiss(){
        if self.changed{
            let selectedSortOption: SortOption? = self.items.filter({ $0.selected }).first?.model
            self.delegate?.didSelect(sortOption: selectedSortOption)
        }
    }
}
