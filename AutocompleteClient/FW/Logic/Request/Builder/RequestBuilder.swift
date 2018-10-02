//
//  RequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class RequestBuilder {

    var queryItems = QueryItemCollection()
    var dateProvider: DateProvider
    
    internal(set) var trackData: CIORequestData!
    
    internal(set) var searchTerm = ""
    
    init(apiKey: String, dateProvider: DateProvider = CurrentTimeDateProvider()) {
        self.dateProvider = dateProvider
        self.set(apiKey: apiKey)
    }

    // There is no need to encode query parameters. Not sure about those in the URL path string.
    func set(apiKey: String) {
        queryItems.add(URLQueryItem(name: Constants.Query.apiKey, value: apiKey))
    }
    
    func set(clientID: String){
        queryItems.add(URLQueryItem(name: "i", value: clientID))
    }
    
    func set(session: Int){
        queryItems.add(URLQueryItem(name: "s", value: String(session)))
    }
    
    final func build(trackData: CIORequestData){
        self.trackData = trackData
        trackData.decorateRequest(requestBuilder: self)
    }

    final func getRequest() -> URLRequest {
        let urlString = self.trackData!.url

        var urlComponents = URLComponents(string: urlString)!

        // create array copy, so the version string is added only once even if we can call this method multiple times
        var allQueryItems = self.queryItems

        // add version string
        let versionString = Constants.versionString()
        allQueryItems.add(URLQueryItem(name: "c", value: versionString))
        
        // attach date
        self.addDateQueryItem(queryItems: &allQueryItems)

        // attach `action` if necessary from base url
        if (urlComponents.queryItems != nil) {
            allQueryItems.add((urlComponents.queryItems?.first)!)
        }

        urlComponents.queryItems = allQueryItems.all()

        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = self.trackData!.httpMethod()
        
        return request
    }
    
    private func addDateQueryItem(queryItems items: inout QueryItemCollection){
        let dateString = String(Int(self.dateProvider.provideDate().timeIntervalSince1970 * 1000))
        items.add(URLQueryItem(name: Constants.Track.dateTime, value: dateString))
    }
}