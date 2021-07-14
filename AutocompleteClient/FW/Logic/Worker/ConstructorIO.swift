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
public typealias RecommendationsQueryCompletionHandler = (RecommendationsTaskResponse) -> Void
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
    var recommendationsParser: AbstractRecommendationsResponseParser = DependencyContainer.sharedInstance.recommendationsResponseParser()

    public var sessionID: Int {
        get {
            return self.sessionManager.getSessionWithIncrement()
        }
    }

    /// Initializes a ConstructorIO Client
    ///
    /// - Parameters:
    ///   - config: A configuration object containing the API Key, Test Cell Information, Segments, etc.
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

    /// Get recommendation results for a query.
    ///
    /// - Parameters:
    ///   - query: The query object, consisting of the query to autocomplete and additional options.
    ///   - completionHandler: The callback to execute on completion.
    public func recommendations(forQuery query: CIORecommendationsQuery, completionHandler: @escaping RecommendationsQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeRecommendations(request, completionHandler: completionHandler)
    }

    /// Track when a user focuses on a search input element
    ///
    /// - Parameters:
    ///   - searchTerm: The pre-existing text in the search input element (if present)
    ///   - completionHandler: The callback to execute on completion.
    public func trackInputFocus(searchTerm: String, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackInputFocusData(searchTerm: searchTerm)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user selects (clicks, or navigates to via keyboard) a result that appeared within autocomplete
    ///
    /// - Parameters:
    ///   - searchTerm: The term that the user selected
    ///   - originalQuery: The current text in the input field
    ///   - sectionName: The name of the autocomplete section the term came from (usually "Search Suggestions")
    ///   - group: Item group (if present)
    ///   - resultID: Identifier of result set
    ///   - completionHandler: The callback to execute on completion.
    public func trackAutocompleteSelect(searchTerm: String, originalQuery: String, sectionName: String, group: CIOGroup? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackAutocompleteSelectData(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName, group: group, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user submits a search (pressing enter within input element, or clicking submit element)
    ///
    /// - Parameters:
    ///   - searchTerm: The term that the user searched for
    ///   - originalQuery: The current text in the input field
    ///   - group: Item group (if present)
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchSubmit(searchTerm: String, originalQuery: String, group: CIOGroup? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: group)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user loads a search product listing page
    ///
    /// - Parameters:
    ///   - searchTerm: The search term that the user searched for
    ///   - resultCount: The number of search results returned in total
    ///   - customerIDs: The list of item id's returned in the search
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultsLoaded(searchTerm: String, resultCount: Int, customerIDs: [String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount, customerIDs: customerIDs )
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user clicks a result that appeared within a search product listing page
    ///
    /// - Parameters:
    ///   - itemName: The item name.
    ///   - customerID: The item ID.
    ///   - searchTerm: The term that the user searched for (defaults to 'TERM_UNKNOWN')
    ///   - sectionName: The name of the autocomplete section the term came from (defaults to "products")
    ///   - resultID: Identifier of result set
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultClick(itemName: String, customerID: String, searchTerm: String? = nil, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let term = searchTerm == nil ? "TERM_UNKNOWN" : (searchTerm!.isEmpty) ? "TERM_UNKNOWN" : searchTerm
        let data = CIOTrackSearchResultClickData(searchTerm: term!, itemName: itemName, customerID: customerID, sectionName: section, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user loads a browse product listing page
    ///
    /// - Parameters:
    ///   - filterName: The name of the primary filter that the user browsed for (i.e "color")
    ///   - filterValue: The value of the primary filter that the user browsed for (i.e "blue")
    ///   - resultCount: The number of results returned in total
    ///   - resultID: Identifier of result set
    ///   - completionHandler: The callback to execute on completion.
    public func trackBrowseResultsLoaded(filterName: String, filterValue: String, resultCount: Int, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user clicks a result that appeared within a browse product listing page
    ///
    /// - Parameters:
    ///   - customerID: The item ID.
    ///   - filterName: The name of the primary filter that the user browsed for (i.e "color")
    ///   - filterValue: The value of the primary filter that the user browsed for (i.e "blue")
    ///   - resultPositionOnPage: The position of clicked item
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - resultID: Identifier of result set
    ///   - completionHandler: The callback to execute on completion.
    public func trackBrowseResultClick(customerID: String, filterName: String, filterValue: String, resultPositionOnPage: Int?, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackBrowseResultClickData(filterName: filterName, filterValue: filterValue, customerID: customerID, resultPositionOnPage: resultPositionOnPage, sectionName: section, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user views a pod of recommendation results
    ///
    /// - Parameters:
    ///   - podID: The pod ID
    ///   - numResultsViewed: The count of results that is visible to the user
    ///   - resultPage: The current page that recommedantion result is on
    ///   - resultCount: The total number of recommendation results
    ///   - sectionName: The name of the autocomplete section the term came from
    ///   - resultID: Identifier of result set
    ///   - completionHandler: The callback to execute on completion.
    public func trackRecommendationResultsView(podID: String, numResultsViewed: Int? = nil, resultPage: Int? = nil, resultCount: Int? = nil, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackRecommendationResultsViewData(podID: podID, numResultsViewed: numResultsViewed, resultPage: resultPage, resultCount: resultCount, sectionName: section, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user clicks an item that appeared within a list of recommended results
    ///
    /// - Parameters:
    ///   - podID: The pod ID
    ///   - strategyID: The strategy ID that fulfilled the po
    ///   - customerID: The item ID
    ///   - variationID: The item variation I
    ///   - numResultsPerPage: The count of recommendation results on each pag
    ///   - resultPage: The current page that recommedantion result is on
    ///   - resultCount: The total number of recommendation results
    ///   - resultPositionOnPage: The position of the recommendation result that was clicked o
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - resultID: Identifier of result set
    ///   - completionHandler: The callback to execute on completion.
    public func trackRecommendationResultClick(podID: String, strategyID: String? = nil, customerID: String, variationID: String? = nil, numResultsPerPage: Int? = nil, resultPage: Int? = nil, resultCount: Int? = nil, resultPositionOnPage: Int? = nil, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackRecommendationResultClickData(podID: podID, strategyID: strategyID, customerID: customerID, variationID: variationID, numResultsPerPage: numResultsPerPage, resultPage: resultPage, resultCount: resultCount, resultPositionOnPage: resultPositionOnPage, sectionName: section, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user performed an action indicating interest in an item (add to cart, add to wishlist, etc.)
    ///
    /// - Parameters:
    ///   - itemName: The item name.
    ///   - customerID: The item ID.
    ///   - revenue: The  revenue of the item.
    ///   - searchTerm: The term that the user searched for if searching (defaults to 'TERM_UNKNOWN')
    ///   - conversionType: The type of conversion (defaults to "add_to_cart")
    ///   - sectionName The name of the autocomplete section the term came from (defaults to "products")
    ///   - completionHandler: The callback to execute on completion.
    public func trackConversion(itemName: String, customerID: String, revenue: Double?, searchTerm: String? = nil, sectionName: String? = nil, conversionType: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let type = conversionType ?? Constants.Track.defaultConversionType
        let term = searchTerm == nil ? "TERM_UNKNOWN" : (searchTerm!.isEmpty) ? "TERM_UNKNOWN" : searchTerm
        let data = CIOTrackConversionData(searchTerm: term!, itemName: itemName, customerID: customerID, sectionName: section, revenue: revenue, conversionType: type)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /// Track when a user completes an order (usually fired on order confirmation page)
    ///
    /// - Parameters:
    ///   - customerIDs: The item IDs purchased
    ///   - revenue: The revenue of the purchase
    ///   - orderID: The order identifier
    ///   - sectionName The name of the autocomplete section the term came from (defaults to "products")
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
        self.attachSegments(requestBuilder: requestBuilder)
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
        self.attachSegments(requestBuilder: requestBuilder)
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

    private func attachSegments(requestBuilder: RequestBuilder) {
        if let us = self.config.segments {
            requestBuilder.set(segments: us)
        }
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

    private func executeRecommendations(_ request: URLRequest, completionHandler: @escaping RecommendationsQueryCompletionHandler) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }

        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(RecommendationsTaskResponse(error: error))
                return
            }

            let data = response.data!
            do {
                let parsedResponse = try self.parseRecommendations(data)
                dispatchHandlerOnMainQueue(RecommendationsTaskResponse(data: parsedResponse))
            } catch {
                dispatchHandlerOnMainQueue(RecommendationsTaskResponse(error: error))
            }
        }
    }

    private func executeTracking(_ request: URLRequest, completionHandler: TrackingCompletionHandler?) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler?(response)
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

    private func parseRecommendations(_ recommendationsResponseData: Data) throws -> CIORecommendationsResponse {
        return try self.recommendationsParser.parse(recommendationsResponseData: recommendationsResponseData)
    }

    // MARK: CIOSessionManagerDelegate

    public func sessionDidChange(from: Int, to: Int) {
        self.trackSessionStart(session: to)
    }

}
