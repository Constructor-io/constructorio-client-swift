//
//  CIORecommendationsStrategy.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIORecommendationsStrategy {
    public let id: String
}

public extension CIORecommendationsStrategy {
    init?(json: JSONObject) {
        guard let id = json["id"] as? String else { return nil }

        self.id = id
    }
}
