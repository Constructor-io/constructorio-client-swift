//
//  CIOSearchFilters.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the filters that can be sent when tracking a search submission.
 Only carries `group_id` filter.
 */
public struct CIOSearchFilters {
    static let groupIDMaxLength = 250

    /**
     The id of the group applied by the search. Should be present when the user selects a search suggestion that automatically applies a group filter
     */
    public let groupID: String

    /**
     Create search filters. Returns nil if `groupID` is empty or longer than 250 characters, since the API would reject it.

     - Parameters:
        - groupID: The id of the group applied by the search
     */
    public init?(groupID: String) {
        guard !groupID.isEmpty, groupID.count <= CIOSearchFilters.groupIDMaxLength else { return nil }
        self.groupID = groupID
    }
}
