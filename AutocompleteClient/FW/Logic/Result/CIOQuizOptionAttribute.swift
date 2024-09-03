//
//  CIOQuizOptionAttribute.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a quiz option attribute
 */
public struct CIOQuizOptionAttribute {
    /**
     Quiz option attribute name
     */
    public let name: String

    /**
     Quiz option attribute value
     */
    public let value: String
}

/**
 Define a quiz option attribute
 */
public extension CIOQuizOptionAttribute {
    /**
     Create a quiz option attribute object
    
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        guard let name = json["name"] as? String else { return nil }
        guard let value = json["value"] as? String else { return nil }

        self.name = name
        self.value = value
    }
}
