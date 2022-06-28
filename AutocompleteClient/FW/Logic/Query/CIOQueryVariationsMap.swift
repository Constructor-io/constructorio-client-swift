//
//  CIOQueryVariationsMap.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct GroupByOption : Encodable {
    let name : String
    let field : String
    
    public init(name: String, field: String) {
        self.name = name
        self.field = field
    }
}

public struct ValueOption : Encodable {
    let aggregation : String
    let field : String
    
    public init(aggregation: String, field: String) {
        self.aggregation = aggregation
        self.field = field
    }
}

public struct CIOQueryVariationsMap : Encodable {
    public let GroupBy: [GroupByOption]?
    public let Values: [String : ValueOption]
    public let Dtype: String

    public init(GroupBy: [GroupByOption]? = nil, Values: [String : ValueOption], Dtype : String) {
        self.GroupBy = GroupBy;
        self.Values = Values;
        self.Dtype = Dtype;
    }
    
    enum CodingKeys: String, CodingKey {
        case GroupBy = "group_by"
        case Values = "values"
        case Dtype = "dtype"
    }
}
