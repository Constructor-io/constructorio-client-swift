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
    var dateProvider: DateProvider
    
    init(autocompleteKey: String, dateProvider: DateProvider = CurrentTimeDateProvider()) {
        self.dateProvider = dateProvider
        self.set(autocompleteKey: autocompleteKey)
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
        
        // attach date
        self.addDateQueryItem(queryItems: &allQueryItems)
        
        urlComponents.queryItems = allQueryItems.all()

        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = getHttpMethod()
        
        return request
    }
    
    private func addDateQueryItem(queryItems items: inout QueryItemCollection){
        let dateString = String(Int(self.dateProvider.provideDate().timeIntervalSince1970 * 1000))
        items.add(URLQueryItem(name: Constants.Track.dateTime, value: dateString))
    }
}
