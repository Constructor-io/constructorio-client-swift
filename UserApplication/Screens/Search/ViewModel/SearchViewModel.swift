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
    var sortViewModel: SortViewModel?

    let margin: CGFloat = 8
    let cellAspectRatio: CGFloat = 1.44

    let cart: Cart
    
    var isLoading: Bool
    var hasMoreDataToLoad: Bool
    var currentPage: Int

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
        
        self.currentPage = 1
        self.isLoading = false
        self.hasMoreDataToLoad = true
    }

    func performSearch(completionHandler: @escaping (_ items: [SearchResultViewModel]) -> Void){
        let filter: CIOQueryFilters = CIOQueryFilters(groupFilter: self.groupID, facetFilters: self.filtersViewModel?.selectedFilters)
        let query = CIOSearchQuery(query: self.searchTerm,
                                 filters: filter,
                              sortOption: self.sortViewModel?.selectedItem?.model,
                                    page: self.currentPage)
        self.isLoading = true
        self.constructor.search(forQuery: query) { [weak self] (response) in
            if let data = response.data{
                guard let sself = self else { return }
                let items = data.results.map{ result in SearchResultViewModel(searchResult: result) }
                
                if items.count > 0{
                    sself.currentPage += 1
                }else{
                    sself.hasMoreDataToLoad = false
                }
                
                if sself.searchResults == nil{
                    sself.searchResults = items
                }else{
                    sself.searchResults?.append(contentsOf: items)
                }
                
                if sself.filtersViewModel == nil {
                    sself.filtersViewModel = FiltersViewModel(filters: data.facets.map(FacetViewModel.init))
                }

                if sself.sortViewModel == nil{
                    sself.sortViewModel = SortViewModel(items: data.sortOptions.map(SortOptionViewModel.init))
                }

                completionHandler(items)
            }else{
                completionHandler([])
            }
            
            self?.isLoading = false
        }
    }

    func provideConstructorInstance() -> ConstructorIO {
        return self.constructor
    }
    
    func invalidate(){
        self.currentPage = 1
        self.hasMoreDataToLoad = true
        self.searchResults = nil
    }
}
