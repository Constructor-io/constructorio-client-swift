//
//  CIOTrackSessionStartData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track session start
 */
struct CIOTrackSessionStartData: CIORequestData {
    let session: Int

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackSessionStart.format, baseURL)
    }

    init(session: Int) {
        self.session = session
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
    }
}
