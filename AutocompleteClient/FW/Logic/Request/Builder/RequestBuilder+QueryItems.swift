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
        queryItems.add(URLQueryItem(name: Constants.Track.trigger, value: Constants.Track.triggerType))
    }
    
    func set(originalQuery: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.originalQuery, value: originalQuery))
    }
    
    func set(groupName: String){
        queryItems.add(URLQueryItem(name: Constants.Track.groupName, value: groupName))
    }
    
    func set(groupID: String){
        queryItems.add(URLQueryItem(name: Constants.Track.groupID, value: groupID))
    }
    
    func set(searchTerm: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.searchTerm, value: searchTerm))
    }
    
    func set(itemID: String?) {
        guard let itemID = itemID else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.itemId, value: itemID))
    }

    func set(autocompleteSection: String?) {
        guard let sectionName = autocompleteSection else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.autocompleteSection, value: sectionName))
    }
    
    func set(revenue: Int?) {
        guard let revenue = revenue else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.revenue, value: String(revenue)))
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
}
