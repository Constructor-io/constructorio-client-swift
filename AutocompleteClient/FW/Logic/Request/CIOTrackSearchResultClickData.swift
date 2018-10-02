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
    public let itemID: String
    public var sectionName: String?
    
    public var url: String {
        return String(format: Constants.TrackSearchClickThrough.format, Constants.Track.baseURLString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }
    
    public init(searchTerm: String, itemID: String, sectionName: String? = nil) {
        self.searchTerm = searchTerm
        self.itemID = itemID
        self.sectionName = sectionName
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder){
        requestBuilder.set(itemID: self.itemID)
        requestBuilder.set(autocompleteSection: self.sectionName)
    }
}