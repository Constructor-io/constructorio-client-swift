//
//  SortOption.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a sort option
 */
public struct CIOSortOption {
    /**
     Display name of the sort option
     */
    public let displayName: String
    
    /**
     The field to sort by
     */
    public let sortBy: String
    
    /**
     The sort order (i.e. "ascending" or "descending")
     */
    public let sortOrder: CIOSortOrder
    
    /**
     The status of the sort option (i.e. "selected")
     */
    public let status: String
}

public extension CIOSortOption {
    /**
     Create a sort option
     
     - parameters
        -   json: JSON data from the server response
     */
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
