//
//  RequestBuilder+QueryItems.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension RequestBuilder{
    
    func addTriggerQueryItem() {
        queryItems.add(URLQueryItem(name: Constants.TrackAutocompleteResultClicked.trigger, value: Constants.TrackAutocompleteResultClicked.triggerType))
    }
    
    func set(originalQuery: String) {
        queryItems.add(URLQueryItem(name: Constants.TrackAutocompleteResultClicked.originalQuery, value: originalQuery))
    }
    
    func set(groupName: String){
        queryItems.add(URLQueryItem(name: Constants.TrackAutocompleteResultClicked.groupName, value: groupName))
    }
    
    func set(groupID: String){
        queryItems.add(URLQueryItem(name: Constants.TrackAutocompleteResultClicked.groupID, value: groupID))
    }
    
    func set(action: String){
        self.queryItems.add(URLQueryItem(name: Constants.TrackAutocomplete.action, value: action))
    }
    
    func set(searchTerm: String) {
        queryItems.add(URLQueryItem(name: Constants.TrackAutocomplete.searchTerm, value: searchTerm))
    }
    
    func set(itemID: String?) {
        guard let itemID = itemID else { return }
        queryItems.add(URLQueryItem(name: Constants.TrackConversion.itemId, value: itemID))
    }
    
    func set(itemName: String?) {
        guard let itemName = itemName else { return }
        queryItems.add(URLQueryItem(name: Constants.TrackConversion.item, value: itemName))
    }
    
    func set(autocompleteSection: String?) {
        guard let sectionName = autocompleteSection else { return }
        queryItems.add(URLQueryItem(name: Constants.TrackAutocomplete.autocompleteSection, value: sectionName))
    }
    
    func set(revenue: Int?) {
        guard let revenue = revenue else { return }
        queryItems.add(URLQueryItem(name: Constants.TrackConversion.revenue, value: String(revenue)))
    }
    
    func set(numResults: Int?) {
        guard let numResults = numResults else { return }
        queryItems.add(URLQueryItem(name: Constants.AutocompleteQuery.numResults, value: String(numResults)))
    }
    
    func set(numResultsForSection: [String: Int]?) {
        guard let numResultsForSection = numResultsForSection else { return }
        numResultsForSection.forEach {
            let name = Constants.AutocompleteQuery.queryItemForSection($0.key.replacingOccurrences(of: " ", with: "+"))
            queryItems.add(URLQueryItem(name: name, value: String($0.value)))
        }
    }
    
    func set(numResultsPerPage: Int?) {
        guard let numResults = numResultsPerPage else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.numResultsPerPage, value: String(numResults)))
    }
        
    func set(page: Int){
        let pageString = String(page)
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.page, value: pageString))
    }
    
    func set(groupFilter: String?){
        guard let filter = groupFilter else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.groupFilter, value: filter))
    }
    
    func set(facetFilters: [Filter]?){
        guard let filters = facetFilters else { return }
        for filter in filters{
            self.set(facetFilter: filter)
        }
    }
    
    func set(facetFilter: Filter?){
        guard let filter = facetFilter else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.facetFilterKey(filter.key), value: filter.value))
    }
    
    func set(_ value: String, forKey key: String){
        queryItems.add(URLQueryItem(name: key, value: value))
    }
}
