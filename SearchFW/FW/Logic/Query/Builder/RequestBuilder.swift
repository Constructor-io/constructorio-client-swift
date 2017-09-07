//
//  RequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class RequestBuilder {

    var queryItems = [URLQueryItem]()

    init(autocompleteKey: String) {
        set(autocompleteKey: autocompleteKey)
    }

    // There is no need to encode query parameters. Not sure about those in the URL path string.
    func set(autocompleteKey: String) {
        queryItems.append(URLQueryItem(name: Constants.Query.autocompleteKey, value: autocompleteKey))
    }

    func getURLString() -> String {
        fatalError("Override this method in the subclass!")
    }

    func getHttpMethod() -> String {
        return "GET"
    }

    func addAdditionalQueryItems() {
        return
    }

    func getRequest() -> URLRequest {
        let urlString = getURLString()

        // TODO: Try not to force unwrap!
        var urlComponents = URLComponents(string: urlString)!
        addAdditionalQueryItems()
        urlComponents.queryItems = queryItems

        // TODO: Try not to force unwrap!
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = getHttpMethod()
        return request
    }
}
