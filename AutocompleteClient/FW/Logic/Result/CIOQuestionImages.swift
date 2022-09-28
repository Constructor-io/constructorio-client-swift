//
//  CIOQuestionImages.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a question images
 */
public struct CIOQuestionImages {
    public let primaryUrl: String?
    public let primaryAlt: String?
    public let secondaryUrl: String?
    public let secondaryAlt: String?
}

/**
 Define a question images
 */
public extension CIOQuestionImages {
    /**
     Create a question images
    
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        let primaryUrl = json["primary_url"] as? String
        let primaryAlt = json["primary_alt"] as? String
        let secondaryUrl = json["secondary_url"] as? String
        let secondaryAlt = json["secondary_alt"] as? String
        
        self.primaryUrl = primaryUrl
        self.primaryAlt = primaryAlt
        self.secondaryUrl = secondaryUrl
        self.secondaryAlt = secondaryAlt
    }
}
