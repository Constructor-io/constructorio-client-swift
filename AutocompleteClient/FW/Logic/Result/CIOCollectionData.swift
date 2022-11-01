//
//  CIOCollectionData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//
import Foundation

/**
 Struct encapsulating a collection
 */
public class CIOCollectionData: NSObject {
    /**
     Id of the collection
     */
    public let id: String

    /**
     Display name of the collection
     */
    public let display_name: String

    /**
     Additional metadata for the collection
     */
    public let data: [String: Any]

    /**
     Create a collection object
     
     - Parameters:
        - json: JSON data from server reponse
     */
    init?(json: JSONObject?) {
        guard let json = json, let id = json["id"] as? String, let display_name = json["display_name"] as? String else {
            return nil
        }

        let data = json["data"] as? [String: Any] ?? [:]

        self.id = id
        self.display_name = display_name
        self.data = data
    }
}
