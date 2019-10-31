//
//  CIORecommendationsQuery.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIORecommendationsQuery: CIORequestData {
    public let maximumNumberOfResult: Int
    public let pod: String
    public let itemID: String
    
    func url(with baseURL: String) -> String {
        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString, Constants.Recommendations.recommendationsPathComponent,
                      self.pod)
    }

    public init(pod: String, itemID: String, maximumNumberOfResult: Int) {
        self.pod = pod
        self.itemID = itemID
        self.maximumNumberOfResult = maximumNumberOfResult
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.maximumNumberOfResult)
        requestBuilder.set(itemID: self.itemID)
    }
}
