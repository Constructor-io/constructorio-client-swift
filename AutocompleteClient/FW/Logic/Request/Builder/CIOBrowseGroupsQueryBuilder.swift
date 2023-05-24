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
     The filters used to refine results
     filters[group_id] - The id of the specific group that should be included in the response
     */
    var filters: CIOQueryFilters?

    /**
     The section to return results from
     */
    var section: String?

    /**
     The format options used to refine result groups
     fmt_options[groups_max_depth] - In case of hierarchical groups, maximum depth of the hierarchy that should be included in the response
     */
    var fmtOptions: CIOQueryFmtOptions?

    /**
     Creata a Browse Groups request query builder
     */
    public init() {}

    /**
     Specify the filters used to refine results
     */
    public func setFilters(_ filters: CIOQueryFilters) -> CIOBrowseGroupsQueryBuilder {
        self.filters = filters
        return self
    }
    
    /**
     Specify the id of the specific group that should be included in the response
     */
    public func setGroupId(_ groupId: String) -> CIOBrowseGroupsQueryBuilder {
        if self.filters == nil {
            self.filters = CIOQueryFilters(groupFilter: groupId, facetFilters: nil)
        } else {
            self.filters = CIOQueryFilters(groupFilter: groupId, facetFilters: self.filters?.facetFilters)
        }
        return self
    }
    
    /**
     Specify the format options used to refine result groups
     */
    public func setFmtOptions(_ fmtOptions: CIOQueryFmtOptions) -> CIOBrowseGroupsQueryBuilder {
        self.fmtOptions = fmtOptions
        return self
    }
    
    /**
     Specify fmt_options[groups_max_depth] that restricts the maximum depth of the hierarchy that should be included in the response
     Defaults to 1 if unspecified
     */
    public func setMaxDepth(_ maxDepth: Int) -> CIOBrowseGroupsQueryBuilder {
        let maxDepthFmtOption = ("groups_max_depth", String(maxDepth)) as FmtOption
        if self.fmtOptions == nil {
            self.fmtOptions = CIOQueryFmtOptions(fmtOptions: [maxDepthFmtOption])
        } else {
            var newFmtOptions = self.fmtOptions?.fmtOptions?.filter { $0.key != "groups_max_depth" }
            newFmtOptions?.append(maxDepthFmtOption)
            self.fmtOptions = CIOQueryFmtOptions(fmtOptions: newFmtOptions)
        }
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
     let groupId = "group_1"
     let fmtOptions = [(key: "groups_max_depth", value: "5") as FmtOption]
     
     let query = CIOBrowseGroupsQueryBuilder()
        .setGroupId(groupId)
        .setSection("Products")
        .setFmtOptions(CIOQueryFmtOptions(fmtOptions))
        .build()
     
     constructor.browseGroups(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIOBrowseGroupsQuery {
        return CIOBrowseGroupsQuery(filters: filters, section: section, fmtOptions: fmtOptions)
    }
}
