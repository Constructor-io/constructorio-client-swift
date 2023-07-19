//
//  CIOFilterFacet.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a filter facet with information about the type and options.
 */
public struct CIOFilterFacet {
    /**
     Display name of the facet
     */
    public let displayName: String

    /**
     The name (or value) of the facet
     */
    public let name: String

    /**
     The max possible value for the facet (if it's of type range)
     */
    public let max: Int

    /**
     The minimum possible value for the facet (if it's of type range)
     */
    public let min: Int

    /**
     List of facet options
     */
    public let options: [CIOFilterFacetOption]

    /**
     The type of the facet (i.e. range or multiple)
     */
    public let type: String

    /**
     Whether the facet is hidden or not  (i.e. true or false)
     */
    public let hidden: Bool

    /**
     Additional metadata for the facet option
     */
    public let data: [String: Any]

}

public extension CIOFilterFacet {
    /**
     Create a filter facet object
     
     - Parameters
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        guard let displayName = json["display_name"] as? String else { return nil }
        guard let name = json["name"] as? String else { return nil }
        guard let type = json["type"] as? String else { return nil }
        guard let hidden = json["hidden"] as? Bool else { return nil }

        let data = json["data"] as? [String: Any] ?? [:]
        let min = json["min"] as? Int
        let max = json["max"] as? Int
        let optionsObj = json["options"] as? [JSONObject]

        let options: [CIOFilterFacetOption] = optionsObj?.compactMap { obj in return CIOFilterFacetOption(json: obj) } ?? []

        self.displayName = displayName
        self.name = name
        self.min = (min != nil) ? min! : 0
        self.max = (max != nil) ? max! : 0
        self.options = options
        self.type = type
        self.hidden = hidden
        self.data = data
    }
}
