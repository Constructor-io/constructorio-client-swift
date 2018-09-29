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
public class ConstructorIO: AbstractConstructorDataSource, CIOTracker, CIOSessionManagerDelegate {
    
    public let config: AutocompleteConfig

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

    /**
     Tracking property that simplifies tracking events. To fully customize the data that's being sent, use ConstructorIO's CIOTracker protocol functions.
     */
    public private(set) var tracking: CIOTracking!

    public init(config: AutocompleteConfig) {
        self.config = config

        self.clientID = DependencyContainer.sharedInstance.clientIDGenerator().generateID()
        self.sessionManager = DependencyContainer.sharedInstance.sessionManager()
        self.parser = DependencyContainer.sharedInstance.responseParser()
        self.networkClient = DependencyContainer.sharedInstance.networkClient()

        self.tracking = CIOTracking(tracker: self)
        
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
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackInputFocus(for tracker: CIOTrackInputFocusData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildRequest(data: tracker)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track a user select on any autocomplete result item.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackAutocompleteSelect(for tracker: CIOTrackAutocompleteSelectData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildRequest(data: tracker)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track a search event when the user taps on Search button on keyboard or when an item in the list is tapped on.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchSubmit(for tracker: CIOTrackSearchSubmitData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildRequest(data: tracker)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track search results loaded.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultsLoaded(for tracker: CIOTrackSearchResultsLoadedData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildRequest(data: tracker)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track search result clicked on.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultClick(for tracker: CIOTrackSearchResultClickData, completionHandler: TrackingCompletionHandler?) {
        var trackData: HasDefaultSectionName = tracker
        self.attachDefaultSectionNameIfNeeded(&trackData)
        let request = self.buildRequest(data: trackData as! CIOTrackSearchResultClickData)
        execute(request, completionHandler: completionHandler)
    }

    /// Track a conversion.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackConversion(for tracker: CIOTrackConversionData, completionHandler: TrackingCompletionHandler? = nil) {
        var trackData: HasDefaultSectionName = tracker
        self.attachDefaultSectionNameIfNeeded(&trackData)
        let request = self.buildRequest(data: trackData as! CIOTrackConversionData)
        execute(request, completionHandler: completionHandler)
    }
    
    private func trackSessionStart(session: Int, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildSessionStartRequest(session: session)
        execute(request, completionHandler: completionHandler)
    }
    
    private func buildRequest(data: CIORequestData) -> URLRequest{
        let requestBuilder = RequestBuilder(autocompleteKey: self.config.autocompleteKey)
        self.attachClientSessionAndClientID(requestBuilder: requestBuilder)
        requestBuilder.build(trackData: data)
        
        return requestBuilder.getRequest()
    }
    
    private func buildSessionStartRequest(session: Int) -> URLRequest{
        let data = CIOTrackSessionStartData(session: session)
        let requestBuilder = RequestBuilder(autocompleteKey: self.config.autocompleteKey)
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
    
    private func attachDefaultSectionNameIfNeeded(_ obj: inout HasDefaultSectionName){
        if obj.sectionName == nil{
            obj.sectionName = self.defaultItemSectionName
        }
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
