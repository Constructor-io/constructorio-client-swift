//
//  CIOQuestionOption.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a question option attribute
 */
public struct CIOQuestionOptionAttribute {
    public let name: String
    public let value: String
}


/**
 Struct encapsulating a question option
 */
public struct CIOQuestionOption {
    public let id: String
    public let value: String
    public let attribute: CIOQuestionOptionAttribute?
    public let images: CIOQuestionImages?
}

/**
 Define a question option
 */
public extension CIOQuestionOption {
    /**
     Create a question options
    
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        guard let id = json["id"] as? String else { return nil }
        guard let value = json["value"] as? String else { return nil }
        let attribute = json["attribute"] as? CIOQuestionOptionAttribute
        let images = json["images"] as? CIOQuestionImages

        self.id = id
        self.value = value
        self.attribute = attribute
        self.images = images
    }
}
