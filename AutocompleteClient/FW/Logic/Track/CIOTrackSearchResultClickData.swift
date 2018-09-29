//
//  CIOTrackSearchData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public struct CIOTrackSearchResultClickData: CIORequestData {
    let searchTerm: String
    let itemID: String
    
    public var url: String {
        return String(format: Constants.TrackSearch.format, Constants.Track.baseURLString, self.itemID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder){
        requestBuilder.set(searchTerm: self.searchTerm)
        requestBuilder.set(itemID: self.itemID)
    }
}
