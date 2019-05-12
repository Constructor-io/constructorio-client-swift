//
//  SearchResultFacet.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct SearchResultFacet {
    public let name: String
    public let values: [String]

    public init?(json: JSONObject) {
        guard let name = json["name"] as? String else { return nil }

        self.name = name
        self.values = json["values"] as? [String] ?? []
    }
}
