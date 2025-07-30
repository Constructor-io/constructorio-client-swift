//
//  CIOFilterFacetOption.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a filter facet option with information about the status and results associated with it.
 */
public struct CIOFilterFacetOption {
    /**
     The number of results that will be returned when selected
     */
    public let count: Int

    /**
     Display name of the facet option
     */
    public let displayName: String

    /**
     The facet value
     */
    public let value: String

    /**
     Additional metadata for the facet option
     */
    public let data: [String: Any]

    /**
     Status of the facet option
     Can be:
     - A string ("selected" or ""), if the facet type is "multiple"
     - An empty object, if the facet type is range and the facet is not selected
     - An object with "min" and "max" values, if the facet type is range and the facet is selected
     */
    public let status: Status

    /**
     Enum representing the status of a facet option.
     */
    public enum Status {
        case string(String)
        case range(min: Double, max: Double)
        case emptyObject

        /**
         Returns true if the status is an empty string or empty object
         */
        public var isEmpty: Bool {
            switch self {
            case .string(let value): return value.isEmpty
            case .emptyObject: return true
            case .range: return false
            }
        }

        /**
         Returns a tuple of min and max values if the status is a range
         */
        public var range: (min: Double, max: Double)? {
            if case let .range(min, max) = self {
                return (min, max)
            }
            return nil
        }
    }
}

public extension CIOFilterFacetOption {

    /**
     Create a filter facet option
     
     - Parameters:
        - json: JSON data from server response
     */
    init?(json: [String: Any]) {
        guard let count = json["count"] as? Int else { return nil }
        guard let displayName = json["display_name"] as? String else { return nil }
        guard let value = json["value"] as? String else { return nil }

        let data = json["data"] as? [String: Any] ?? [:]
        self.count = count
        self.displayName = displayName
        self.value = value
        self.data = data

        // Parse status
        if let statusString = json["status"] as? String {
            self.status = .string(statusString)
        } else if let statusDict = json["status"] as? [String: Any] {
            if statusDict.isEmpty {
                self.status = .emptyObject
            } else if let min = statusDict["min"] as? Double ?? (statusDict["min"] as? Int).map(Double.init),
                      let max = statusDict["max"] as? Double ?? (statusDict["max"] as? Int).map(Double.init) {
                self.status = .range(min: min, max: max)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
