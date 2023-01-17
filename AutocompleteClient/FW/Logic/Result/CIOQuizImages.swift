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
public struct CIOQuizImages {
    /**
     Primary image URL
     */
    public let primaryUrl: String?

    /**
     Primary image alternative text
     */
    public let primaryAlt: String?

    /**
     Secondary image URL
     */
    public let secondaryUrl: String?

    /**
     Secondary image alternative text
     */
    public let secondaryAlt: String?
}

/**
 Define a question images
 */
public extension CIOQuizImages {
    /**
     Create a question images
    
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        if let primaryUrl = json["primary_url"] as? String { self.primaryUrl = primaryUrl } else { self.primaryUrl = nil }
        if let primaryAlt = json["primary_alt"] as? String { self.primaryAlt = primaryAlt } else { self.primaryAlt = nil }
        if let secondaryUrl = json["secondary_url"] as? String { self.secondaryUrl = secondaryUrl } else { self.secondaryUrl = nil }
        if let secondaryAlt = json["secondary_alt"] as? String { self.secondaryAlt = secondaryAlt } else { self.secondaryAlt = nil }
    }
}
