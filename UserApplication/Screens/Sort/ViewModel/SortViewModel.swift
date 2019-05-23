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
    var selectedItem: SortOptionViewModel?{
        get{
            return self.items.first(where: { $0.selected })
        }
    }
    var changed: Bool

    weak var delegate: SortSelectionDelegate?

    init(items: [SortOptionViewModel]){
        self.items = items
        self.changed = false
    }

    func toggle(indexPath: IndexPath){
        self.changed = true
        for idx in 0..<self.items.count{
            self.items[idx].selected = (idx == indexPath.row)
        }
    }

    func dismiss(){
        if self.changed{
            self.delegate?.didSelect(sortOption: self.selectedItem?.model)
        }
    }
}
