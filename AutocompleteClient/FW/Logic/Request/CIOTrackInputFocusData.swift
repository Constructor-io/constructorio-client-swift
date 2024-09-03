//
//  CIOTrackInputFocusData.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track search bar focus
 */
struct CIOTrackInputFocusData: CIORequestData {
    let searchTerm: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackInputFocus.format, baseURL)
    }

    init(searchTerm: String?) {
        self.searchTerm = searchTerm
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        if let term = self.searchTerm {
            requestBuilder.set(searchTerm: term)
        }
    }
}
