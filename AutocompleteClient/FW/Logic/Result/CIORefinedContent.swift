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
    public let data: CIORefinedContentData
    
    /**
     Create a refined content object
     
     - Parameters:
        - json: JSON data from server reponse
     */
    public init?(json: JSONObject) {
        guard let dataJson = json["data"] as? JSONObject,
        let data: CIORefinedContentData = CIORefinedContentData(json: dataJson) else {
            return nil
        }
        
        self.data = data
    }
}
