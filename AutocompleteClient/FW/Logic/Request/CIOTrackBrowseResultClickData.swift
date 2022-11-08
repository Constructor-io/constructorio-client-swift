//
//  CIOTrackBrowseResultClickData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track browse result click
 */
struct CIOTrackBrowseResultClickData: CIORequestData {

    let filterName: String
    let filterValue: String
    let customerID: String
    let resultPositionOnPage: Int?
    var sectionName: String?
    let resultID: String?
    let variationID: String?
    let beaconMode: Bool?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackBrowseResultClick.format, baseURL)
    }

    init(filterName: String, filterValue: String, customerID: String, resultPositionOnPage: Int?, sectionName: String? = nil, resultID: String? = nil, variationID: String? = nil, beaconMode: Bool? = nil) {
        self.filterName = filterName
        self.filterValue = filterValue
        self.customerID = customerID
        self.resultPositionOnPage = resultPositionOnPage
        self.sectionName = sectionName
        self.resultID = resultID
        self.variationID = variationID
        self.beaconMode = beaconMode
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "filter_name": self.filterName,
            "filter_value": self.filterValue,
            "item_id": self.customerID,
        ] as [String: Any]

        if self.variationID != nil {
            dict["variation_id"] = self.variationID
        }
        if self.resultPositionOnPage != nil {
            dict["result_position_on_page"] = Int(self.resultPositionOnPage!)
        }
        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }
        if self.resultID != nil {
            dict["result_id"] = self.resultID
        }
        if self.beaconMode != nil {
            dict["beacon"] = self.beaconMode
        }

        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
