//
//  CIOAutocompleteResponse.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias JSONObject = [String: Any]

/**
 Struct representing the autocomplete data response from the server.
 */
public struct CIOAutocompleteResponse {
    public let sections: [String: [CIOResult]]
    public let metadata: JSONObject
    public let json: JSONObject

    public init(sections: [String: [CIOResult]], metadata: JSONObject, json: JSONObject) {
        self.sections = sections
        self.metadata = metadata
        self.json = json
    }
}
