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
    public let groups: [CIOGroup]?
    public let facets: [CIOResultFacet]?
    public let metadata: [String: Any]
    public let variationId: String?
}

public extension CIOResultData {
    init?(json: JSONObject) {
        var metadata = json
        for key in ["description", "id", "url", "image_url", "groups", "facets", "variation_id" ] {
            metadata.removeValue(forKey: key)
        }

        self.description = json["description"] as? String
        self.id  = json["id"] as? String
        self.url = json["url"] as? String
        self.imageURL = json["image_url"] as? String
        self.groups = (json["groups"] as? [JSONObject])?.compactMap({ groupObj in return CIOGroup(json: groupObj) })
        self.facets = (json["facets"] as? [JSONObject])?.compactMap({ searchFacetObj in return CIOResultFacet(json: searchFacetObj) })
        self.variationId = json["variation_id"] as? String
        self.metadata = metadata
    }
}
