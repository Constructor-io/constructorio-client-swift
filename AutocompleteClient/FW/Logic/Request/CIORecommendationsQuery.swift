//
//  CIORecommendationsQuery.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIORecommendationsQuery: CIORequestData {
    public let pod: String
    public let itemIDs: [String]
    public let maximumNumberOfResult: Int
    
    func url(with baseURL: String) -> String {
        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString, Constants.Recommendations.recommendationsPathComponent,
                      self.pod)
    }

    public init(pod: String, itemIDs: [String], maximumNumberOfResult: Int) {
        self.pod = pod
        self.itemIDs = itemIDs
        self.maximumNumberOfResult = maximumNumberOfResult
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.maximumNumberOfResult)
        requestBuilder.set(itemIDs: self.itemIDs)
    }
}
