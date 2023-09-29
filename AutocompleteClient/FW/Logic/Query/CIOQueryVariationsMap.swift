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

// Used in parsing JSON String Literals.
enum JSON: Codable {
    struct Key: CodingKey, Hashable, CustomStringConvertible {
        var description: String {
            return stringValue
        }

        // For arrays
        var intValue: Int? { return nil }
        // For objects
        let stringValue: String

        init?(intValue: Int) { return nil }
        init(_ string: String) { self.stringValue = string }
        init?(stringValue: String) { self.stringValue = stringValue }
    }

    // Possible JSON values
    case array([JSON])
    case object([Key: JSON])
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case null

    init(from decoder: Decoder) throws {
        if let object = try? decoder.container(keyedBy: Key.self) {
            var result: [Key: JSON] = [:]
            for key in object.allKeys {
                result[key] = (try? object.decode(JSON.self, forKey: key)) ?? .null
            }
            self = .object(result)
        }
        else if var array = try? decoder.unkeyedContainer() {
            var result: [JSON] = []
            for _ in 0..<(array.count ?? 0) {
                result.append(try array.decode(JSON.self))
            }
            self = .array(result)
        }
        else if let string = try? decoder.singleValueContainer().decode(String.self) { self = .string(string) }
        else if let int = try? decoder.singleValueContainer().decode(Int.self) { self = .int(int) }
        else if let double = try? decoder.singleValueContainer().decode(Double.self) { self = .double(double) }
        else if let bool = try? decoder.singleValueContainer().decode(Bool.self) { self = .bool(bool) }
        else if let isNull = try? decoder.singleValueContainer().decodeNil(), isNull { self = .null }
        else { throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Unknown JSON type")) }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .object(let object):
            // Custom order for FilterByExpression
            let orderedKeys: [Key] = [Key("not"), Key("or"), Key("and"), Key("field"), Key("value")]
            var container = encoder.container(keyedBy: Key.self)
            for key in orderedKeys {
                if let value = object[key] {
                    try container.encode(value, forKey: key)
                }
            }
            // Encodes other keys not specified
            for (key, value) in object where !orderedKeys.contains(key) {
                try container.encode(value, forKey: key)
            }
        case .array(let array):
            var container = encoder.unkeyedContainer()
            for value in array {
                try container.encode(value)
            }
        case .string(let string):
            var container = encoder.singleValueContainer()
            try container.encode(string)
        case .double(let number):
            var container = encoder.singleValueContainer()
            try container.encode(number)
        case .int(let number):
            var container = encoder.singleValueContainer()
            try container.encode(number)
        case .bool(let bool):
            var container = encoder.singleValueContainer()
            try container.encode(bool)
        case .null:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
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
public class FilterByExpressionJsonString: FilterByExpression {
    let jsonStr: JSON?

    public init(jsonStr: String) {
        // To make use of Swift's Encodable Protocol, we first have to decode the JSON String Literal for it to encode properly.
        self.jsonStr = try? JSONDecoder().decode(JSON.self, from: Data(jsonStr.utf8))
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.jsonStr)
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
    public let Values: [String: ValueOption]
    public let Dtype: String

    public init(GroupBy: [GroupByOption]? = nil, FilterBy: FilterByExpression? = nil, Values: [String: ValueOption], Dtype: String) {
        self.GroupBy = GroupBy
        self.FilterBy = FilterBy
        self.Values = Values
        self.Dtype = Dtype
    }

    public init(GroupBy: [GroupByOption]? = nil, FilterBy: String, Values: [String: ValueOption], Dtype: String) {
        self.GroupBy = GroupBy
        self.FilterBy = FilterByExpressionJsonString(jsonStr: FilterBy)
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
