//
//  CIOBrowseGroupsQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating an browse groups query.
 */
public class CIOBrowseGroupsQueryBuilder {
    
    /**
     The id of the specific group that should be included in the response
     */
    var groupId: String?

    /**
     The section to return results from
     */
    var section: String?

    /**
     The maximum depth of the hierarchy, in case of hierarchical groups, that should be included in the response
     */
    var groupsMaxDepth: Int?

    /**
     Creata a Browse Groups request query builder
     */
    public init() {}

    /**
     Specify the id of the specific group that should be included in the response
     */
    public func setGroupId(_ groupId: String) -> CIOBrowseGroupsQueryBuilder {
        self.groupId = groupId
        return self
    }
    
    /**
     Specify the maximum depth of the hierarchy that should be included in the response
     Defaults to 1 if unspecified
     */
    public func setMaxDepth(_ maxDepth: Int) -> CIOBrowseGroupsQueryBuilder {
        self.groupsMaxDepth = maxDepth
        return self
    }
    
    /**
     Specify the section to return results from
     */
    public func setSection(_ section: String) -> CIOBrowseGroupsQueryBuilder {
        self.section = section
        return self
    }

    /**
     Build the request object set all of the provided data
     
     ### Usage Example: ###
     ```
     let query = CIOBrowseGroupsQueryBuilder()
        .setGroupId("group_1")
        .setSection("Products")
        .setMaxDepth(5)
        .build()
     
     constructor.browseGroups(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIOBrowseGroupsQuery {
        return CIOBrowseGroupsQuery(groupId: groupId, section: section, groupsMaxDepth: groupsMaxDepth)
    }
}
