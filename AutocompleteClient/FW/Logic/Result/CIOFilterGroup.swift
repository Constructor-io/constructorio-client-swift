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
        guard let count = json["group_id"] as? Int else { return nil }

        let children: [CIOFilterGroup] = (json["children"] as? [JSONObject])?.compactMap { obj in
            return CIOFilterGroup(json: obj)
        } ?? []
        let parents: [CIOFilterGroup] = (json["parents"] as? [JSONObject])?.compactMap { obj in
            return CIOFilterGroup(json: obj)
        } ?? []

        self.displayName = name
        self.groupID = groupID
        self.count = count
        self.children = children
        self.parents = parents
    }
}
