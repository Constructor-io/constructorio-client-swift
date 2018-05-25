//
//  TrackAutocompleteClickRequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class TrackAutocompleteClickRequestBuilder: RequestBuilder {

    private var itemName = ""
    private var hasSectionName = false

    init(tracker: CIOAutocompleteClickTrackData, autocompleteKey: String) {
        super.init(autocompleteKey: autocompleteKey)
        set(itemName: tracker.clickedItemName)
        set(originalQuery: tracker.searchTerm)
        set(autocompleteSection: tracker.sectionName)
        if let group = tracker.group{
            set(groupName: group.displayName)
            set(groupID: group.groupID)
        }
        
    }

    func set(itemName: String) {
        self.itemName = itemName
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
    
    func set(autocompleteSection: String?) {
        guard let sectionName = autocompleteSection else { return }
        self.hasSectionName = true
        queryItems.add(URLQueryItem(name: Constants.TrackAutocomplete.autocompleteSection, value: sectionName))
    }

    override func getURLString() -> String {
        let type = hasSectionName
                 ? Constants.TrackAutocompleteResultClicked.selectType
                 : Constants.TrackAutocompleteResultClicked.searchType

        return String(format: Constants.Track.trackStringFormat, Constants.Track.baseURLString, Constants.TrackAutocomplete.pathString, itemName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!, type)
    }

    override func addAdditionalQueryItems() {
        addTriggerQueryItem()
        addDateQueryItem()
    }

    private func addTriggerQueryItem() {
        queryItems.add(URLQueryItem(name: Constants.TrackAutocompleteResultClicked.trigger, value: Constants.TrackAutocompleteResultClicked.triggerType))
    }

    private func addDateQueryItem() {
        queryItems.add(URLQueryItem(name: Constants.TrackAutocompleteResultClicked.dateTime, value: String(Date().millisecondsSince1970)))
    }

}
