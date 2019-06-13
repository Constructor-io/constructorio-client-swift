//
//  CIOTrackSearchResultClickData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track search result click
 */
struct CIOTrackSearchResultClickData: CIORequestData {
    let searchTerm: String
    let itemName: String
    let customerID: String
    var sectionName: String?
    let resultID: String?

    var url: String {
        return String(format: Constants.TrackSearchResultClick.format, Constants.Track.baseURLString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }

    init(searchTerm: String, itemName: String, customerID: String, sectionName: String? = nil, resultID: String? = nil) {
        self.searchTerm = searchTerm
        self.itemName = itemName
        self.customerID = customerID
        self.sectionName = sectionName
        self.resultID = resultID
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(name: self.itemName)
        requestBuilder.set(customerID: self.customerID)
        requestBuilder.set(autocompleteSection: self.sectionName)
        requestBuilder.set(resultID: self.resultID)
    }
}
