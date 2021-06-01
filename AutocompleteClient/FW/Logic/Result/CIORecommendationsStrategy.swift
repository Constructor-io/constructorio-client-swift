//
//  CIORecommendationsStrategy.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the recommendations strategy
 */
public struct CIORecommendationsStrategy {
    /**
     The id of the strategy
     */
    public let id: String
}

public extension CIORecommendationsStrategy {
    
    /**
     Create a recommendations strategy object
     
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        let id = json["id"] as? String ?? ""

        self.id = id
    }
}
