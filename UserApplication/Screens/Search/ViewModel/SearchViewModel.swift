//
//  SearchViewModel.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete
import CoreGraphics

class SearchViewModel: ConstructorIOProvider{

    let title: String

    let searchTerm: String
    let groupID: String?
    let groupName: String?

    let constructor: ConstructorIO

    var searchResults: [SearchResultViewModel]?
    var filtersViewModel: FiltersViewModel?
    let margin: CGFloat = 8
    let cellAspectRatio: CGFloat = 1.44

    let cart: Cart

    var selectedFilters: [Filter]?

    init(term: String, group: CIOGroup?, constructorProvider: ConstructorIOProvider, cart: Cart){
        self.searchTerm = term
        self.groupID = group?.groupID
        self.groupName = group?.displayName
        self.constructor = constructorProvider.provideConstructorInstance()
        self.cart = cart

        if let groupName = groupName{
            self.title = "\(self.searchTerm) in \(groupName)"
        }else{
            self.title = self.searchTerm
        }
    }

    func performSearch(completionHandler: @escaping () -> Void){
        let filter: SearchFilters = SearchFilters(groupFilter: self.groupID, facetFilters: self.selectedFilters)
        let query = CIOSearchQuery(query: self.searchTerm, filters: filter)

        self.constructor.search(forQuery: query) { [weak self] (response) in
            if let data = response.data{
                guard let sself = self else { return }
                sself.searchResults = data.results.map{ result in SearchResultViewModel(searchResult: result) }
                if sself.filtersViewModel == nil {
                    sself.filtersViewModel = FiltersViewModel(filters: data.facets.map(FacetViewModel.init))
                }

                completionHandler()
            }
        }
    }

    func provideConstructorInstance() -> ConstructorIO {
        return self.constructor
    }
}
