//
//  CIOQueryVariationsMap.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct GroupByOption: Encodable {
    let name: String
    let field: String

    public init(name: String, field: String) {
        self.name = name
        self.field = field
    }
}

public class FilterByExpression: Encodable {}
public class FilterByExpressionNot: FilterByExpression {
    let not: FilterByExpression

    public init(not: FilterByExpression) {
        self.not = not
    }

    private enum CodingKeys: String, CodingKey {
        case not
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.not, forKey: .not)
    }
}
public class FilterByExpressionAnd: FilterByExpression {
    let and: [FilterByExpression]

    public init(exprArr: [FilterByExpression]) {
        self.and = exprArr
    }

    private enum CodingKeys: String, CodingKey {
        case and
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.and, forKey: .and)
    }
}
public class FilterByExpressionOr: FilterByExpression {
    let or: [FilterByExpression]

    public init(exprArr: [FilterByExpression]) {
        self.or = exprArr
    }

    private enum CodingKeys: String, CodingKey {
        case or
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.or, forKey: .or)
    }
}
public class FilterByExpressionValue<T: Codable>: FilterByExpression {
    let field: String
    let value: T

    public init(fieldPath: String, value: T) {
        self.field = fieldPath
        self.value = value
    }

    private enum CodingKeys: String, CodingKey {
        case field, value
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.field, forKey: .field)
        try container.encode(self.value, forKey: .value)
    }
}

public struct ValueOption: Encodable {
    let aggregation: String
    let field: String

    public init(aggregation: String, field: String) {
        self.aggregation = aggregation
        self.field = field
    }
}

public struct CIOQueryVariationsMap: Encodable {
    public let GroupBy: [GroupByOption]?
    public let FilterBy: FilterByExpression?
    public let FilterByJsonStr: String?
    public let Values: [String: ValueOption]
    public let Dtype: String

    public init(GroupBy: [GroupByOption]? = nil, FilterBy: FilterByExpression? = nil, Values: [String: ValueOption], Dtype: String) {
        self.GroupBy = GroupBy
        self.FilterBy = FilterBy
        self.FilterByJsonStr = nil
        self.Values = Values
        self.Dtype = Dtype
    }

    // Overload to allow passing of encoded FilterBy Json String Literal similar to Prefilters.
    public init(GroupBy: [GroupByOption]? = nil, FilterBy: String, Values: [String: ValueOption], Dtype: String) {
        self.GroupBy = GroupBy
        self.FilterBy = nil
        self.FilterByJsonStr = FilterBy
        self.Values = Values
        self.Dtype = Dtype
    }

    enum CodingKeys: String, CodingKey {
        case GroupBy = "group_by"
        case FilterBy = "filter_by"
        case Values = "values"
        case Dtype = "dtype"
    }
}
