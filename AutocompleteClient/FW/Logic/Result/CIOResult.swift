//
//  CIOResult.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Class encapsulating a single autocomplete result item.
 */
@objc public class CIOResult: NSObject {
    
    /// Convenience dictionary that contains all String only properties of this item.
    public let stringData: [String: String]
    
    /// The nested data JSON object of this item.
    public let data: JSONObject
    
    /// The name of this item.
    public let value: String
    
    /// The raw JSON of this item.
    public let json: JSONObject

    public init?(json: JSONObject) {
        guard let value = json[Constants.Result.value] as? String else {
            return nil
        }
        
        self.data = json[Constants.Result.data] as? JSONObject ?? [:]

        // TODO: Write map here
        var stringData = [String: String]()
        // Build stringData dictionary
        data.forEach { key, val in
            // If value is a String, add to stringData
            guard let stringVal = val as? String else { return }
            stringData[key] = stringVal
        }

        self.stringData = stringData
        self.value = value
        self.json = json
    }
}
