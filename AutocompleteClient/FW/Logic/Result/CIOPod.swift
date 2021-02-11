//
//  CIOPod.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOPod {
    public let displayName: String
    public let id: String
}

public extension CIOPod {
    init?(object: JSONObject?) {
        guard let json = object else { return nil }
        guard let displayName = json["display_name"] as? String else { return nil }
        guard let id = json["id"] as? String else { return nil }

        self.displayName = displayName
        self.id = id
    }
}
