//
//  CIOSearchResultsLoadedTrackData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOSearchResultsLoadedTrackData{
    let searchTerm: String
    let resultCount: Int
    
    public init(searchTerm: String, resultCount: Int){
        self.searchTerm = searchTerm
        self.resultCount = resultCount
    }
}
