//
//  SearchResultData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct SearchResultData{
    let id: String
    let url: String?
    let quantity: String?
    let imageURL: String?
    let metadata: [String: Any]
    let facets: [SearchResultFacet]?
    let groups: [CIOGroup]?
}

extension SearchResultData{
    init?(json: JSONObject){
        guard let id = json["id"] as? String else { return nil }
        self.id = id

        self.facets = (json["facets"] as? [JSONObject])?.flatMap{ searchFacetObj in
            return SearchResultFacet(json: searchFacetObj)
        }

        self.groups = (json["groups"] as? [JSONObject])?.flatMap({ groupObj in
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
