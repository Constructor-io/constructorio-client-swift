//
//  CIOQuizQuestion.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a result data object with additional information about the result
 */
public struct CIOQuizQuestion {
    /**
     Question ID
     */
    public let id: Int

    /**
     Title of the question
     */
    public let title: String?

    /**
     The type of question
     */
    public let type: String?

    /**
     Description for the question
     */
    public let description: String?

    /**
     CTA text of the question
     */
    public let ctaText: String?

    /**
     Images associated with the question
     */
    public let images: CIOQuizImages?

    /**
     List of possible options (answers) for the question
     */
    public let options: [CIOQuizOption]?

    /**
     The input placeholder for the question
     */
    public let inputPlaceholder: String?

}

public extension CIOQuizQuestion {
    /**
     Create a result data object
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        guard let id = json["id"] as? Int else { return nil }
        let title = json["title"] as? String
        let type = json["type"] as? String
        let description = json["description"] as? String
        let optionsObj = json["options"] as? [JSONObject]
        let ctaText = json["cta_text"] as? String
        let inputPlaceholder = json["input_placeholder"] as? String

        if let images = json["images"] as? JSONObject {
            self.images = CIOQuizImages(json: images)
        } else {
            return nil
        }

        let options: [CIOQuizOption]? = optionsObj?.compactMap { obj in return CIOQuizOption(json: obj) } ?? []

        self.id = id
        self.title = title
        self.type = type
        self.description = description
        self.ctaText = ctaText
        self.options = options
        self.inputPlaceholder = inputPlaceholder
    }
}
