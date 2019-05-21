//
//  Facet.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

struct Facet {
    let name: String
    let displayName: String
    let options: [FacetOption]
    let type: String
}

extension Facet {
    init?(json: JSONObject) {
        guard let name = json["name"] as? String else {
            return nil
        }
        guard let displayName = json["display_name"] as? String else {
            return nil
        }
        guard let type = json["type"] as? String else {
            return nil
        }
        let options: [FacetOption] = (json["options"] as? [JSONObject])?.compactMap { option in
            return FacetOption(json: option)
        } ?? []

        self.name = name
        self.displayName = displayName
        self.type = type
        self.options = options
    }
}
