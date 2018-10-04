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
public class ConstructorIO: CIOSessionManagerDelegate {
    
    public let config: ConstructorIOConfig

    public static var logger: CIOLogger = CIOPrintLogger()
    
    private let networkClient: NetworkClient
    private let sessionManager: SessionManager
    
    public var parser: AbstractResponseParser
    
    public let clientID: String?
    
    public var sessionID: Int{
        get{
            return self.sessionManager.getSession()
        }
    }

    private var itemSectionName: String?
    var defaultItemSectionName: String{
        get{
            return self.itemSectionName ?? Constants.Track.defaultItemSectionName
        }
        set{
            self.itemSectionName = newValue
        }
    }

    public init(config: ConstructorIOConfig) {
        self.config = config

        self.clientID = DependencyContainer.sharedInstance.clientIDGenerator().generateID()
        self.sessionManager = DependencyContainer.sharedInstance.sessionManager()
        self.parser = DependencyContainer.sharedInstance.responseParser()
        self.networkClient = DependencyContainer.sharedInstance.networkClient()
        self.sessionManager.delegate = self
    }

    /// Get autocomplete suggestions for a query.
    ///
    /// - Parameters:
    ///   - query: The query object, consisting of the query to autocomplete and additional options.
    ///   - completionHandler: The callback to execute on completion.
    public func autocomplete(forQuery query: CIOAutocompleteQuery, completionHandler: @escaping QueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track input focus.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user selected
    ///   - completionHandler: The callback to execute on completion.
    public func trackInputFocus(searchTerm: String, completionHandler: TrackingCompletionHandler? = nil){
        let data = CIOTrackInputFocusData(searchTerm: searchTerm)
        let request = self.buildRequest(data: data)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track a user select on any autocomplete result item.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user selected
    ///   - originalQuery: The original query that the user searched for
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - group: Item group
    ///   - completionHandler: The callback to execute on completion.
    public func trackAutocompleteSelect(searchTerm: String, originalQuery: String, sectionName: String? = nil, group: CIOGroup? = nil, completionHandler: TrackingCompletionHandler? = nil){
        let section = sectionName ?? self.config.defaultSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackAutocompleteSelectData(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: section, group: group)
        let request = self.buildRequest(data: data)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track a search event when the user taps on Search button on keyboard or when an item in the list is tapped on.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user searched for
    ///   - originalQuery: The original query that the user search for
    ///   - group: Item group
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchSubmit(searchTerm: String, originalQuery: String, group: CIOGroup? = nil, completionHandler: TrackingCompletionHandler? = nil){
        let data = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: group)
        let request = self.buildRequest(data: data)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track search results loaded.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user searched for
    ///   - resultCount: Number of results loaded
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultsLoaded(searchTerm: String, resultCount: Int, completionHandler: TrackingCompletionHandler? = nil){
        let data = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount )
        let request = self.buildRequest(data: data)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track search result clicked on.
    ///
    /// - Parameters:
    ///   - name: item name.
    ///   - customerID: customer ID.
    ///   - searchTerm: Search term that the user searched for. If nil is passed, 'TERM_UNKNOWN' will be sent to the server.
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultClick(itemName: String, customerID: String, searchTerm: String?, sectionName: String? = nil, completionHandler: TrackingCompletionHandler? = nil){
        let section = sectionName ?? self.config.defaultSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackSearchResultClickData(searchTerm: (searchTerm ?? "TERM_UNKNOWN"), itemName: itemName, customerID: customerID, sectionName: section)
        let request = self.buildRequest(data: data)
        execute(request, completionHandler: completionHandler)
    }

    /// Track a conversion.
    ///
    /// - Parameters:
    ///   - name: item name.
    ///   - customerID: customer ID.
    ///   - revenue: Revenue of an item.
    ///   - searchTerm: Search term that the user searched for. If nil is passed, 'TERM_UNKNOWN' will be sent to the server.
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - completionHandler: The callback to execute on completion.
    public func trackConversion(itemName: String, customerID: String, revenue: Double?, searchTerm: String?, sectionName: String? = nil, completionHandler: TrackingCompletionHandler? = nil){
        let section = sectionName ?? self.config.defaultSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackConversionData(searchTerm: (searchTerm ?? "TERM_UNKNOWN"), itemName: itemName, customerID: customerID, sectionName: section, revenue: revenue)
        let request = self.buildRequest(data: data)
        execute(request, completionHandler: completionHandler)
    }
    
    private func trackSessionStart(session: Int, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildSessionStartRequest(session: session)
        execute(request, completionHandler: completionHandler)
    }
    
    private func buildRequest(data: CIORequestData) -> URLRequest{
        let requestBuilder = RequestBuilder(apiKey: self.config.apiKey)
        self.attachClientSessionAndClientID(requestBuilder: requestBuilder)
        requestBuilder.build(trackData: data)
        
        return requestBuilder.getRequest()
    }
    
    private func buildSessionStartRequest(session: Int) -> URLRequest{
        let data = CIOTrackSessionStartData(session: session)
        let requestBuilder = RequestBuilder(apiKey: self.config.apiKey)
        self.attachClientID(requestBuilder: requestBuilder)
        requestBuilder.build(trackData: data)
        
        return requestBuilder.getRequest()
    }
    
    private func attachClientSessionAndClientID(requestBuilder: RequestBuilder){
        self.attachClientID(requestBuilder: requestBuilder)
        self.attachSessionID(requestBuilder: requestBuilder)
    }
    
    private func attachClientID(requestBuilder: RequestBuilder){
        if let cID = self.clientID{
            requestBuilder.set(clientID: cID)
        }
    }
    
    private func attachSessionID(requestBuilder: RequestBuilder){
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
    
    private func parse(_ autocompleteResponseData: Data) throws -> CIOAutocompleteResponse {
        return try self.parser.parse(autocompleteResponseData: autocompleteResponseData)
    }
    
    // MARK: CIOSessionManagerDelegate
    
    public func sessionDidChange(from: Int, to: Int){
        self.trackSessionStart(session: to)
    }
    
}
