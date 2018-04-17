//
//  TrackSearchRequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class TrackSearchRequestBuilder: RequestBuilder {

    let searchItem: String
    
    init(trackData: CIOSearchTrackData, autocompleteKey: String){
        self.searchItem = trackData.itemName
        super.init(autocompleteKey: autocompleteKey)
        
        self.set(originalQuery: trackData.searchTerm)
    }
    
    func set(originalQuery: String) {
        queryItems.append(URLQueryItem(name: Constants.TrackSearch.originalQuery, value: originalQuery))
    }
    
    override func getURLString() -> String {
        return String(format: Constants.TrackSearch.format, Constants.Track.baseURLString, self.searchItem.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }
}