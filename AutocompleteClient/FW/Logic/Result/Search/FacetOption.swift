//
//  FacetOption.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public struct FacetOption {
    public let count: Int
    public let displayName: String
    public let status: String
    public let value: String
    public let data: [String: Any]
}

public extension FacetOption {
    init?(json: JSONObject) {
        guard let count = json["count"] as? Int else { return nil }
        guard let value = json["value"] as? String else { return nil }
        guard let status = json["status"] as? String else { return nil }
        guard let displayName = json["display_name"] as? String else { return nil }

        let data = json["data"] as? [String: Any] ?? [:]

        self.count = count
        self.value = value
        self.status = status
        self.displayName = displayName
        self.data = data
    }
}
