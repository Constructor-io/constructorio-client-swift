//
//  CIOTrackSearchData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public struct CIOTrackSearchData: CIORequestData {
    let searchTerm: String
    let itemName: String
    
    public var url: String {
        return String(format: Constants.TrackSearch.format, Constants.Track.baseURLString, self.itemName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder){
        requestBuilder.set(originalQuery: self.searchTerm)
        requestBuilder.set(itemName: self.itemName)
    }
}
