//
//  RequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class RequestBuilder {

    var queryItems = QueryItemCollection()

    init(autocompleteKey: String) {
        set(autocompleteKey: autocompleteKey)
    }

    // There is no need to encode query parameters. Not sure about those in the URL path string.
    func set(autocompleteKey: String) {
        queryItems.add(URLQueryItem(name: Constants.Query.autocompleteKey, value: autocompleteKey))
    }
    
    func set(clientID: String){
        queryItems.add(URLQueryItem(name: "i", value: clientID))
    }
    
    func set(session: Int){
        queryItems.add(URLQueryItem(name: "s", value: String(session)))
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

    final func getRequest() -> URLRequest {
        let urlString = getURLString()

        var urlComponents = URLComponents(string: urlString)!
        addAdditionalQueryItems()
        
        // create array copy, so the version string is added only once even if we can call this method multiple times
        var allQueryItems = self.queryItems
        
        let versionString = Constants.versionString()
        allQueryItems.add(URLQueryItem(name: "c", value: versionString))
        
        urlComponents.queryItems = allQueryItems.all()

        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = getHttpMethod()
        
        return request
    }
}
