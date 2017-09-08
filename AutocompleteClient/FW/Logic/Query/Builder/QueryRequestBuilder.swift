//
//  QueryRequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class QueryRequestBuilder: RequestBuilder {

    var query = ""

    init(query: String, autocompleteKey: String) {
        super.init(autocompleteKey: autocompleteKey)
        set(query: query)
    }

    func set(query: String) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
    }

    func getQueryPathString() -> String {
        fatalError("Override this in the subclass to return the path string for the query request!")
    }

    override func getURLString() -> String {
        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString,
                      getQueryPathString(), query)
    }
}
