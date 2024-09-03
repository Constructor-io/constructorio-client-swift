//
//  SearchResultViewModel.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete
import UIKit

public struct SearchResultViewModel{

    public let title: String
    public let price: Double
    public let priceString: String
    public let imageURL: String
    public let description: String
    public let fallbackImage: () -> UIImage

    public init(searchResult: CIOResult){
        self.title = searchResult.value
        self.price = searchResult.data.metadata["price"] as? Double ?? 0.00
        self.imageURL = searchResult.data.imageURL ?? ""
        self.fallbackImage = { return UIImage(named: "icon_logo")! }

        self.description = searchResult.data.metadata["description"] as? String ?? ""
        self.priceString = "$\(self.price)"
    }
}
