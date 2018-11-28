//
//  SearchViewModel.swift
//  UserApplication
//
//  Created by Nikola Markovic on 11/27/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation
import ConstructorAutocomplete
import CoreGraphics

class SearchViewModel{

    let title: String

    let searchTerm: String
    let groupName: String?
    let constructor: ConstructorIO

    var searchResults: [SearchResultViewModel]?

    let margin: CGFloat = 8
    let cellAspectRatio: CGFloat = 1.44

    let cart: Cart

    init(term: String, groupName: String?, constructor: ConstructorIO, cart: Cart){
        self.searchTerm = term
        self.groupName = groupName
        self.constructor = constructor
        self.cart = cart

        self.title = self.searchTerm
    }

    func performSearch(completionHandler: @escaping () -> Void){
        var filter: CIOSearchQueryFilters?
        if let groupName = self.groupName{
            filter = CIOSearchQueryFilters(groupFilter: groupName, facetFilters: nil)
        }

        let query = CIOSearchQuery(query: self.searchTerm, filters: filter)

        self.constructor.search(forQuery: query) { (response) in
            if let data = response.data{
                self.searchResults = data.results.map{ result in SearchResultViewModel(searchResult: result) }
                completionHandler()
            }
        }
    }
}
