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
public struct CIOTrackSearchResultClickData: CIORequestData {
    public let searchTerm: String
    public let itemName: String
    public let customerID: String
    public var sectionName: String?
    
    public var url: String {
        return String(format: Constants.TrackSearchResultClick.format, Constants.Track.baseURLString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }
    
    public init(searchTerm: String, itemName: String, customerID: String, sectionName: String? = nil) {
        self.searchTerm = searchTerm
        self.itemName = itemName
        self.customerID = customerID
        self.sectionName = sectionName
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder){
        requestBuilder.set(name: self.itemName)
        requestBuilder.set(customerID: self.customerID)
        requestBuilder.set(autocompleteSection: self.sectionName)
    }
}
