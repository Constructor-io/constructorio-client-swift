//
//  CIOQuizzesFinalizeData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation


/**
 Struct encapsulating a result data object with additional information about the result
 */
public struct CIOQuizzesFinalizeData {
    /**
     Filter Expressions
     */
    public let filterExpressions: Any

    /**
     Results Url
     */
    public let resultsUrl: String
}

public extension CIOQuizzesFinalizeData {
    /**
     Create a result data object
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        guard let filterExpressions = json["filter_expression"] as? Any else {return nil}
        guard let resultsUrl = json["results_url"] as? String else {return nil}

        self.filterExpressions = filterExpressions
        self.resultsUrl = resultsUrl
    }
}
