//
//  CIOTrackMediaImpressionClickData.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a media impression click
 */
struct CIOTrackMediaImpressionClickData: CIORequestData {

    let bannerAdId: String
    let placementId: String

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackMediaImpressionClick.format, baseURL)
    }

    init(bannerAdId: String, placementId: String) {
        self.bannerAdId = bannerAdId
        self.placementId = placementId
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "banner_ad_id": self.bannerAdId,
            "placement_id": self.placementId
        ] as [String: Any]

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
