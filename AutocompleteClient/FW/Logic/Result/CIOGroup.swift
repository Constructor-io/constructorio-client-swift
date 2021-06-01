//
//  CIOGroup.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation


/**
 Struct encapsulating a group
 */
@objc
public class CIOGroup: NSObject {
    /**
     Display name of the group (or category)
     */
    public let displayName: String
    
    /**
     Group ID
     */
    public let groupID: String
    
    /**
     The full path of the group hierarchy
     */
    public let path: String?
    
    /**
     Create a group
     
     - Parameters:
        - displayName: Display nam eof the group
        - groupID: Group ID
        - path: The full path of the group hierarchy
     */
    public init(displayName: String, groupID: String, path: String?) {
        self.displayName = displayName
        self.groupID = groupID
        self.path = path
    }

    /**
     Create a group (from JSON)
     
     - Parameters:
        - json: JSON data from the server response
     */
    init?(json: JSONObject) {
        guard let name = json["display_name"] as? String else { return nil }
        guard let groupID = json["group_id"] as? String else { return nil }

        self.displayName = name
        self.groupID = groupID
        self.path = json["path"] as? String
    }
}
