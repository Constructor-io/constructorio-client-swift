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

    /**
     Initializes a ConstructorIO Client
     
     - Parameters:
        - config: A configuration object containing the API Key, Test Cell Information, Segments, etc.
     
     ### Usage Example: ###
     ```
     /// Create the client config
     let config = ConstructorIOConfig(
        apiKey: "YOUR API KEY",
        resultCount: AutocompleteResultCount(numResultsForSection: ["Search Suggestions" : 3, "Products" : 0]),
     )
     
     /// Create the client instance
     let constructorIO = ConstructorIO(config: config)
     ```
     */
    public init(config: ConstructorIOConfig) {
        self.config = config

        self.clientID = DependencyContainer.sharedInstance.clientIDGenerator().generateID()
        self.sessionManager = DependencyContainer.sharedInstance.sessionManager()
        self.networkClient = DependencyContainer.sharedInstance.networkClient()

        self.sessionManager.delegate = self
        self.sessionManager.setup()
    }

    /**
     Get autocomplete suggestions for a query.

     - Parameters:
        - query: The query object, consisting of the query to autocomplete on and additional options.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let autocompleteQuery = CIOAutocompleteQuery(query: "apple", numResults: 5, numResultsForSection: ["Products": 6, "Search Suggestions": 8])
     
     constructorIO.autocomplete(forQuery: autocompleteQuery) { response in
        let data = response.data!
        let error = response.error!
     }
     ```
     */
    public func autocomplete(forQuery query: CIOAutocompleteQuery, completionHandler: @escaping AutocompleteQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeAutocomplete(request, completionHandler: completionHandler)
    }

    /**
     Get search results for a query.

     - Parameters:
        - query: The query object, consisting of the query to search for and additional options.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let facetFilters = [(key: "Nutrition", value: "Organic"),
                         (key: "Nutrition", value: "Natural"),
                         (key: "Brand", value: "Kraft Foods")]

     let searchQuery = CIOSearchQuery(query: "red", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters), page: 1, perPage: 30, section: "Products")
     
     constructorIO.search(forQuery: searchQuery) { response in
        let data = response.data!
        let error = response.error!
     }
     ```
     */
    public func search(forQuery query: CIOSearchQuery, completionHandler: @escaping SearchQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeSearch(request, completionHandler: completionHandler)
    }

    /**
     Get browse results for a query.

     - Parameters:
        - query: The query object, consisting of the query to browse for and additional options.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let facetFilters = [(key: "Nutrition", value: "Organic"),
                         (key: "Nutrition", value: "Natural"),
                         (key: "Brand", value: "Kraft Foods")]

     let browseQuery = CIOBrowseQuery(filterName: "group_id", filterValue: "Pantry", filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters), page: 1, perPage: 30, section: "Products")
     
     constructorIO.browse(forQuery: browseQuery) { response in
        let data = response.data!
        let error = response.error!
     }
     ```
     */
    public func browse(forQuery query: CIOBrowseQuery, completionHandler: @escaping BrowseQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeBrowse(request, completionHandler: completionHandler)
    }

    /**
     Get recommendation results for a query.
    
     - Parameters:
        - query: The query object, consisting of the query to get recommendations for and additional options.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let recommendationsQuery = CIORecommendationsQuery(podID: "pod_name", itemID: "item_id", numResults: 5, section: "Products")
     
     constructorIO.recommendations(forQuery: recommendationsQuery) { response in
        let data = response.data!
        let error = response.error!
     }
     ```
     */
    public func recommendations(forQuery query: CIORecommendationsQuery, completionHandler: @escaping RecommendationsQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeRecommendations(request, completionHandler: completionHandler)
    }

    /**
     Track when a user focuses on a search input element

     - Parameters:
        - searchTerm: The pre-existing text in the search input element (if present)
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackInputFocus(searchTerm: "apple")
     ```
     */
    public func trackInputFocus(searchTerm: String, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackInputFocusData(searchTerm: searchTerm)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user selects (clicks, or navigates to via keyboard) a result that appears within autocomplete

     - Parameters:
        - searchTerm: The term that the user selected
        - originalQuery: The current text in the input field
        - sectionName: The name of the autocomplete section the term came from (usually "Search Suggestions")
        - group: Item group (if present)
        - resultID: Identifier of result set
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     constructorIO.trackAutocompleteSelect(searchTerm: "toothpicks", originalQuery: "tooth", sectionName: "Search Suggestions", group: CIOGroup(displayName: "Dental Health", groupID: "dental-92dk2", path: "health-2911e/dental-92dk2"), resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackAutocompleteSelect(searchTerm: String, originalQuery: String, sectionName: String, group: CIOGroup? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackAutocompleteSelectData(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName, group: group, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user submits a search (pressing enter within input element, or clicking submit element)

     - Parameters:
        - searchTerm: The term that the user searched for
        - originalQuery: The current text in the input field
        - group: Item group (if present)
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     constructorIO.trackSearchSubmit(searchTerm: "apple", originalQuery: "app")
     ```
     */
    public func trackSearchSubmit(searchTerm: String, originalQuery: String, group: CIOGroup? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: group)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user views a search product listing page

     - Parameters:
        - searchTerm: The term that the user searched for
        - resultCount: The number of search results returned in total
        - customerIDs: The list of item id's returned in the search
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     constructorIO.trackSearchResultsLoaded(searchTerm: "tooth", resultCount: 789, customerIDs: ["1234567-AB", "1234765-CD", "1234576-DE"])
     ```
     */
    public func trackSearchResultsLoaded(searchTerm: String, resultCount: Int, customerIDs: [String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount, customerIDs: customerIDs )
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user clicks a result that appears within a search product listing page

     - Parameters:
        - itemName: The item name.
        - customerID: The item ID.
        - variationID: The variation ID
        - searchTerm: The term that the user searched for (defaults to 'TERM_UNKNOWN')
        - sectionName: The name of the autocomplete section the term came from (defaults to "products")
        - resultID: Identifier of result set
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackSearchResultClick(itemName: "Fashionable Toothpicks", customerID: "1234567-AB", variationID: "1234567-AB-7463", searchTerm: "tooth", sectionName: "Products",  resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackSearchResultClick(itemName: String, customerID: String, variationID: String? = nil, searchTerm: String? = nil, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let term = searchTerm == nil ? "TERM_UNKNOWN" : (searchTerm!.isEmpty) ? "TERM_UNKNOWN" : searchTerm
        let data = CIOTrackSearchResultClickData(searchTerm: term!, itemName: itemName, customerID: customerID, sectionName: section, resultID: resultID, variationID: variationID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user views a browse product listing page

     - Parameters:
        - filterName: The name of the primary filter that the user browsed for (i.e "color")
        - filterValue: The value of the primary filter that the user browsed for (i.e "blue")
        - resultCount: The number of results returned in total
        - resultID: Identifier of result set
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackBrowseResultsLoaded(filterName: "Category", filterValue: "Snacks", resultCount: 674, resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackBrowseResultsLoaded(filterName: String, filterValue: String, resultCount: Int, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user clicks a result that appears within a browse product listing page

     - Parameters:
        - customerID: The item ID.
        - variationID: The variation ID
        - filterName: The name of the primary filter that the user browsed for (i.e "color")
        - filterValue: The value of the primary filter that the user browsed for (i.e "blue")
        - resultPositionOnPage: The position of clicked item
        - sectionName The name of the autocomplete section the term came from
        - resultID: Identifier of result set
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackBrowseResultClick(filterName: "Category", filterValue: "Snacks", customerID: "7654321-BA", variationID: "7654321-BA-738", resultPositionOnPage: 4, sectionName: "Products", resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackBrowseResultClick(customerID: String, variationID: String? = nil, filterName: String, filterValue: String, resultPositionOnPage: Int?, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackBrowseResultClickData(filterName: filterName, filterValue: filterValue, customerID: customerID, resultPositionOnPage: resultPositionOnPage, sectionName: section, resultID: resultID, variationID: variationID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user views a pod of recommendation results

     - Parameters:
        - podID: The pod ID
        - numResultsViewed: The count of results that is visible to the user
        - resultPage: The current page that recommedantion result is on
        - resultCount: The total number of recommendation results
        - sectionName: The name of the autocomplete section the term came from
        - resultID: Identifier of result set
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackRecommendationResultsView(podID: "pdp_best_sellers", numResultsViewed: 5, resultPage: 1, resultCount: 10, resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackRecommendationResultsView(podID: String, numResultsViewed: Int? = nil, resultPage: Int? = nil, resultCount: Int? = nil, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackRecommendationResultsViewData(podID: podID, numResultsViewed: numResultsViewed, resultPage: resultPage, resultCount: resultCount, sectionName: section, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user clicks an item that appears within a list of recommendation results

     - Parameters:
        - podID: The pod ID
        - strategyID: The strategy ID that fulfilled the pod
        - customerID: The item ID
        - variationID: The item variation ID
        - numResultsPerPage: The count of recommendation results on each page
        - resultPage: The current page that recommedantion result is on
        - resultCount: The total number of recommendation results
        - resultPositionOnPage: The position of the recommendation result that was clicked on
        - sectionName The name of the autocomplete section the term came from
        - resultID: Identifier of result set
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackRecommendationResultClick(podID: "pdp_best_sellers", strategyID: "best_sellers", customerID: "P183021", variationID: "7281930", numResultsPerPage: 30, resultPage: 1, resultCount: 15, resultPositionOnPage: 1, resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackRecommendationResultClick(podID: String, strategyID: String? = nil, customerID: String, variationID: String? = nil, numResultsPerPage: Int? = nil, resultPage: Int? = nil, resultCount: Int? = nil, resultPositionOnPage: Int? = nil, sectionName: String? = nil, resultID: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackRecommendationResultClickData(podID: podID, strategyID: strategyID, customerID: customerID, variationID: variationID, numResultsPerPage: numResultsPerPage, resultPage: resultPage, resultCount: resultCount, resultPositionOnPage: resultPositionOnPage, sectionName: section, resultID: resultID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user performs an action indicating interest in an item (add to cart, add to wishlist, etc.)

     - Parameters:
        - itemName: The item name.
        - customerID: The item ID.
        - variationID: The variation ID
        - revenue: The  revenue of the item.
        - searchTerm: The term that the user searched for if searching (defaults to 'TERM_UNKNOWN')
        - conversionType: The type of conversion (defaults to "add_to_cart")
        - sectionName The name of the autocomplete section the term came from (defaults to "products")
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackConversion(itemName: "Fashionable Toothpicks", customerID: "1234567-AB", variationID: "1234567-AB-47398", revenue: 12.99, searchTerm: "tooth", conversionType: "add_to_cart")
     ```
     */
    public func trackConversion(itemName: String, customerID: String, variationID: String? = nil, revenue: Double?, searchTerm: String? = nil, sectionName: String? = nil, conversionType: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let type = conversionType ?? Constants.Track.defaultConversionType
        let term = searchTerm == nil ? "TERM_UNKNOWN" : (searchTerm!.isEmpty) ? "TERM_UNKNOWN" : searchTerm
        let data = CIOTrackConversionData(searchTerm: term!, itemName: itemName, customerID: customerID, sectionName: section, revenue: revenue, conversionType: type, variationID: variationID)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user completes an order (usually fired on order confirmation page)

     - Parameters:
        - customerIDs: The item IDs purchased
        - revenue: The revenue of the purchase
        - orderID: The order identifier
        - sectionName The name of the autocomplete section the term came from (defaults to "products")
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackPurchase(customerIDs: ["123-AB", "456-CD"], revenue: 34.49, orderID: "343-315")
     ```
     */
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
