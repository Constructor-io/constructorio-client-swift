//
//  CIOQuizNextQuestionOption.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a question option attribute
 */
public struct CIOQuizNextQuestionOptionAttribute {
    public let name: String
    public let value: String
}

/**
 Struct encapsulating a question option
 */
public struct CIOQuizNextQuestionOption {
    public let id: String
    public let value: String
    public let attribute: CIOQuizNextQuestionOptionAttribute?
    public let images: CIOQuizNextQuestionImages?
}

/**
 Define a question option
 */
public extension CIOQuizNextQuestionOption {
    /**
     Create a question options
    
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        guard let id = json["id"] as? String else { return nil }
        guard let value = json["value"] as? String else { return nil }
        let attribute = json["attribute"] as? CIOQuizNextQuestionOptionAttribute
        let images = json["images"] as? CIOQuizNextQuestionImages

        self.id = id
        self.value = value
        self.attribute = attribute
        self.images = images
    }
}
