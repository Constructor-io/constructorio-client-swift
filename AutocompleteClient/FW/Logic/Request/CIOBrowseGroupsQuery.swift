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
     The filters used to refine results
     filters[group_id] - The id of the specific group that should be included in the response
     */
    public let filters: CIOQueryFilters?

    /**
     The section to return results from
     */
    public let section: String
    
    /**
     The format options used to refine result groups
     fmt_options[groups_max_depth] - In case of hierarchical groups, maximum depth of the hierarchy that should be included in the response
     */
    public let fmtOptions: CIOQueryFmtOptions?

    func url(with baseURL: String) -> String {
        return String(format: Constants.BrowseGroupsQuery.format, baseURL)
    }

    /**
     Create a Browse Groups request query object

     - Parameters:
        - filters: The filters used to refine results
        - section: The section to return results from
        - fmtOptions: The format options used to refine result groups

     ### Usage Example: ###
     ```
     let groupId = "group_1"
     let fmtOptions = [(key: "groups_max_depth", value: "5") as FmtOption]

     let browseGroupsQuery = CIOBrowseGroupsQuery(
        filters: CIOQueryFilters(groupFilter: groupId, facetFilters: nil),
        section: "Products",
        fmtOptions: CIOQueryFmtOptions(fmtOptions)
     )
     
     constructor.browseGroups(forQuery: browseGroupsQuery, completionHandler: { ... })
     ```
     */
    public init(filters: CIOQueryFilters? = nil, section: String? = nil, fmtOptions: CIOQueryFmtOptions? = nil) {
        
        self.filters = filters
        self.section = section ?? Constants.BrowseGroupsQuery.defaultSectionName
        self.fmtOptions = fmtOptions
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
        requestBuilder.set(fmtOptions: self.fmtOptions?.fmtOptions)
        requestBuilder.set(section: self.section)
    }
}
