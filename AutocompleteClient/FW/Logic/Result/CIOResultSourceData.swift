//
//  CIOResultSourcesData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//
import Foundation

/**
 Struct encapsulating a result source data
 */
public class CIOResultSourceData: NSObject {
    /**
     Number of results matching
     */
    public let count: Int

    /**
     Create a result source object
     
     - Parameters:
        - json: JSON data from server reponse
     */
    init?(json: JSONObject?) {
        guard let json = json, let count = json["count"] as? Int else {
            return nil
        }

        self.count = count
    }
}
