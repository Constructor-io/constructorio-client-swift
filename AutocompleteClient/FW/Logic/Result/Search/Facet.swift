//
//  Facet.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public struct Facet {
    public let name: String
    public let displayName: String
    public let options: [FacetOption]
    public let type: String
}

public extension Facet {
    public init?(json: JSONObject) {
        guard let name = json["name"] as? String else {
            return nil
        }
        guard let displayName = json["display_name"] as? String else {
            return nil
        }
        guard let type = json["type"] as? String else {
            return nil
        }
        let options: [FacetOption] = (json["options"] as? [JSONObject])?.flatMap { option in
            return FacetOption(json: option)
        } ?? []

        self.name = name
        self.displayName = displayName
        self.type = type
        self.options = options
    }
}
