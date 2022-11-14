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
     Title of the result question
     */
    public let title: String?

    /**
     Description of the result question
     */
    public let description: String?

    /**
     CTA text of the result question
     */
    public let ctaText: String?

    /**
     Images of the result question
     */
    public let images: CIOQuizImages?

    /**
     Options of the result question
     */
    public let options: [CIOQuizOption]?
    
    /**
     Input placeholder of the result question
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
        let description = json["description"] as? String
        let optionsObj = json["options"] as? [JSONObject]
        let ctaText = json["cta_text"] as? String
        let inputPlaceholder = json["input_placeholder"] as? String
                    
        if let images = json["images"] as? JSONObject {
            self.images = CIOQuizImages(json: images)
        } else {
            return nil
        }

        let options: [CIOQuizOption]? = optionsObj?.compactMap { obj in return CIOQuizOption(json: obj) }

        self.id = id
        self.title = title
        self.description = description
        self.ctaText = ctaText
        self.options = options
        self.inputPlaceholder = inputPlaceholder
    }
}
