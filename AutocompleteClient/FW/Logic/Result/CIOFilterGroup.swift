//
//  CIOFilterGroup.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation


/**
 Struct encapsulating a filter group
 */
@objc
public class CIOFilterGroup: NSObject {
    /**
     Display name of the group (or category)
     */
    public let displayName: String
    
    /**
     Group ID
     */
    public let groupID: String
    
    /**
     The number of results that would be returned when selected
     */
    public let count: Int
    
    /**
     List of child groups
     */
    public let children: [CIOFilterGroup]
    
    /**
     List of parent groups that it belongs to
     */
    public let parents: [CIOFilterGroup]

    /**
     Create a filter group object
     
     - Parameters:
        - json: JSON data from server reponse
     */
    init?(json: JSONObject) {
        guard let name = json["display_name"] as? String else { return nil }
        guard let groupID = json["group_id"] as? String else { return nil }
        guard let count = json["count"] as? Int else { return nil }

        let childrenObj = json["children"] as? [JSONObject]
        let parentObj = json["parents"] as? [JSONObject]

        let children: [CIOFilterGroup] = childrenObj?.compactMap { obj in return CIOFilterGroup(json: obj) } ?? []
        let parents: [CIOFilterGroup] = parentObj?.compactMap { obj in return CIOFilterGroup(json: obj) } ?? []

        self.displayName = name
        self.groupID = groupID
        self.count = count
        self.children = children
        self.parents = parents
    }
}
