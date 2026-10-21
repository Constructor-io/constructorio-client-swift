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

    // ISO8601DateFormatter is thread-safe, so a single shared instance is used for all timespans
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    // Dates are formatted as ISO-8601 strings in UTC (e.g. "2026-10-22T02:40:05.123Z") so the body stays JSON-serializable
    func toDictionary() -> [String: String] {
        return [
            "start": CIOProductInsightsAgentViewTimespan.format(self.start),
            "end": CIOProductInsightsAgentViewTimespan.format(self.end)
        ]
    }

    // The formatter truncates to milliseconds, so round first to avoid floating point error dropping a millisecond
    static func format(_ date: Date) -> String {
        let roundedInterval = (date.timeIntervalSinceReferenceDate * 1000).rounded() / 1000
        return dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: roundedInterval))
    }
}
