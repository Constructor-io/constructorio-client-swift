//
//  CIOResult.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

@objc public class CIOResult: NSObject {
    public let value: String
    public let data: CIOResultData
    public let matchedTerms: [String]
    public let variations: [CIOResult]
    public let json: JSONObject

    public init?(json: JSONObject) {
        guard let dataObj = json["data"] as? JSONObject else { return nil }
        guard let value = json["value"] as? String else { return nil }
        guard let data = CIOResultData(json: dataObj) else { return nil }

        let matchedTerms = (json["matched_terms"] as? [String]) ?? [String]()

        let variationsJSONArray = (json["variations"] as? [[String: Any]]) ?? [[String: Any]]()
        var variations = [CIOResult]()
        for variationObj in variationsJSONArray {
            if let variation = CIOResult(json: variationObj) {
                variations.append(variation)
            }
        }

        self.value = value
        self.data = data
        self.matchedTerms = matchedTerms
        self.variations = variations
        self.json = json
    }
}

extension CIOResult: Identifiable {
    public var id: String {
        return data.id
    }
}

extension CIOResult {
    public var group: CIOGroup? {
        return data.groups?[0]
    }
}
