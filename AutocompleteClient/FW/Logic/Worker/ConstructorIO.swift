//
//  ConstructorIO.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias QueryCompletionHandler = (QueryResponse) -> Void
public typealias TrackingCompletionHandler = (Error?) -> Void

/**
 The main class to be used for getting autocomplete results and tracking behavioural data.
 */
public class ConstructorIO: AbstractConstructorDataSource, CIOTracker {

    public let autocompleteKey: String

    public static var logger: CIOLogger = CIOPrintLogger()
    
    private let networkClient: NetworkClient = DependencyContainer.sharedInstance.networkClient()
    private let sessionManager: SessionManager = DependencyContainer.sharedInstance.sessionManager()
    
    public var parser: AbstractResponseParser = DependencyContainer.sharedInstance.responseParser()
    
    let clientID: String?
    
    /**
     Tracking property that simplifies tracking events. To fully customize the data that's being sent, use ConstructorIO's CIOTracker protocol functions.
     */
    public private(set) var tracking: CIOTracking!
    
    public init(autocompleteKey: String, clientID: String?) {
        self.autocompleteKey = autocompleteKey
        self.clientID = clientID
        
        self.tracking = CIOTracking(tracker: self)
    }

    /// Get autocomplete suggestions for a query.
    ///
    /// - Parameters:
    ///   - query: The query object, consisting of the query to autocomplete and additional options.
    ///   - completionHandler: The callback to execute on completion.
    public func autocomplete(forQuery query: CIOAutocompleteQuery, completionHandler: @escaping QueryCompletionHandler) {
        let request = buildRequest(fromQuery: query)
        execute(request, completionHandler: completionHandler)

    }
    
    /// Track search results loaded.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultsLoaded(for tracker: CIOSearchResultsLoadedTrackData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = buildRequest(fromTracker: tracker)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track a user click on any autocomplete result item.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackAutocompleteClick(for tracker: CIOAutocompleteClickTrackData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = buildRequest(fromTracker: tracker)
        execute(request, completionHandler: completionHandler)
    }

    /// Track a conversion.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackConversion(for tracker: CIOConversionTrackData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = buildRequest(fromTracker: tracker)
        execute(request, completionHandler: completionHandler)
    }

    /// Track a search event when the user taps on Search button on keyboard or when an item in the list is tapped on.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearch(for tracker: CIOSearchTrackData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = buildRequest(fromTracker: tracker)
        execute(request, completionHandler: completionHandler)
    }
    
    private func buildRequest(fromTracker tracker: CIOSearchResultsLoadedTrackData) -> URLRequest{
        let requestBuilder = TrackSearchResultsLoadedRequestBuilder(tracker: tracker, autocompleteKey: self.autocompleteKey)
        self.attachClientSessionAndClientID(requestBuilder: requestBuilder)
        return requestBuilder.getRequest()
    }
    
    private func buildRequest(fromTracker tracker: CIOSearchTrackData) -> URLRequest{
        let requestBuilder = TrackSearchRequestBuilder(trackData: tracker, autocompleteKey: self.autocompleteKey)
        self.attachClientSessionAndClientID(requestBuilder: requestBuilder)
        return requestBuilder.getRequest()
    }
    
    private func buildRequest(fromTracker tracker: CIOConversionTrackData) -> URLRequest {
        let requestBuilder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: self.autocompleteKey)
        return requestBuilder.getRequest()
    }

    private func buildRequest(fromTracker tracker: CIOAutocompleteClickTrackData) -> URLRequest {
        let requestBuilder = TrackAutocompleteClickRequestBuilder(tracker: tracker, autocompleteKey: self.autocompleteKey)
        return requestBuilder.getRequest()
    }

    private func buildRequest(fromQuery query: CIOAutocompleteQuery) -> URLRequest {
        let requestBuilder = AutocompleteQueryRequestBuilder(query: query, autocompleteKey: self.autocompleteKey, session: self.sessionManager.getSession(), clientID: self.clientID )
        self.attachClientSessionAndClientID(requestBuilder: requestBuilder)
        
        return requestBuilder.getRequest()
    }
    
    private func attachClientSessionAndClientID(requestBuilder: RequestBuilder){
        if let cID = self.clientID{
            requestBuilder.set(clientID: cID)
        }
        requestBuilder.set(session: self.sessionManager.getSession())
    }

    private func execute(_ request: URLRequest, completionHandler: @escaping QueryCompletionHandler) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }

        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(QueryResponse(error: error))
                return
            }

            let data = response.data!
            do {
                let parsedResponse = try self.parse(data)
                dispatchHandlerOnMainQueue(QueryResponse(data: parsedResponse))
            } catch {
                dispatchHandlerOnMainQueue(QueryResponse(error: error))
            }
        }
    }

    private func execute(_ request: URLRequest, completionHandler: TrackingCompletionHandler?) {
        let dispatchHandlerOnMainQueue = { error in
            DispatchQueue.main.async {
                completionHandler?(error)
            }
        }

        self.networkClient.execute(request) { response in
            dispatchHandlerOnMainQueue(response.error)
        }
    }

    private func parse(_ autocompleteResponseData: Data) throws -> CIOResponse {
        return try self.parser.parse(autocompleteResponseData: autocompleteResponseData)
    }

}
