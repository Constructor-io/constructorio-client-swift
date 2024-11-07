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

    public init(sections: [String: [CIOAutocompleteResult]], json: JSONObject, request: JSONObject = [:]) {
        self.sections = sections
        self.json = json
        self.request = request
    }
}
