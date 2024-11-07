//
//  CIOResultData.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a result data object with additional information about the result
 */
public struct CIOResultData {
    /**
     Description associated with the result item
     */
    public let description: String?

    /**
     Result Item ID
     */
    public let id: String?

    /**
     URL of the result item
     */
    public let url: String?

    /**
     Image URL of the result item
     */
    public let imageURL: String?

    /**
     Groups associated with the result item
     */
    public let groups: [CIOGroup]

    /**
     Facets associated with the result item
     */
    public let facets: [CIOResultFacet]

    /**
     Additioanl metadata associated with the result item
     */
    public let metadata: [String: Any]

    /**
     Variation ID of the result item (if available)
     */
    public let variationId: String?
}

public extension CIOResultData {
    /**
     Create a result data object
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        var metadata = json
        for key in ["description", "id", "url", "image_url", "groups", "facets", "variation_id" ] {
            metadata.removeValue(forKey: key)
        }

        let groupsObj = json["groups"] as? [JSONObject]
        let facetsObj = json["facets"] as? [JSONObject]

        let groups: [CIOGroup] = groupsObj?.compactMap { obj in return CIOGroup(json: obj) } ?? []
        let facets: [CIOResultFacet] = facetsObj?.compactMap { obj in return CIOResultFacet(json: obj) } ?? []

        self.description = json["description"] as? String
        self.id = json["id"] as? String
        self.url = json["url"] as? String
        self.imageURL = json["image_url"] as? String
        self.groups = groups
        self.facets = facets
        self.variationId = json["variation_id"] as? String
        self.metadata = metadata
    }
}
