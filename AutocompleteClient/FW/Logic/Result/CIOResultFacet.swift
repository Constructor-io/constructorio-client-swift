//
//  CIOResultFacet.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating  a result facet
 */
public struct CIOResultFacet {
    /**
     The name of the facet
     */
    public let name: String

    /**
     List of facet option values
     */
    public let values: [String]

    /**
     Create a result facet
     
     - Parameters:
        - json: JSON data from the server response
     */
    public init?(json: JSONObject) {
        guard let name = json["name"] as? String else { return nil }

        self.name = name
        self.values = json["values"] as? [String] ?? []
    }
}
