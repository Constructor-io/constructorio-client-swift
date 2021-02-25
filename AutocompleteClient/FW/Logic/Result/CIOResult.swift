//
//  CIOResult.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

@objc
public class CIOResult: NSObject {
    public let value: String
    public let data: CIOResultData
    public let matchedTerms: [String]
    public let variations: [CIOResult]
    public let json: JSONObject
//    public let strategy: CIORecommendationsStrategy?

    public init?(json: JSONObject) {
        guard let dataObj = json["data"] as? JSONObject else { return nil }
        guard let value = json["value"] as? String else { return nil }
        guard let data = CIOResultData(json: dataObj) else { return nil }

        let matchedTerms = (json["matched_terms"] as? [String]) ?? [String]()
        let variationsObj = json["variations"] as? [JSONObject]

        let variations: [CIOResult] = variationsObj?.compactMap { obj in return CIOResult(json: obj) } ?? []
        
//        let strategyData = json["strategy"] as? JSONObject
//
//        let strategy: CIORecommendationsStrategy = strategyData != nil ? CIORecommendationsStrategy(json: strategyData)! : CIORecommendationsStrategy(json: [String: Any]())!

        self.value = value
        self.data = data
        self.matchedTerms = matchedTerms
        self.variations = variations
        self.json = json
//        self.strategy = strategy
    }
}

extension CIOResult: Identifiable {
    public var id: String {
        return data.id ?? "variation"
    }
}
