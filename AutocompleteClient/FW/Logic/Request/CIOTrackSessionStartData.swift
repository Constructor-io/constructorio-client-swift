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
public struct CIOTrackSessionStartData: CIORequestData {
    let session: Int
    
    public var url: String {
        return String(format: Constants.TrackSessionStart.format, Constants.Track.baseURLString)
    }
    
    public init(session: Int) {
        self.session = session
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder){
    }
}
