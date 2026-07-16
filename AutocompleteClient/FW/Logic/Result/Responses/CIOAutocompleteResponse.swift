//
//  CIOAutocompleteResponse.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias JSONObject = [String: Any]

/**
 Struct representing the autocomplete data response from the server.
*/
public struct CIOAutocompleteResponse {
    /**
     List of results broken down by sections
     */
    public let sections: [String: [CIOAutocompleteResult]]

    /**
     Additional information about the request and result ID
     */
    public let json: JSONObject

    /**
     Request object used to retrieve the Autocomplete Response
     */
    public var request: JSONObject

    /**
     Total number of results available per section, keyed by section name.
     Will be empty if the server did not include `total_num_results_per_section` in the response.
     */
    public let totalNumResultsPerSection: [String: Int]

    public init(sections: [String: [CIOAutocompleteResult]], json: JSONObject, request: JSONObject = [:], totalNumResultsPerSection: [String: Int] = [:]) {
        self.sections = sections
        self.json = json
        self.request = request
        self.totalNumResultsPerSection = totalNumResultsPerSection
    }
}
