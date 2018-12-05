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

struct SearchResultViewModel{

    let title: String
    let price: String
    let imageURL: String
    let description: String
    let fallbackImage: () -> UIImage

    init(searchResult: SearchResult){
        self.title = searchResult.value
        self.price = searchResult.price ?? "/"
        self.imageURL = searchResult.imageURL ?? ""
        self.fallbackImage = { return UIImage(named: "icon_logo")! }

        let data = searchResult.rawJSON["data"] as? JSONObject
        self.description = (data?["description"] as? String) ?? ""
    }
}
