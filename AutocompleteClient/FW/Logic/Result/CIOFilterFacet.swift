//
//  CIOFilterFacet.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
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

    /**
     Status of the facet option (for range type facets)
     - An object with "min" and "max" values, if the facet type is range and the facet is selected
     */
    public let status: (min: String, max: String)?

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
        let min = json["min"] as? Double
        let max = json["max"] as? Double
        let optionsObj = json["options"] as? [JSONObject]

        let options: [CIOFilterFacetOption] = optionsObj?.compactMap { obj in return CIOFilterFacetOption(json: obj) } ?? []

        var status: (min: String, max: String)? = nil
        if let statusDict = json["status"] as? [String: Any],
           !statusDict.isEmpty,
           let rawMin = statusDict["min"],
           let rawMax = statusDict["max"],
           let minStr = (rawMin as? String) ?? (rawMin as? NSNumber)?.stringValue,
           let maxStr = (rawMax as? String) ?? (rawMax as? NSNumber)?.stringValue {
            status = (min: minStr, max: maxStr)
        }

        self.status = status
        self.displayName = displayName
        self.name = name
        self.min = min.map(floor).map(Int.init) ?? 0
        self.max = max.map(ceil).map(Int.init) ?? 0
        self.options = options
        self.type = type
        self.hidden = hidden
        self.data = data
    }
}
