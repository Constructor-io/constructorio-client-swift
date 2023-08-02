//
//  CIOTrackQuizResultClickData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track quiz result click
 */
struct CIOTrackQuizResultClickData: CIORequestData {

    let quizID: String
    let quizVersionID: String
    let quizSessionID: String
    let customerID: String
    let variationID: String?
    let itemName: String?
    let resultID: String?
    let resultPage: Int?
    let resultCount: Int?
    let numResultsPerPage: Int?
    let resultPositionOnPage: Int?
    var sectionName: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.trackQuizResultClick.format, baseURL)
    }

    init(quizID: String, quizVersionID: String, quizSessionID: String, customerID: String, variationID: String? = nil, itemName: String? = nil, resultID: String? = nil, resultPage: Int? = nil, resultCount: Int? = nil, numResultsPerPage: Int? = nil, resultPositionOnPage: Int? = nil, sectionName: String? = nil) {
        self.quizID = quizID
        self.quizVersionID = quizVersionID
        self.quizSessionID = quizSessionID
        self.customerID = customerID
        self.variationID = variationID
        self.itemName = itemName
        self.resultID = resultID
        self.resultPage = resultPage
        self.resultCount = resultCount
        self.numResultsPerPage = numResultsPerPage
        self.resultPositionOnPage = resultPositionOnPage
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
            "action_class": "result_click"
        ] as [String: Any]

        if self.variationID != nil {
            dict["variation_id"] = self.variationID
        }
        if self.itemName != nil {
            dict["item_name"] = self.itemName
        }
        if self.resultID != nil {
            dict["result_id"] = self.resultID
        }
        if self.resultPage != nil {
            dict["result_page"] = Int(self.resultPage!)
        }
        if self.resultCount != nil {
            dict["result_count"] = Int(self.resultCount!)
        }
        if self.numResultsPerPage != nil {
            dict["num_results_per_page"] = Int(self.numResultsPerPage!)
        }
        if self.resultPositionOnPage != nil {
            dict["result_position_on_page"] = Int(self.resultPositionOnPage!)
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
