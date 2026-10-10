//
//  CIORecommendationsResponse.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the recommendations data response from the server.
 */
public struct CIORecommendationsResponse {
    /**
     Pod information
     */
    public let pod: CIORecommendationsPod

    /**
     List of results returned for the recommendations query
     */
    public let results: [CIOResult]

    /**
     Total number of results for the query
     */
    public let totalNumResults: Int

    /**
     Result ID of the result set returned
     */
    public let resultID: String
    
    /**
     Request object used to retrieve the Recommendations Response
     */
    public var request: JSONObject
}


/**
 Struct representing a recommendation page response from the server.
 `resultID` identifies the page request and is not a tracking id: send each pod's own `resultID` with that pod's tracking events.
 */
public struct CIORecommendationPageResponse {
    /**
     The page ID
     */
    public let pageID: String

    /**
     The page display name
     */
    public let displayName: String?

    /**
     The page type
     */
    public let pageType: String?

    /**
     The pods, in the page's configured order
     */
    public let pods: [CIORecommendationPagePod]

    /**
     ID of the page request. Not a tracking id.
     */
    public let resultID: String

    /**
     Request object used to retrieve the page
     */
    public var request: JSONObject
}

/**
 Struct representing one pod of a recommendation page response.
 */
public struct CIORecommendationPagePod {
    /**
     The pod ID
     */
    public let podID: String

    /**
     The pod's result ID. Send this with the pod's recommendation view and click events.
     */
    public let resultID: String

    /**
     The pod's results, as a single-pod recommendations response whose `resultID` is the pod's own result ID
     */
    public let response: CIORecommendationsResponse
}
