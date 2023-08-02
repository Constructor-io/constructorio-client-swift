//
//  CIOTrackQuizConversionData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track quiz conversion
 */
struct CIOTrackQuizConversionData: CIORequestData {

    let quizID: String
    let quizVersionID: String
    let quizSessionID: String
    let customerID: String
    let variationID: String?
    let itemName: String?
    let revenue: Double?
    let conversionType: String?
    let isCustomType: Bool?
    let displayName: String?
    var sectionName: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.trackQuizConversion.format, baseURL)
    }

    init(quizID: String, quizVersionID: String, quizSessionID: String, customerID: String, variationID: String? = nil, itemName: String? = nil, revenue: Double? = nil, conversionType: String? = nil, isCustomType: Bool? = nil, displayName: String? = nil, sectionName: String? = nil) {
        self.quizID = quizID
        self.quizVersionID = quizVersionID
        self.quizSessionID = quizSessionID
        self.customerID = customerID
        self.variationID = variationID
        self.itemName = itemName
        self.revenue = revenue
        self.conversionType = conversionType
        self.isCustomType = isCustomType
        self.displayName = displayName
        self.sectionName = sectionName
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(autocompleteSection: self.sectionName)
    }

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "quiz_id": self.quizID,
            "quiz_version_id": self.quizVersionID,
            "quiz_session_id": self.quizSessionID,
            "item_id": self.customerID,
            "action_class": "conversion"
        ] as [String: Any]

        if self.variationID != nil {
            dict["variation_id"] = self.variationID
        }
        if self.itemName != nil {
            dict["item_name"] = self.itemName
        }
        if self.revenue != nil {
            dict["revenue"] = String(self.revenue!)
        }
        if self.conversionType != nil {
            dict["type"] = self.conversionType
        }
        if self.isCustomType != nil {
            dict["is_custom_type"] = self.isCustomType
        }
        if self.displayName != nil {
            dict["display_name"] = self.displayName
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
