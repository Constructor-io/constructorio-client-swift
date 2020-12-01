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

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackBrowseResultsLoaded.format, baseURL)
    }

    init(filterName: String, filterValue: String, resultCount: Int, resultID: String? = nil) {
        self.filterName = filterName
        self.filterValue = filterValue
        self.resultCount = resultCount
        self.resultID = resultID
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpBody(baseParams: [String: String]) -> Data? {
        var dict = [
            "filterName": self.filterName,
            "filterValue": self.filterValue,
            "resultCount": String(self.resultCount)
        ]
        if self.resultID != nil {
            dict["resultID"] = self.resultID
        }

        dict.merge(baseParams) { current, _ in current }
        return try? JSONEncoder().encode(dict)
    }
}
