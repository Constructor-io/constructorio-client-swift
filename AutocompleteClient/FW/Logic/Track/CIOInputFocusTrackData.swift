//
//  CIOInputFocusTrackData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public struct CIOInputFocusTrackData{
    let searchTerm: String?
    
    init(searchTerm: String?){
        self.searchTerm = searchTerm
    }
}
