//
//  CIOTrackMediaImpressionData.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a media impression event
 */
struct CIOTrackMediaImpressionData: CIORequestData {

    enum Action {
        case view
        case click

        var urlFormat: String {
            switch self {
            case .view:
                return Constants.TrackMediaImpressionView.format
            case .click:
                return Constants.TrackMediaImpressionClick.format
            }
        }
    }

    let bannerAdId: String
    let placementId: String
    let action: Action

    func url(with baseURL: String) -> String {
        return String(format: action.urlFormat, baseURL)
    }

    init(bannerAdId: String, placementId: String, action: Action) {
        self.bannerAdId = bannerAdId
        self.placementId = placementId
        self.action = action
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict: [String: Any] = [
            "banner_ad_id": self.bannerAdId,
            "placement_id": self.placementId,
            "beacon": true
        ]

        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
