//
//  CIOTrackSearchSubmitFilters.swift
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
public struct CIOTrackSearchSubmitFilters {
    /**
     The id of the group applied by the search. Should be present when the user selects a search suggestion that automatically applies a group filter
     */
    public let groupID: String

    /**
     Create search submit filters.

     - Parameters:
        - groupID: The id of the group applied by the search
     */
    public init(groupID: String) {
        self.groupID = groupID
    }
}
