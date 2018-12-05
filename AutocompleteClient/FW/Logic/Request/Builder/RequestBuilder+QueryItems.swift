//
//  RequestBuilder+QueryItems.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension RequestBuilder {

    func addTriggerQueryItem() {
        queryItems.add(URLQueryItem(name: Constants.Track.trigger, value: Constants.Track.triggerType))
    }

    func set(originalQuery: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.originalQuery, value: originalQuery))
    }

    func set(groupName: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.groupName, value: groupName))
    }

    func set(groupID: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.groupID, value: groupID))
    }

    func set(searchTerm: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.searchTerm, value: searchTerm))
    }

    func set(name: String?) {
        guard let name = name else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.name, value: name))
    }

    func set(customerID: String?) {
        guard let customerID = customerID else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.customerID, value: customerID))
    }

    func set(customerIDs: [String]?) {
        guard let customerIDs = customerIDs else { return }
        for (index, customerID) in customerIDs.enumerated() {
            queryItems.addMultiple(index: index, item: URLQueryItem(name: Constants.Track.customerIDs, value: customerID))
        }
    }

    func set(autocompleteSection: String?) {
        guard let sectionName = autocompleteSection else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.autocompleteSection, value: sectionName))
    }

    func set(revenue: Double?) {
        guard let revenue = revenue else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.revenue, value: String(format: "%.2lf", revenue)))
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

    func set(testCellKey: String, testCellValue: String) {
        let formattedKey = String(format: Constants.ABTesting.keyFormat, testCellKey)
        queryItems.add(URLQueryItem(name: formattedKey, value: testCellValue))
    }
}
