//
//  TrackConversionRequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class TrackConversionRequestBuilder: RequestBuilder {

    init(tracker: CIOConversionTrackData, autocompleteKey: String) {
        super.init(autocompleteKey: autocompleteKey)
        self.searchTerm = tracker.searchTerm
        set(itemID: tracker.itemID)
        set(autocompleteSection: tracker.sectionName)
        set(revenue: tracker.revenue)
    }
    
    
    override func getURLString() -> String {
        return String(format: Constants.Track.trackStringFormat, Constants.Track.baseURLString, Constants.TrackAutocomplete.pathString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!, Constants.TrackConversion.type)
    }

}

extension RequestBuilder{
    
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
}
