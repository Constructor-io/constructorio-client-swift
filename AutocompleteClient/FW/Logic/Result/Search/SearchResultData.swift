//
//  SearchResultData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct SearchResultData {
    public let id: String
    public let url: String?
    public let quantity: String?
    public let imageURL: String?
    public let metadata: [String: Any]
    public let facets: [SearchResultFacet]?
    public let groups: [CIOGroup]?
}

public extension SearchResultData {
    public init?(json: JSONObject) {
        guard let id = json["id"] as? String else { return nil }
        self.id = id

        self.facets = (json["facets"] as? [JSONObject])?.compactMap { searchFacetObj in
            return SearchResultFacet(json: searchFacetObj)
        }

        self.groups = (json["groups"] as? [JSONObject])?.compactMap({ groupObj in
            return CIOGroup(json: groupObj)
        })

        self.imageURL = json["image_url"] as? String
        self.quantity = json["quantity"] as? String
        self.url = json["url"] as? String

        var metadata = json
        for key in [ "id", "facets", "groups", "image_url", "quantity", "url" ]{
            metadata.removeValue(forKey: key)
        }
        self.metadata = metadata
    }
}
