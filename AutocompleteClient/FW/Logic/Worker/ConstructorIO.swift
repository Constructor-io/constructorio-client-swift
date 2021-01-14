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
public typealias BrowseQueryCompletionHandler = (BrowseTaskResponse) -> Void
public typealias TrackingCompletionHandler = (TrackingTaskResponse) -> Void

/**
 The main class to be used for getting autocomplete results and tracking behavioural data.
 */
public class ConstructorIO: CIOSessionManagerDelegate {

    public let config: ConstructorIOConfig

    public static var logger: CIOLogger = CIOPrintLogger()

    private let networkClient: NetworkClient

    public var sessionManager: SessionManager

    public let clientID: String?

    public var userID: String?

    var autocompleteParser: AbstractAutocompleteResponseParser = DependencyContainer.sharedInstance.autocompleteResponseParser()
    var searchParser: AbstractSearchResponseParser = DependencyContainer.sharedInstance.searchResponseParser()
    var browseParser: AbstractBrowseResponseParser = DependencyContainer.sharedInstance.browseResponseParser()

    public var sessionID: Int {
        get {
            return self.sessionManager.getSessionWithIncrement()
        }
    }

    public init(config: ConstructorIOConfig) {
        self.config = config

        self.clientID = DependencyContainer.sharedInstance.clientIDGenerator().generateID()
        self.sessionManager = DependencyContainer.sharedInstance.sessionManager()
        self.networkClient = DependencyContainer.sharedInstance.networkClient()

        self.sessionManager.delegate = self
        self.sessionManager.setup()
    }

    /// Get autocomplete suggestions for a query.
    ///
    /// - Parameters:
    ///   - query: The query object, consisting of the query to autocomplete and additional options.
    ///   - completionHandler: The callback to execute on completion.
    public func autocomplete(forQuery query: CIOAutocompleteQuery, completionHandler: @escaping AutocompleteQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeAutocomplete(request, completionHandler: completionHandler)
    }

    /// Get search results for a query.
    ///
    /// - Parameters:
    ///   - query: The query object, consisting of the query to autocomplete and additional options.
    ///   - completionHandler: The callback to execute on completion.
    public func search(forQuery query: CIOSearchQuery, completionHandler: @escaping SearchQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeSearch(request, completionHandler: completionHandler)
    }

    /// Get browse results for a query.
    ///
    /// - Parameters:
    ///   - query: The query object, consisting of the query to autocomplete and additional options.
    ///   - completionHandler: The callback to execute on completion.
    public func browse(forQuery query: CIOBrowseQuery, completionHandler: @escaping BrowseQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeBrowse(request, completionHandler: completionHandler)
    }

    /// Track input focus.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user selected
    ///   - completionHandler: The callback to execute on completion.
    public func trackInputFocus(searchTerm: String, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackInputFocusData(searchTerm: searchTerm)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track a user select on any autocomplete result item.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user selected
    ///   - originalQuery: The original query that the user searched for
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - group: Item group
    ///   - completionHandler: The callback to execute on completion.
    public func trackAutocompleteSelect(searchTerm: String, originalQuery: String, sectionName: String, group: CIOGroup? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackAutocompleteSelectData(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName, group: group, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track a search event when the user taps on Search button on keyboard or when an item in the list is tapped on.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user searched for
    ///   - originalQuery: The original query that the user search for
    ///   - group: Item group
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchSubmit(searchTerm: String, originalQuery: String, group: CIOGroup? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: group)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track search results loaded.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user searched for
    ///   - resultCount: Number of results loaded
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultsLoaded(searchTerm: String, resultCount: Int, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount )
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track search result clicked on.
    ///
    /// - Parameters:
    ///   - name: item name.
    ///   - customerID: customer ID.
    ///   - searchTerm: Search term that the user searched for. If nil is passed, 'TERM_UNKNOWN' will be sent to the server.
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultClick(itemName: String, customerID: String, searchTerm: String? = nil, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let term = searchTerm == nil ? "TERM_UNKNOWN" : (searchTerm!.isEmpty) ? "TERM_UNKNOWN" : searchTerm
        let data = CIOTrackSearchResultClickData(searchTerm: term!, itemName: itemName, customerID: customerID, sectionName: section, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track search results loaded.
    ///
    /// - Parameters:
    ///   - filterName: Primary filter name that the user browsed for
    ///   - filterValue: Primary filter value that the user browsed for
    ///   - resultCount: Number of results loaded
    ///   - resultID: Identifier of result set
    ///   - completionHandler: The callback to execute on completion.
    public func trackBrowseResultsLoaded(filterName: String, filterValue: String, resultCount: Int, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track search result clicked on.
    ///
    /// - Parameters:
    ///   - customerID: customer ID.
    ///   - filterName: Primary filter name that the user browsed for
    ///   - filterValue: Primary filter value that the user browsed for
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - resultID: Identifier of result set
    ///   - completionHandler: The callback to execute on completion.
    public func trackBrowseResultClick(customerID: String, filterName: String, filterValue: String, resultPositionOnPage: Int?, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackBrowseResultClickData(filterName: filterName, filterValue: filterValue, customerID: customerID, resultPositionOnPage: resultPositionOnPage, sectionName: section, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
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
    public func trackConversion(itemName: String, customerID: String, revenue: Double?, searchTerm: String? = nil, sectionName: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let term = searchTerm == nil ? "TERM_UNKNOWN" : (searchTerm!.isEmpty) ? "TERM_UNKNOWN" : searchTerm
        let data = CIOTrackConversionData(searchTerm: term!, itemName: itemName, customerID: customerID, sectionName: section, revenue: revenue)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track a purchase.
    ///
    /// - Parameters:
    ///   - customerIDs: customer IDs.
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - completionHandler: The callback to execute on completion.
    public func trackPurchase(customerIDs: [String], sectionName: String? = nil, revenue: Double? = nil, orderID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackPurchaseData(customerIDs: customerIDs, sectionName: section, revenue: revenue, orderID: orderID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    private func trackSessionStart(session: Int, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildSessionStartRequest(session: session)
        executeTracking(request, completionHandler: completionHandler)
    }

    private func buildRequest(data: CIORequestData) -> URLRequest {
        let requestBuilder = RequestBuilder(apiKey: self.config.apiKey, baseURL: self.config.baseURL ?? Constants.Query.baseURLString)
        self.attachClientID(requestBuilder: requestBuilder)
        self.attachUserID(requestBuilder: requestBuilder)
        self.attachSessionIDWithIncrement(requestBuilder: requestBuilder)
        self.attachABTestCells(requestBuilder: requestBuilder)
        requestBuilder.build(trackData: data)
        return requestBuilder.getRequest()
    }

    private func buildSessionStartRequest(session: Int) -> URLRequest {
        let data = CIOTrackSessionStartData(session: session)
        let requestBuilder = RequestBuilder(apiKey: self.config.apiKey, baseURL: self.config.baseURL ?? Constants.Query.baseURLString)
        self.attachClientID(requestBuilder: requestBuilder)
        self.attachUserID(requestBuilder: requestBuilder)
        self.attachSessionIDWithoutIncrement(requestBuilder: requestBuilder)
        self.attachABTestCells(requestBuilder: requestBuilder)
        requestBuilder.build(trackData: data)
        return requestBuilder.getRequest()
    }

    private func attachClientSessionAndClientID(requestBuilder: RequestBuilder) {
        self.attachClientID(requestBuilder: requestBuilder)
        self.attachSessionIDWithIncrement(requestBuilder: requestBuilder)
    }

    private func attachABTestCells(requestBuilder: RequestBuilder) {
        self.config.testCells?.forEach({ [unowned requestBuilder] (cell) in
            requestBuilder.set(testCellKey: cell.key, testCellValue: cell.value)
        })
    }

    private func attachUserID(requestBuilder: RequestBuilder) {
        if let uid = self.userID {
            requestBuilder.set(userID: uid)
        }
    }

    private func attachClientID(requestBuilder: RequestBuilder) {
        if let cID = self.clientID {
            requestBuilder.set(clientID: cID)
        }
    }

    private func attachSessionIDWithIncrement(requestBuilder: RequestBuilder) {
        requestBuilder.set(session: self.sessionManager.getSessionWithIncrement())
    }

    private func attachSessionIDWithoutIncrement(requestBuilder: RequestBuilder) {
        requestBuilder.set(session: self.sessionManager.getSessionWithoutIncrement())
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

    private func executeBrowse(_ request: URLRequest, completionHandler: @escaping BrowseQueryCompletionHandler) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }

        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(BrowseTaskResponse(error: error))
                return
            }

            let data = response.data!
            do {
                let parsedResponse = try self.parseBrowse(data)
                dispatchHandlerOnMainQueue(BrowseTaskResponse(data: parsedResponse))
            } catch {
                dispatchHandlerOnMainQueue(BrowseTaskResponse(error: error))
            }
        }
    }

    private func executeTracking(_ request: URLRequest, completionHandler: TrackingCompletionHandler?) {
        let dispatchHandlerOnMainQueue = { error in
            DispatchQueue.main.async {
                completionHandler?(error)
            }
        }

        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(TrackingTaskResponse(error: error))
                return
            }
            
            let data = response.data!
            dispatchHandlerOnMainQueue(TrackingTaskResponse(data: data))
        }
    }

    private func parseAutocomplete(_ autocompleteResponseData: Data) throws -> CIOAutocompleteResponse {
        return try self.autocompleteParser.parse(autocompleteResponseData: autocompleteResponseData)
    }

    private func parseSearch(_ searchResponseData: Data) throws -> CIOSearchResponse {
        return try self.searchParser.parse(searchResponseData: searchResponseData)
    }

    private func parseBrowse(_ browseResponseData: Data) throws -> CIOBrowseResponse {
        return try self.browseParser.parse(browseResponseData: browseResponseData)
    }

    // MARK: CIOSessionManagerDelegate

    public func sessionDidChange(from: Int, to: Int) {
        self.trackSessionStart(session: to)
    }

}
