//
//  CIOTrackRecommendationResultsViewData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track browse result click
 */
struct CIOTrackRecommendationResultsViewData: CIORequestData {

    let podID: String
    let url: String
    let numResultsViewed: Int?
    let resultPage: Int?
    let resultCount: Int?
    let sectionName: String?
    let resultID: String?
    let customerIDs: [String]?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackRecommendationResultsView.format, baseURL)
    }

    init(podID: String, numResultsViewed: Int? = nil, customerIDs: [String]? = nil, resultPage: Int? = nil, resultCount: Int? = nil, sectionName: String? = nil, resultID: String? = nil, url: String = "Not Available", analyticsTags: [String: String]? = nil) {
        self.podID = podID
        self.url = url
        self.numResultsViewed = numResultsViewed
        self.resultPage = resultPage
        self.resultCount = resultCount
        self.sectionName = sectionName
        self.resultID = resultID
        self.customerIDs = customerIDs
        self.analyticsTags = analyticsTags
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "pod_id": self.podID,
            "url": self.url
        ] as [String: Any]

        if self.numResultsViewed != nil {
            dict["num_results_viewed"] = self.numResultsViewed
        }
        if self.resultPage != nil {
            dict["result_page"] = self.resultPage
        }
        if self.resultCount != nil {
            dict["result_count"] = self.resultCount
        }
        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }
        if self.resultID != nil {
            dict["result_id"] = self.resultID
        }
        if let loadedCustomerIDs = self.customerIDs {
            let items = loadedCustomerIDs.map { ["item_id": $0] }
            dict["items"] = items
       }
        if (self.analyticsTags != nil) {
            dict["analytics_tags"] = self.analyticsTags
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
