//
//  CIORefinedContent.swift
//  ConstructorAutocomplete
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a refined content with associated metadata
 */
public struct CIORefinedContent {
    /**
     Refine dcontent data
     */
    public let data: [String: Any]

    /**
     Create a refined content object
     
     - Parameters:
        - json: JSON data from server reponse
     */
    public init?(json: JSONObject) {
        guard let data = json["data"] as? [String: Any] else { return nil }

        self.data = data
    }
}
