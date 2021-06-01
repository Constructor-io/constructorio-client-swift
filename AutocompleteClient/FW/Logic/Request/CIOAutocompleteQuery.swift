//
//  CIOAutocompleteQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute an autocomplete query.
 */
public struct CIOAutocompleteQuery: CIORequestData {
    /**
     User typed query to return results for
     */
    let query: String
    
    /**
     The number of results to return
     */
    let numResults: Int?
    
    /**
     The section to return results from
     */
    let numResultsForSection: [String: Int]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.AutocompleteQuery.format, baseURL, query)
    }

    /**
     Create an Autocomplete request query object
        
     - Parameters:
        - query: User typed query to return results for
        - numResults: The number of results to return
        - numresultsForSection: The section to return results from
     
     ### Usage Example: ###
     ```
     let autocompleteQuery = CIOAutocompleteQuery(query: "apple", numResults: 5, numResultsForSection: ["Products": 6, "Search Suggestions": 8])
     ```
     */
    public init(query: String, numResults: Int? = nil, numResultsForSection: [String: Int]? = nil) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.numResults = numResults
        self.numResultsForSection = numResultsForSection
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResults)
        requestBuilder.set(numResultsForSection: self.numResultsForSection)
    }
}
