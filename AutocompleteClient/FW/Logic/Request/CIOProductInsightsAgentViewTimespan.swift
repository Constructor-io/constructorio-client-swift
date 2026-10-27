//
//  CIOProductInsightsAgentViewTimespan.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing a period of time during which the Product Insights Agent was visible to the user
 */
public struct CIOProductInsightsAgentViewTimespan {

    /**
     The time the Product Insights Agent became visible
     */
    public let start: Date

    /**
     The time the Product Insights Agent stopped being visible
     */
    public let end: Date

    /**
     Create a Product Insights Agent view timespan

     - Parameters:
        - start: The time the Product Insights Agent became visible
        - end: The time the Product Insights Agent stopped being visible
     */
    public init(start: Date, end: Date) {
        self.start = start
        self.end = end
    }

    // A fixed-format DateFormatter is used instead of ISO8601DateFormatter because setting
    // `.withFractionalSeconds` throws an exception on iOS 11.0 and 11.1. DateFormatter is thread-safe,
    // so a single shared instance is used for all timespans
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return formatter
    }()

    // Dates are formatted as ISO-8601 strings in UTC (e.g. "2026-10-22T02:40:05.123Z") so the body stays JSON-serializable
    func toDictionary() -> [String: String] {
        return [
            "start": CIOProductInsightsAgentViewTimespan.dateFormatter.string(from: self.start),
            "end": CIOProductInsightsAgentViewTimespan.dateFormatter.string(from: self.end)
        ]
    }
}
