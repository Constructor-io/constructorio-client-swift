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
    let itemName: String
    let customerID: String
    var sectionName: String?
    let resultID: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackBrowseResultClick.format, baseURL)
    }

    init(filterName: String, filterValue: String, itemName: String, customerID: String, sectionName: String? = nil, resultID: String? = nil) {
        self.filterName = filterName
        self.filterValue = filterValue
        self.itemName = itemName
        self.customerID = customerID
        self.sectionName = sectionName
        self.resultID = resultID
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpBody(baseParams: [String: String]) -> Data? {
        var dict = [
            "filterName": self.filterName,
            "filterValue": self.filterValue,
            "itemName": self.itemName,
            "customerID": self.customerID
        ]
        if self.sectionName != nil {
            dict["sectionName"] = self.sectionName
        }
        if self.resultID != nil {
            dict["resultID"] = self.resultID
        }

        dict.merge(baseParams) { current, _ in current }
        return try? JSONEncoder().encode(dict)
    }
}
