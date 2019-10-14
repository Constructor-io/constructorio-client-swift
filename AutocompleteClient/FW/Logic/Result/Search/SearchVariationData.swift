//
//  SearchVariation.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct SearchVariationData {
    public let variationId: String
    public let url: String?
    public let imageURL: String?
    public let metadata: [String: Any]
}

public extension SearchVariationData {
    init?(json: JSONObject) {
        guard let variationId = json["variation_id"] as? String else { return nil }
        let url = json["url"] as? String
        let imageURL = json["image_url"] as? String

        self.variationId = variationId
        self.url = url
        self.imageURL = imageURL

        var metadata = json
        for key in [ "variation_id", "url", "image_url" ] {
            metadata.removeValue(forKey: key)
        }
        self.metadata = metadata
    }
}
