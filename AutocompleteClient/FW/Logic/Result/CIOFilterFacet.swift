//
//  CIOFilterFacet.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOFilterFacet {
    public let displayName: String
    public let name: String
    public let max: Int
    public let min: Int
    public let options: [CIOFilterFacetOption]
    public let type: String
}

public extension CIOFilterFacet {
    init?(json: JSONObject) {
        guard let displayName = json["display_name"] as? String else { return nil }
        guard let name = json["name"] as? String else { return nil }
        guard let min = json["min"] as? Int else { return nil }
        guard let max = json["max"] as? Int else { return nil }

        let options: [CIOFilterFacetOption] = (json["options"] as? [JSONObject])?.compactMap { option in
            return CIOFilterFacetOption(json: option)
        } ?? []

        guard let type = json["type"] as? String else { return nil }

        self.displayName = displayName
        self.name = name
        self.min = min
        self.max = max
        self.options = options
        self.type = type
    }
}
