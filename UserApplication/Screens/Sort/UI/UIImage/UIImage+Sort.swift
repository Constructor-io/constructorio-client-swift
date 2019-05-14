//
//  UIImage+Sort.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/14/19.
//  Copyright © 2019 xd. All rights reserved.
//

import Foundation
import ConstructorAutocomplete
import UIKit

extension UIImage{
    class func imageSortAscending() -> UIImage{
        return UIImage(named: "sort_ascending")!
    }

    class func imageSortDescending() -> UIImage{
        return UIImage(named: "sort_descending")!
    }

    class func imageForSortOrder(_ sortOrder: SortOrder) -> UIImage{
        switch sortOrder {
        case .ascending:
            return self.imageSortAscending()
        case .descending:
            return self.imageSortDescending()
        }
    }
}
