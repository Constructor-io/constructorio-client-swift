//
//  CIOResultData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOResultData {
    public let description: String?
    public let id: String?
    public let url: String?
    public let imageURL: String?
    public let groups: [CIOGroup]
    public let facets: [CIOResultFacet]
    public let metadata: [String: Any]
    public let variationId: String?
}

public extension CIOResultData {
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
