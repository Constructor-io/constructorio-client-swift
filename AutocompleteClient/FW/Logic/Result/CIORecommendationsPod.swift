//
//  CIORecommendationsPod.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIORecommendationsPod {
    public let displayName: String
    public let id: String
}

public extension CIORecommendationsPod {
    init?(json: JSONObject) {
        guard let displayName = json["display_name"] as? String else { return nil }
        guard let id = json["id"] as? String else { return nil }

        self.displayName = displayName
        self.id = id
    }
}
