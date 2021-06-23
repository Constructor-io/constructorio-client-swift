//
//  CIOResult.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a result with associated metadata and variations
 */
@objc
public class CIOResult: NSObject {
    /**
     The value (or name) of the result
     */
    public let value: String

    /**
     Additional data about the result
     */
    public let data: CIOResultData

    /**
     Terms associated with the result that was matched on
     */
    public let matchedTerms: [String]

    /**
     Variations for the result
     */
    public let variations: [CIOResult]

    /**
     Additional metadata
     */
    public let json: JSONObject

    /**
     The underlying recommendations strategy for the result (only applies to recommendations)
     */
    public let strategy: CIORecommendationsStrategy

    /**
     Create a result object
     
     - Parameters:
        - json: JSON data from the server response
     */
    public init?(json: JSONObject) {
        guard let dataObj = json["data"] as? JSONObject else { return nil }
        guard let value = json["value"] as? String else { return nil }
        guard let data = CIOResultData(json: dataObj) else { return nil }

        let matchedTerms = (json["matched_terms"] as? [String]) ?? [String]()
        let variationsObj = json["variations"] as? [JSONObject]

        let variations: [CIOResult] = variationsObj?.compactMap { obj in return CIOResult(json: obj) } ?? []

        let strategyData = json["strategy"] as? JSONObject ?? [String: Any]()

        let strategy: CIORecommendationsStrategy = CIORecommendationsStrategy(json: strategyData)!

        self.value = value
        self.data = data
        self.matchedTerms = matchedTerms
        self.variations = variations
        self.json = json
        self.strategy = strategy
    }
}

extension CIOResult: Identifiable {
    public var id: String {
        return data.id ?? "variation"
    }
}
