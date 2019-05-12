//
//  SearchResultViewModel.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete
import UIKit

public struct SearchResultViewModel{

    public let title: String
    public let price: String
    public let imageURL: String
    public let description: String
    public let fallbackImage: () -> UIImage

    public init(searchResult: SearchResult){
        self.title = searchResult.value
        self.price = searchResult.data.metadata["price"] as? String ?? "/"
        self.imageURL = searchResult.data.imageURL ?? ""
        self.fallbackImage = { return UIImage(named: "icon_logo")! }

        self.description = searchResult.data.metadata["description"] as? String ?? ""
    }
}
