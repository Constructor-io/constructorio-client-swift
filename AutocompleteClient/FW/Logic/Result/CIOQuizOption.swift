//
//  CIOQuizOption.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a quiz option
 */
public struct CIOQuizOption {
    /**
     The id of the option
     */
    public let id: Int

    /**
     The value of the option
     */
    public let value: String

    /**
     The attribute associated with the option
     */
    public let attribute: CIOQuizOptionAttribute?

    /**
     The images associated with the option
     */
    public let images: CIOQuizImages?
}

/**
 Define a quiz option
 */
public extension CIOQuizOption {
    /**
     Create a quiz option
    
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        guard let id = json["id"] as? Int else { return nil }
        guard let value = json["value"] as? String else { return nil }

        if let attribute = json["attribute"] as? JSONObject {
            self.attribute = CIOQuizOptionAttribute(json: attribute)
        } else {
            self.attribute = CIOQuizOptionAttribute(json: [String: Any]())
        }

        if let images = json["images"] as? JSONObject {
            self.images = CIOQuizImages(json: images)
        } else {
            self.images = CIOQuizImages(json: [String: Any]())
        }

        self.id = id
        self.value = value
    }
}
