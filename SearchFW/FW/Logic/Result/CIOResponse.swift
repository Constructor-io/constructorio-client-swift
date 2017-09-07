//
//  CIOResponse.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias JSONObject = [String : Any]

/**
 Struct representing the autocomplete data response from the server.
 */
public struct CIOResponse {
    public let sections: [String: [CIOResult]]
    public let metadata: JSONObject
    public let json: JSONObject
}
