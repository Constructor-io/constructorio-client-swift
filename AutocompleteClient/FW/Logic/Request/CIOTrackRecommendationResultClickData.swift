//
//  CIOTrackRecommendationResultClickData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track browse result click
 */
struct CIOTrackRecommendationResultClickData: CIORequestData {

    let podID: String
    let strategyID: String?
    let customerID: String
    let variationID: String?
    let numResultsPerPage: Int?
    let resultPage: Int?
    let resultCount: Int?
    let resultPositionOnPage: Int?
    let sectionName: String?
    let resultID: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackBrowseResultClick.format, baseURL)
    }

    init(podID: String, strategyID: String? = nil, customerID: String, variationID: String? = nil, numResultsPerPage: Int? = nil, resultPage: Int? = nil, resultCount: Int? = nil, resultPositionOnPage: Int? = nil, sectionName: String? = nil, resultID: String? = nil) {
        self.podID = podID
        self.strategyID = strategyID
        self.customerID = customerID
        self.variationID = variationID
        self.numResultsPerPage = numResultsPerPage
        self.resultPage = resultPage
        self.resultCount = resultCount
        self.resultPositionOnPage = resultPositionOnPage
        self.sectionName = sectionName
        self.resultID = resultID
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "pod_id": self.podID,
            "item_id": self.customerID
        ] as [String : Any]
        
        if self.strategyID != nil {
            dict["strategy_id"] = self.strategyID
        }
        if self.variationID != nil {
            dict["variation_id"] = self.variationID
        }
        if self.numResultsPerPage != nil {
            dict["num_results_per_page"] = self.numResultsPerPage
        }
        if self.resultPage != nil {
            dict["result_page"] = self.resultPage
        }
        if self.resultCount != nil {
            dict["result_count"] = self.resultCount
        }
        if self.resultPositionOnPage != nil {
            dict["result_position_on_page"] = self.resultPositionOnPage
        }
        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }
        if self.resultID != nil {
            dict["result_id"] = self.resultID
        }

        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
