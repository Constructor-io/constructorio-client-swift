//
//  SearchVariation.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

struct SearchVariation {
    let id: String
    let value: String
    let url: URL?
    let imageURL: URL?
    let data: [String: Any]
}

extension SearchVariation {
    init?(json: JSONObject) {
        guard let value = json["value"] as? String else { return nil }
        guard let data = json["data"] as? [String: Any] else { return nil }
        guard let id = data["variation_id"] as? String else { return nil }

        var url: URL?
        if let urlString = data["url"] as? String {
            url = URL(string: urlString)
        }

        var imageURL: URL?
        if let imageURLString = data["image_url"] as? String {
            imageURL = URL(string: imageURLString)
        }

        self.id = id
        self.value = value
        self.url = url
        self.imageURL = imageURL
        self.data = data
    }
}
