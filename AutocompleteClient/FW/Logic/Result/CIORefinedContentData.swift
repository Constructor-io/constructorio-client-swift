//
//  CIORefinedContentData.swift
//  ConstructorAutocomplete
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a refined content data
 */
public struct CIORefinedContentData {
    /**
     The body of text for the content
     */
    public let body: String?

    /**
     The header for the content
     */
    public let header: String?
    
    /**
     The alternative text for the main image
     */
    public let altText: String?
    
    /**
     The Call to Action URL to redirect the user to
     */
    public let ctaLink: String?
    
    /**
     The Call to Action text
     */
    public let ctaText: String?
    
    /**
     The URL for the main image
     */
    public let assetUrl: String?
    
    /**
     The URL for the mobile image
     */
    public let mobileAssetUrl: String?
    
    /**
     The alternative text for the mobile image
     */
    public let mobileAssetAltText: String?
    
    /**
     Create a refined content data object
     
     - Parameters:
        - json: JSON data from server response
     */
    init?(json: JSONObject) {
        let body = json["body"] as? String
        let header = json["header"] as? String
        let altText = json["altText"] as? String
        let ctaLink = json["ctaLink"] as? String
        let ctaText = json["ctaText"] as? String
        let assetUrl = json["assetUrl"] as? String
        let mobileAssetUrl = json["mobileAssetUrl"] as? String
        let mobileAssetAltText = json["mobileAssetAltText"] as? String

        self.body = body
        self.header = header
        self.altText = altText
        self.ctaLink = ctaLink
        self.ctaText = ctaText
        self.assetUrl = assetUrl
        self.mobileAssetUrl = mobileAssetUrl
        self.mobileAssetAltText = mobileAssetAltText
    }
}
