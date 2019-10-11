//
//  SearchVariation.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct SearchVariation {
    let value: String
    let data: SearchVariationData
}

extension SearchVariation {
    init?(json: JSONObject) {
        guard let value = json["value"] as? String else { return nil }
        guard let dataObj = json["data"] as? [String: Any] else { return nil }
        guard let data = SearchVariationData(json: dataObj) else { return nil }

        self.value = value
        self.data = data
    }
}
