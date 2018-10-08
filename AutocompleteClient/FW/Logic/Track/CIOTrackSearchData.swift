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
//<<<<<<< HEAD
//        requestBuilder.set(searchTerm: self.searchTerm)
//=======
        requestBuilder.set(originalQuery: self.searchTerm)
//>>>>>>> 9629388ab390297b07e997cc8e4a18eb93aba86b
        requestBuilder.set(itemName: self.itemName)
    }
}
