//
//  CIOTrackBrowseResultsLoadedData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track browse results loaded
 */
struct CIOTrackBrowseResultsLoadedData: CIORequestData {
    let filterName: String
    let filterValue: String
    let resultCount: Int
    let resultID: String?
    let url: String
    let beaconMode: Bool?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackBrowseResultsLoaded.format, baseURL)
    }

    init(filterName: String, filterValue: String, resultCount: Int, resultID: String? = nil, url: String = "Not Available", beaconMode: Bool? = nil) {
        self.filterName = filterName
        self.filterValue = filterValue
        self.resultCount = resultCount
        self.resultID = resultID
        self.url = url
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
            "result_count": Int(self.resultCount),
            "url": self.url
        ] as [String: Any]

        if self.resultID != nil {
            dict["resultID"] = self.resultID
        }
        if self.beaconMode != nil {
            dict["beacon"] = self.beaconMode
        }

        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
