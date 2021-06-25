//
//  CIORecommendationsPod.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a recommendations pod
 */
public struct CIORecommendationsPod {
    public let displayName: String
    public let id: String
}

/**
 Define a recommendations opd
 */
public extension CIORecommendationsPod {
    /**
     Create a recommendations pod
    
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        guard let displayName = json["display_name"] as? String else { return nil }
        guard let id = json["id"] as? String else { return nil }

        self.displayName = displayName
        self.id = id
    }
}
