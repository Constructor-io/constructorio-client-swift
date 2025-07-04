//
//  RequestBuilder+QueryItems.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
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
        queryItems.add(URLQueryItem(name: Constants.Track.customerIDs, value: customerIDs.prefix(60).joined(separator: ",")))
    }

    func set(variationID: String?) {
        guard let variationID = variationID else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.variationID, value: variationID))
    }

    func set(resultID: String?) {
        guard let resultID = resultID else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.resultID, value: resultID))
    }

    func set(autocompleteSection: String?) {
        guard let sectionName = autocompleteSection else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.autocompleteSection, value: sectionName))
    }

    func set(type: String?) {
        guard let conversionType = type else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.conversionType, value: conversionType))
    }

    func set(searchSection: String) {
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.section, value: searchSection))
    }

    func set(section: String) {
        queryItems.add(URLQueryItem(name: Constants.Query.section, value: section))
    }

    func set(revenue: Double?) {
        guard let revenue = revenue else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.revenue, value: String(format: "%.2lf", revenue)))
    }

    func set(orderID: String?) {
        guard let orderID = orderID else { return }
        queryItems.add(URLQueryItem(name: Constants.Track.orderID, value: orderID))
    }

    func set(numResults: Int?) {
        guard let numResults = numResults else { return }
        queryItems.add(URLQueryItem(name: Constants.AutocompleteQuery.numResults, value: String(numResults)))
    }

    func set(numResultsForSection: [String: Int]?) {
        guard let numResultsForSection = numResultsForSection else { return }
        numResultsForSection.forEach {
            let name = Constants.AutocompleteQuery.queryItemForSection($0.key)
            queryItems.add(URLQueryItem(name: name, value: String($0.value)))
        }
    }

    func set(page: Int) {
        let pageString = String(page)
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.page, value: pageString))
    }

    func set(offset: Int) {
        let offsetString = String(offset)
        queryItems.add(URLQueryItem(name: Constants.BrowseFacetsQuery.offset, value: offsetString))
    }

    func set(perPage: Int) {
        let perPageString = String(perPage)
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.perPage, value: perPageString))
    }

    func set(groupFilter: String?) {
        guard let filter = groupFilter else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.groupFilter, value: filter))
    }

    func set(facetFilters: [Filter]?) {
        guard let filters = facetFilters else { return }
        for filter in filters {
            self.set(facetFilter: filter)
        }
    }
    
    func set(sectionFacetFilters: [Filter]?, sectionName: String) {
        guard let filters = sectionFacetFilters else { return }
        
        for filter in filters {
            queryItems.add(URLQueryItem(name: Constants.AutocompleteQuery.sectionFilterKey(sectionName,filter.key), value: filter.value))
        }
    }
    
    func set(sectionFilters: [String: CIOQueryFilters]?) {
        guard let filters = sectionFilters else { return }
        
        filters.forEach {
            self.set(sectionFacetFilters: $0.value.facetFilters, sectionName: $0.key)

            guard let groupFilter = $0.value.groupFilter else { return }
            queryItems.add(URLQueryItem(name: Constants.AutocompleteQuery.sectionFilterKey($0.key, "group_id"), value: groupFilter))
        }
    }

    func set(facetFilter: Filter?) {
        guard let filter = facetFilter else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.facetFilterKey(filter.key), value: filter.value))
    }

    func set(sortOption: CIOSortOption?) {
        guard let option = sortOption else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.sortBy, value: option.sortBy))
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.sortOrder, value: option.sortOrder.rawValue))
    }

    func set(_ value: String, forKey key: String) {
        queryItems.add(URLQueryItem(name: key, value: value))
    }

    func set(itemID: String?) {
        guard let itemID = itemID else { return }
        let itemIDString = String(itemID)
        queryItems.add(URLQueryItem(name: Constants.RecommendationsQuery.itemID, value: itemIDString))
    }

    func set(term: String?) {
        guard let term = term else { return }
        let termString = String(term)
        queryItems.add(URLQueryItem(name: Constants.RecommendationsQuery.term, value: termString))
    }

    func set(hiddenFields: [String]?) {
        guard let hiddenFields = hiddenFields else { return }
        for hiddenField in hiddenFields {
            self.set(hiddenField: hiddenField)
        }
    }

    func set(hiddenField: String?) {
        guard let hiddenField = hiddenField else { return }
        self.set(fmtOption: (key: "hidden_fields", value: hiddenField))
    }

    func set(hiddenFacets: [String]?) {
        guard let hiddenFacets = hiddenFacets else { return }
        for hiddenFacet in hiddenFacets {
            self.set(hiddenFacet: hiddenFacet)
        }
    }

    func set(hiddenFacet: String?) {
        guard let hiddenFacet = hiddenFacet else { return }
        self.set(fmtOption: (key: "hidden_facets", value: hiddenFacet))
    }

    func set(showHiddenFacets: Bool) {
        let showHiddenFacetsString = String(showHiddenFacets)
        queryItems.add(URLQueryItem(name: Constants.BrowseFacetsQuery.showHiddenFacets, value: showHiddenFacetsString))
    }

    func set(facetName: String?) {
        guard let facetName = facetName else { return }
        let facetNameString = String(facetName)
        queryItems.add(URLQueryItem(name: Constants.BrowseFacetOptionsQuery.facetName, value: facetNameString))
    }

    func set(fmtOptions: [FmtOption]?) {
        guard let options = fmtOptions else { return }
        for option in options {
            self.set(fmtOption: option)
        }
    }

    func set(fmtOption: FmtOption?) {
        guard let option = fmtOption else { return }
        queryItems.add(URLQueryItem(name: Constants.SearchQuery.fmtOptionsKey(option.key), value: option.value))
    }

    func set(variationsMap: CIOQueryVariationsMap?) {
        guard let variationsMap = variationsMap else { return }
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .sortedKeys
            let jsonData = try jsonEncoder.encode(variationsMap)
            var jsonString = String(data: jsonData, encoding: .utf8)!
            if let filterByJsonStr = variationsMap.FilterByJsonStr {
                let regex = try NSRegularExpression(pattern: "\\}$")
                let range = NSRange(location: 0, length: jsonString.count)
                jsonString = regex.stringByReplacingMatches(in: jsonString, range: range, withTemplate: ",\"filter_by\":\(filterByJsonStr)}")
            }
            queryItems.add(URLQueryItem(name: "variations_map", value: jsonString))
        } catch {
            // Do nothing
        }
    }

    func set(preFilterExpression: String?) {
        guard let preFilterExpression = preFilterExpression else { return }
        queryItems.add(URLQueryItem(name: "pre_filter_expression", value: preFilterExpression))
    }

    func set(groupsSortOption: CIOGroupsSortOption?) {
        guard let option = groupsSortOption else { return }
        self.set(fmtOption: (key: "groups_sort_by", value: option.sortBy.rawValue))
        self.set(fmtOption: (key: "groups_sort_order", value: option.sortOrder.rawValue))
    }

    func set(ids: [String]?) {
        guard let itemIds = ids else { return }
        for itemId in itemIds {
            self.set(id: itemId)
        }
    }

    func set(id: String?) {
        guard let itemId = id else { return }
        queryItems.add(URLQueryItem(name: "ids", value: itemId))
    }

    func set(answer: [String]?) {
        guard let answer = answer else { return }
        queryItems.add(URLQueryItem(name: Constants.Quiz.answers, value: answer.joined(separator: ",")))
    }

    func set(answers: [[String]]?) {
        guard let answers = answers else { return }
        for answer in answers {
            self.set(answer: answer)
        }
    }

    func set(quizVersionID: String?) {
        guard let quizVersionID = quizVersionID else { return }
        queryItems.add(URLQueryItem(name: Constants.Quiz.quizVersionID, value: quizVersionID))
    }

    func set(quizSessionID: String?) {
        guard let quizSessionID = quizSessionID else { return }
        queryItems.add(URLQueryItem(name: Constants.Quiz.quizSessionID, value: quizSessionID))
    }

    func set(slCampaignID: String?) {
        guard let campaignID = slCampaignID else { return }
        queryItems.add(URLQueryItem(name: "sl_campaign_id", value: campaignID))
    }

    func set(slCampaignOwner: String?) {
        guard let owner = slCampaignOwner else { return }
        queryItems.add(URLQueryItem(name: "sl_campaign_owner", value: owner))
    }
}
