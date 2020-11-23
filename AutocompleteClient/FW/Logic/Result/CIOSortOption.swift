//
//  SortOption.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOSortOption {
    public let displayName: String
    public let sortBy: String
    public let sortOrder: CIOSortOrder
    public let status: String
}

public extension CIOSortOption {
    init?(json: JSONObject) {
        guard let displayName = json["display_name"] as? String else { return nil }
        guard let sortOrderStr = json["sort_order"] as? String else { return nil }
        guard let sortOrder = CIOSortOrder(rawValue: sortOrderStr) else { return nil }
        guard let sortBy = json["sort_by"] as? String else { return nil }
        guard let status = json["status"] as? String else { return nil }
        
        self.displayName = displayName
        self.sortBy = sortBy
        self.sortOrder = sortOrder
        self.status = status
    }
}


public enum CIOSortOrder: String {
    case ascending
    case descending
}
