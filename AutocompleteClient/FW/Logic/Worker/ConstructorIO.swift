//
//  ConstructorIO.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias AutocompleteQueryCompletionHandler = (AutocompleteTaskResponse) -> Void
public typealias SearchQueryCompletionHandler = (SearchTaskResponse) -> Void
public typealias TrackingCompletionHandler = (Error?) -> Void

/**
 The main class to be used for getting autocomplete results and tracking behavioural data.
 */
public class ConstructorIO: AbstractConstructorDataSource, CIOTracker, CIOSessionManagerDelegate {

    public let config: AutocompleteConfig

    public static var logger: CIOLogger = CIOPrintLogger()
    
    private let networkClient: NetworkClient
    private let sessionManager: SessionManager
    
<<<<<<< HEAD
    public var parser: AbstractResponseParser
    
    public let clientID: String?
=======
    public var autocompleteParser: AbstractAutocompleteResponseParser = DependencyContainer.sharedInstance.autocompleteResponseParser()
    public var searchParser: AbstractSearchResponseParser = DependencyContainer.sharedInstance.searchResponseParser()
>>>>>>> 9629388ab390297b07e997cc8e4a18eb93aba86b
    
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
<<<<<<< HEAD


    public init(config: AutocompleteConfig) {
        self.config = config

        self.clientID = DependencyContainer.sharedInstance.clientIDGenerator().generateID()
        self.sessionManager = DependencyContainer.sharedInstance.sessionManager()
        self.parser = DependencyContainer.sharedInstance.responseParser()
        self.networkClient = DependencyContainer.sharedInstance.networkClient()

=======
    
    public init(config: AutocompleteConfig) {
        self.config = config
        
>>>>>>> 9629388ab390297b07e997cc8e4a18eb93aba86b
        self.tracking = CIOTracking(tracker: self)
        
        self.sessionManager.delegate = self
    }

    /// Get autocomplete suggestions for a query.
    ///
    /// - Parameters:
    ///   - query: The query object, consisting of the query to autocomplete and additional options.
    ///   - completionHandler: The callback to execute on completion.
<<<<<<< HEAD
    public func autocomplete(forQuery query: CIOAutocompleteQuery, completionHandler: @escaping QueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        execute(request, completionHandler: completionHandler)
=======
    public func autocomplete(forQuery query: CIOAutocompleteQuery, completionHandler: @escaping AutocompleteQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeAutocomplete(request, completionHandler: completionHandler)
    }
    
    public func search(forQuery query: CIOSearchQuery, completionHandler: @escaping SearchQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeSearch(request, completionHandler: completionHandler)
>>>>>>> 9629388ab390297b07e997cc8e4a18eb93aba86b
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
    
    /// Track a user click on any autocomplete result item.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackAutocompleteClick(for tracker: CIOTrackAutocompleteClickData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildRequest(data: tracker)
        execute(request, completionHandler: completionHandler)
    }

    /// Track a conversion.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackConversion(for tracker: CIOTrackConversionData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildRequest(data: tracker)
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

    private func trackSessionStart(session: Int, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildSessionStartRequest(session: session)
        execute(request, completionHandler: completionHandler)
    }
    
    /// Track a search event when the user taps on Search button on keyboard or when an item in the list is tapped on.
    ///
    /// - Parameters:
    ///   - tracker: The object containing the necessary and additional tracking parameters.
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearch(for tracker: CIOTrackSearchData, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildRequest(data: tracker)
        execute(request, completionHandler: completionHandler)
    }

    private func buildRequest(data: CIORequestData) -> URLRequest{
        let requestBuilder = RequestBuilder(autocompleteKey: self.config.autocompleteKey)
        self.attachClientSessionAndClientID(requestBuilder: requestBuilder)
<<<<<<< HEAD
=======
        self.attachABTestCells(requestBuilder: requestBuilder)
        requestBuilder.build(trackData: data)
        
        return requestBuilder.getRequest()
    }
    
    private func buildSessionStartRequest(session: Int) -> URLRequest{
        let data = CIOTrackSessionStartData(session: session)
        let requestBuilder = RequestBuilder(autocompleteKey: self.config.autocompleteKey)
        self.attachClientID(requestBuilder: requestBuilder)
        self.attachABTestCells(requestBuilder: requestBuilder)
>>>>>>> 9629388ab390297b07e997cc8e4a18eb93aba86b
        requestBuilder.build(trackData: data)
        
        return requestBuilder.getRequest()
    }
    
<<<<<<< HEAD
    private func buildSessionStartRequest(session: Int) -> URLRequest{
        let data = CIOTrackSessionStartData(session: session)
        let requestBuilder = RequestBuilder(autocompleteKey: self.config.autocompleteKey)
        self.attachClientID(requestBuilder: requestBuilder)
        requestBuilder.build(trackData: data)
        
        return requestBuilder.getRequest()
    }

<<<<<<< HEAD
    private func buildRequest(fromQuery query: CIOAutocompleteQuery) -> URLRequest {
        let requestBuilder = AutocompleteQueryRequestBuilder(query: query, autocompleteKey: self.config.autocompleteKey, session: self.sessionManager.getSession(), clientID: self.clientID )
        self.attachClientSessionAndClientID(requestBuilder: requestBuilder)
        
        return requestBuilder.getRequest()
=======
    private func attachClientSessionAndClientID(requestBuilder: RequestBuilder){
        self.attachClientID(requestBuilder: requestBuilder)
        self.attachSessionID(requestBuilder: requestBuilder)
>>>>>>> Request flow refactored
=======
    private func attachABTestCells(requestBuilder: RequestBuilder){
        self.config.testCells?.forEach({ [unowned requestBuilder] (cell) in
            requestBuilder.set(cell.value, forKey: Constants.ABTesting.formatKey(cell.key))
        })
    }

    private func attachClientSessionAndClientID(requestBuilder: RequestBuilder){
        self.attachClientID(requestBuilder: requestBuilder)
        self.attachSessionID(requestBuilder: requestBuilder)
>>>>>>> 9629388ab390297b07e997cc8e4a18eb93aba86b
    }
    
    private func attachClientID(requestBuilder: RequestBuilder){
        if let cID = self.config.clientID{
            requestBuilder.set(clientID: cID)
        }
    }
    
    private func attachSessionID(requestBuilder: RequestBuilder){
        requestBuilder.set(session: self.sessionManager.getSession())
    }
    
    private func attachDefaultSectionNameIfNeeded(_ obj: inout HasSectionName){
        if obj.sectionName == nil{
            obj.sectionName = self.defaultItemSectionName
        }
    }

    private func executeAutocomplete(_ request: URLRequest, completionHandler: @escaping AutocompleteQueryCompletionHandler) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }

        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(AutocompleteTaskResponse(error: error))
                return
            }

            let data = response.data!
            do {
                let parsedResponse = try self.parseAutocomplete(data)
                dispatchHandlerOnMainQueue(AutocompleteTaskResponse(data: parsedResponse))
            } catch {
                dispatchHandlerOnMainQueue(AutocompleteTaskResponse(error: error))
            }
        }
    }
    
    private func executeSearch(_ request: URLRequest, completionHandler: @escaping SearchQueryCompletionHandler) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }
        
        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(SearchTaskResponse(error: error))
                return
            }
            
            let data = response.data!
            do {
                let parsedResponse = try self.parseSearch(data)
                dispatchHandlerOnMainQueue(SearchTaskResponse(data: parsedResponse))
            } catch {
                dispatchHandlerOnMainQueue(SearchTaskResponse(error: error))
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
    
    private func parseAutocomplete(_ autocompleteResponseData: Data) throws -> CIOAutocompleteResponse {
        return try self.autocompleteParser.parse(autocompleteResponseData: autocompleteResponseData)
    }
    
    private func parseSearch(_ searchResponseData: Data) throws -> CIOSearchResponse{
        return try self.searchParser.parse(searchResponseData: searchResponseData)
    }
    
    // MARK: CIOSessionManagerDelegate
    
    public func sessionDidChange(from: Int, to: Int){
        self.trackSessionStart(session: to)
    }

}
