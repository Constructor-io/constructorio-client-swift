//
//  CIOBrowseGroupsQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute a browse groups query.
 */
public struct CIOBrowseGroupsQuery: CIORequestData {

    /**
     The id of the specific group that should be included in the response
     */
    public let groupId: String?

    /**
     The section to return results from
     */
    public let section: String

    /**
     The maximum depth of the hierarchy, in case of hierarchical groups, that should be included in the response
     */
    public let groupsMaxDepth: Int?

    func url(with baseURL: String) -> String {
        return String(format: Constants.BrowseGroupsQuery.format, baseURL)
    }

    /**
     Create a Browse Groups request query object

     - Parameters:
        - groupId: The id of the specific group that should be included in the response
        - section: The section to return results from
        - groupsMaxDepth: The maximum depth of the hierarchy, in case of hierarchical groups, that should be included in the response

     ### Usage Example: ###
     ```
     let browseGroupsQuery = CIOBrowseGroupsQuery(
        groupId: "group_1",
        section: "Products",
        groupsMaxDepth: 5
     )
     ```
     */
    public init(groupId: String? = nil, section: String? = nil, groupsMaxDepth: Int? = nil) {
        self.groupId = groupId
        self.section = section ?? Constants.BrowseGroupsQuery.defaultSectionName
        self.groupsMaxDepth = groupsMaxDepth
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(groupFilter: groupId)
        if let groupsMaxDepth = self.groupsMaxDepth {
            let maxDepthFmtOption = ("groups_max_depth", String(groupsMaxDepth)) as FmtOption
            requestBuilder.set(fmtOptions: [maxDepthFmtOption])
        }
        requestBuilder.set(section: self.section)
    }
}
