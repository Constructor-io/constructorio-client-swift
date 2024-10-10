//
//  CIOQuizResultsData.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a result data object with additional information about the result
 */
public struct CIOQuizResult {
    /**
     Filter Expressions
     */
    public let filterExpressions: [String: Any]

    /**
     Results Url
     */
    public let resultsUrl: String
}

public extension CIOQuizResult {
    /**
     Create a result data object
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        let filterExpressions = json["filter_expression"] as? [String: Any] ?? [:]
        let resultsUrl = json["results_url"] as? String ?? ""

        self.filterExpressions = filterExpressions
        self.resultsUrl = resultsUrl
    }
}
