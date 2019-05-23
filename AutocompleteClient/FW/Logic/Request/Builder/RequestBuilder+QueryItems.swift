//
//  RequestBuilder+QueryItems.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension RequestBuilder {

    public func addTriggerQueryItem() {
        queryItems.add(URLQueryItem(name: Constants.Track.trigger, value: Constants.Track.triggerType))
    }

    public func set(originalQuery: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.originalQuery, value: originalQuery))
    }

    public func set(groupName: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.groupName, value: groupName))
    }

    public func set(groupID: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.groupID, value: groupID))
    }

    public func set(searchTerm: String) {
        queryItems.add(URLQueryItem(name: Constants.Track.searchTerm, value: searchTerm))
    }

    public func set(name: String?) {
        guard let name = name else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.name, value: name))
    }

    public func set(customerID: String?) {
        guard let customerID = customerID else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.customerID, value: customerID))
    }

    public func set(customerIDs: [String]?) {
        guard let customerIDs = customerIDs else { return }
        for (index, customerID) in customerIDs.enumerated() {
            queryItems.addMultiple(index: index, item: URLQueryItem(name: Constants.Track.customerIDs, value: customerID))
        }
    }

    public func set(autocompleteSection: String?) {
        guard let sectionName = autocompleteSection else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.autocompleteSection, value: sectionName))
    }

    public func set(searchSection: String) {
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.section, value: searchSection))
    }

    public func set(revenue: Double?) {
        guard let revenue = revenue else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.revenue, value: String(format: "%.2lf", revenue)))
    }

    public func set(numResults: Int?) {
        guard let numResults = numResults else { return }
        queryItems.add(URLQueryItem(name: Constants.AutocompleteQuery.numResults, value: String(numResults)))
    }

    public func set(numResultsForSection: [String: Int]?) {
        guard let numResultsForSection = numResultsForSection else { return }
        numResultsForSection.forEach {
            let name = Constants.AutocompleteQuery.queryItemForSection($0.key.replacingOccurrences(of: " ", with: "+"))
            queryItems.add(URLQueryItem(name: name, value: String($0.value)))
        }
    }

    public func set(page: Int) {
        let pageString = String(page)
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.page, value: pageString))
    }

    public func set(groupFilter: String?) {
        guard let filter = groupFilter else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.groupFilter, value: filter))
    }

    public func set(facetFilters: [Filter]?) {
        guard let filters = facetFilters else { return }
        for filter in filters {
            self.set(facetFilter: filter)
        }
    }

    public func set(facetFilter: Filter?) {
        guard let filter = facetFilter else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.facetFilterKey(filter.key), value: filter.value))
    }

    public func set(sortOption: SortOption?) {
        guard let option = sortOption else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.sortBy, value: option.sortBy))
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.sortOrder, value: option.sortOrder.rawValue))
    }

    public func set(_ value: String, forKey key: String) {
        queryItems.add(URLQueryItem(name: key, value: value))
    }

    public func set(testCellKey: String, testCellValue: String) {
        let formattedKey = String(format: Constants.ABTesting.keyFormat, testCellKey)
        queryItems.add(URLQueryItem(name: formattedKey, value: testCellValue))
    }
}
