//
//  SearchResultFacet.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 9/11/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation

struct SearchResultFacet{
    let name: String
    let values: [String]
    
    init?(json: JSONObject){
        guard let name = json["name"] as? String else { return nil }
        
        self.name = name
        self.values = json["values"] as? [String] ?? []
    }
}
