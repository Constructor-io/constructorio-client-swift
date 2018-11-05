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

    init(displayName: String, groupID: String, path: String?) {
        self.displayName = displayName
        self.groupID = groupID
        self.path = path
    }
}
