//
//  SearchResultFacet.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
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
