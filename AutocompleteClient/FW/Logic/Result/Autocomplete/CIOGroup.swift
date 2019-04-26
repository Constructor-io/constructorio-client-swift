//
//  CIOGroup.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

@objc
public class CIOGroup: NSObject {
    public let displayName: String
    public let groupID: String
    public let path: String?

    public init(displayName: String, groupID: String, path: String?) {
        self.displayName = displayName
        self.groupID = groupID
        self.path = path
    }

    init?(json: JSONObject){
        guard let name = json[Constants.Result.displayName] as? String else{
            return nil
        }

        guard let groupID = json[Constants.Result.groupID] as? String else{
            return nil
        }

        self.displayName = name
        self.groupID = groupID
        self.path = json[Constants.Result.path] as? String
    }
}
