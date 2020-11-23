//
//  UIImage+Sort.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
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

    class func imageForSortOrder(_ sortOrder: CIOSortOrder) -> UIImage{
        switch sortOrder {
        case .ascending:
            return self.imageSortAscending()
        case .descending:
            return self.imageSortDescending()
        }
    }
}
