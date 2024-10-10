//
//  CIOFilterFacetOption.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a filter facet option with information about the status and results associated with it.
 */
public struct CIOFilterFacetOption {
    /**
     The number of results that will be returned when selected
     */
    public let count: Int

    /**
     Display name of the facet option
     */
    public let displayName: String

    /**
     Status of the facet option (i.e. "selected" or "")
     */
    public let status: String

    /**
     The facet value
     */
    public let value: String

    /**
     Additional metadata for the facet option
     */
    public let data: [String: Any]
}

public extension CIOFilterFacetOption {

    /**
     Create a filter facet option
     
     - Parameters:
        - json: JSON data from server response
     */
    init?(json: JSONObject) {
        guard let count = json["count"] as? Int else { return nil }
        guard let displayName = json["display_name"] as? String else { return nil }
        guard let status = json["status"] as? String else { return nil }
        guard let value = json["value"] as? String else { return nil }

        let data = json["data"] as? [String: Any] ?? [:]

        self.count = count
        self.value = value
        self.status = status
        self.displayName = displayName
        self.data = data
    }
}
