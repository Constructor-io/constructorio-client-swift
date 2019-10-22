//
//  CIORecommendationsQuery.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public enum RecommendationsQueryType{
    case userFeatured
    case recentlyViewed
    case alternative(itemID: String)
    case complementary(itemID: String)
}

public struct CIORecommendationsQuery: CIORequestData {
    public let type: RecommendationsQueryType
    public let maximumNumberOfResult: Int
    
    func url(with baseURL: String) -> String {
        var recommendationsPathComponent: String
        
        switch self.type {
        case .userFeatured:
            recommendationsPathComponent = Constants.Recommendations.userFeaturedPathComponent
        case .recentlyViewed:
            recommendationsPathComponent = Constants.Recommendations.recentlyViewedPathComponent
        case .alternative:
            recommendationsPathComponent = Constants.Recommendations.alternativePathComponent
        case .complementary:
            recommendationsPathComponent = Constants.Recommendations.complementaryPathComponent
        }

        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString, Constants.Recommendations.recommendationsPathComponent,
                      recommendationsPathComponent)
    }

    public init(type: RecommendationsQueryType, maximumNumberOfResult: Int) {
        self.type = type
        self.maximumNumberOfResult = maximumNumberOfResult
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.maximumNumberOfResult)
        switch self.type {
        case .alternative(let itemID):
            requestBuilder.set(itemID: itemID)
        case .complementary(let itemID):
            requestBuilder.set(itemID: itemID)
        default:
            break
        }
    }
}
