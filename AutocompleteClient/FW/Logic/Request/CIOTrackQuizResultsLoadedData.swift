//
//  CIOTrackQuizResultsLoadedData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track quiz results loaded
 */
struct CIOTrackQuizResultsLoadedData: CIORequestData {

    let quizID: String
    let quizVersionID: String
    let quizSessionID: String
    let url: String
    let resultID: String?
    let resultPage: Int?
    let resultCount: Int?
    var sectionName: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.trackQuizResultsLoaded.format, baseURL)
    }

    init(quizID: String, quizVersionID: String, quizSessionID: String, url: String = "Not Available", resultID: String? = nil, resultPage: Int? = nil, resultCount: Int? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
        self.quizID = quizID
        self.quizVersionID = quizVersionID
        self.quizSessionID = quizSessionID
        self.url = url
        self.resultID = resultID
        self.resultPage = resultPage
        self.resultCount = resultCount
        self.sectionName = sectionName
        self.analyticsTags = analyticsTags
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
            "url": self.url,
        ] as [String: Any]

        if self.resultID != nil {
            dict["result_id"] = self.resultID
        }
        if self.resultPage != nil {
            dict["result_page"] = Int(self.resultPage!)
        }
        if self.resultCount != nil {
            dict["result_count"] = Int(self.resultCount!)
        }
        if (self.analyticsTags != nil) {
            dict["analytics_tags"] = self.analyticsTags
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
