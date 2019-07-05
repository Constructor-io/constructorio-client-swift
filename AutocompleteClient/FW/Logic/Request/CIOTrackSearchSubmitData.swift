//
//  CIOTrackSearchSubmitData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a search submission
 */
struct CIOTrackSearchSubmitData: CIORequestData {

    let searchTerm: String
    let originalQuery: String
    let group: CIOGroup?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackSearchSubmit.format, baseURL, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }

    init(searchTerm: String, originalQuery: String, group: CIOGroup? = nil) {
        self.searchTerm = searchTerm
        self.originalQuery = originalQuery
        self.group = group
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(originalQuery: self.originalQuery)
        if let group = self.group {
            requestBuilder.set(groupName: group.displayName)
            requestBuilder.set(groupID: group.groupID)
        }
    }
}
