//
//  CIOFilterGroup.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

@objc
public class CIOFilterGroup: NSObject {
    public let displayName: String
    public let groupID: String
    public let count: Int
    public let children: [CIOFilterGroup]
    public let parents: [CIOFilterGroup]

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
