//
//  CIOBrowseQuery.swift
//  ConstructorAutocomplete
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOBrowseQuery: CIORequestData {

    fileprivate let primaryFacet: FacetParameter
    fileprivate let otherFacets: [FacetParameter]

    func url(with baseURL: String) -> String {
        let encodedKey = primaryFacet.name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? primaryFacet.name
        let encodedValue = primaryFacet.value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? primaryFacet.value

        return String(format: Constants.Query.queryStringFormat, baseURL,
                      "\(Constants.BrowseQuery.pathString)/\(encodedKey)", encodedValue)
    }

    public init(primaryFacet: FacetParameter, otherFacets: [FacetParameter]? = nil) {
        self.primaryFacet = primaryFacet
        self.otherFacets = otherFacets ?? []
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        for facet in self.otherFacets {
            requestBuilder.set(facet.value, forKey: facet.name)
        }
    }
}
