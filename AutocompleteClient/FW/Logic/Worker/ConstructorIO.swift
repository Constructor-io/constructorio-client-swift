//
//  ConstructorIO.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias AutocompleteQueryCompletionHandler = (AutocompleteTaskResponse) -> Void
public typealias SearchQueryCompletionHandler = (SearchTaskResponse) -> Void
public typealias BrowseQueryCompletionHandler = (BrowseTaskResponse) -> Void
public typealias BrowseFacetsQueryCompletionHandler = (BrowseFacetsTaskResponse) -> Void
public typealias BrowseFacetOptionsQueryCompletionHandler = (BrowseFacetOptionsTaskResponse) -> Void
public typealias RecommendationsQueryCompletionHandler = (RecommendationsTaskResponse) -> Void
public typealias TrackingCompletionHandler = (TrackingTaskResponse) -> Void
public typealias QuizQuestionQueryCompletionHandler = (QuizQuestionTaskResponse) -> Void
public typealias QuizResultsQueryCompletionHandler = (QuizResultsTaskResponse) -> Void

// swiftlint:disable type_body_length file_length

/**
 The main class to be used for getting autocomplete results and tracking behavioural data.
 */
public class ConstructorIO: CIOSessionManagerDelegate {

    public var config: ConstructorIOConfig

    public static var logger: CIOLogger = CIOPrintLogger()

    private let networkClient: NetworkClient
    
    private var clientIdLoader: ClientIdLoader = CIOClientIdLoader()

    public var sessionManager: SessionManager

    public var clientID: String?

    public var userID: String?

    public var autocompleteParser: AbstractAutocompleteResponseParser = DependencyContainer.sharedInstance.autocompleteResponseParser()
    var searchParser: AbstractSearchResponseParser = DependencyContainer.sharedInstance.searchResponseParser()
    var browseParser: AbstractBrowseResponseParser = DependencyContainer.sharedInstance.browseResponseParser()
    var browseFacetsParser: AbstractBrowseFacetsResponseParser = DependencyContainer.sharedInstance.browseFacetsResponseParser()
    var browseFacetOptionsParser: AbstractBrowseFacetOptionsResponseParser = DependencyContainer.sharedInstance.browseFacetOptionsResponseParser()
    var recommendationsParser: AbstractRecommendationsResponseParser = DependencyContainer.sharedInstance.recommendationsResponseParser()
    var quizQuestionParser: AbstractQuizQuestionResponseParser = DependencyContainer.sharedInstance.quizQuestionResponseParser()
    var quizResultsParser: AbstractQuizResultsResponseParser = DependencyContainer.sharedInstance.quizResultsResponseParser()

    public var sessionID: Int {
        get {
            return self.sessionManager.getSessionWithIncrement()
        }

        set (newID) {
            self.sessionManager.setSessionID(id: newID)
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

        self.clientID = clientIdLoader.loadClientId();
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
     Get browse items results for a query.

     - Parameters:
        - query: The query object, consisting of the query to browse items for and additional options.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let facetFilters = [(key: "Nutrition", value: "Organic"),
                         (key: "Nutrition", value: "Natural"),
                         (key: "Brand", value: "Kraft Foods")]

     let browseItemsQuery = CIOBrowseItemsQuery(ids: ["123", "123"], filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters), page: 1, perPage: 30, section: "Products")
     
     constructorIO.browseItems(forQuery: browseItemsQuery) { response in
        let data = response.data!
        let error = response.error!
     }
     ```
     */
    public func browseItems(forQuery query: CIOBrowseItemsQuery, completionHandler: @escaping BrowseQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeBrowse(request, completionHandler: completionHandler)
    }

    /**
     Get browse groups results for a query.

     - Parameters:
        - query: The query object, consisting of the query to browse groups for and additional options.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let browseGroupsQuery = CIOBrowseGroupsQuery(
        groupId: "group_1",
        section: "Products",
        groupsMaxDepth: 5
     )

     constructor.browseGroups(forQuery: browseGroupsQuery) { response in
         let data = response.data!
         let error = response.error!
     }
     ```
     */
    public func browseGroups(forQuery query: CIOBrowseGroupsQuery, completionHandler: @escaping BrowseQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeBrowse(request, completionHandler: completionHandler)
    }

    /**
     Get browse facets results for a query.

     - Parameters:
        - query: The query object, consisting of the query to browse facets for and additional options.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let browseFacetsQuery = CIOBrowseFacetsQuery(page: 1, perPage: 10, showHiddenFacets: true)

     constructorIO.browseFacets(forQuery: browseFacetsQuery) { response in
        let data = response.data!
        let error = response.error!
     }
     ```
     */
    public func browseFacets(forQuery query: CIOBrowseFacetsQuery, completionHandler: @escaping BrowseFacetsQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeBrowseFacets(request, completionHandler: completionHandler)
    }

    /**
     Get browse facet options results for a query.

     - Parameters:
        - query: The query object, consisting of the query to browse facet options for and additional options.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let browseFacetOptionsQuery = CIOBrowseFacetOptionsQuery(facetNme: "price", showHiddenFacets: true)

     constructorIO.browseFacetOptions(forQuery: browseFacetOptionsQuery) { response in
        let data = response.data!
        let error = response.error!
     }
     ```
     */
    public func browseFacetOptions(forQuery query: CIOBrowseFacetOptionsQuery, completionHandler: @escaping BrowseFacetOptionsQueryCompletionHandler) {
        let request = self.buildRequest(data: query)
        executeBrowseFacetOptions(request, completionHandler: completionHandler)
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
     Get Quiz question for a query.
    
     - Parameters:
        - query: The CIOQuizQuery object required to get the next quiz question.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let quizQuestionQuery = CIOQuizQuery(quizID: "123", answers: [["1"], ["1", "2"]], quizVersionID: "some-version-id", quizSessionID: "some-session-id")

     constructorIO.getQuizNextQuestion(forQuery: quizQuestionQuery) { response in
        let data = response.data!
        let error = response.error!
     }
     ```
     */
    public func getQuizNextQuestion(forQuery query: CIOQuizQuery, completionHandler: @escaping  QuizQuestionQueryCompletionHandler) {
        let request = self.buildQuizRequest(data: query, finalize: false)
        executeGetQuizNextQuestion(request, completionHandler: completionHandler)
    }

    /**
     Get Quiz results for a query.
    
     - Parameters:
        - query: The CIOQuizQuery object required to get the quiz results.
        - completionHandler: The callback to execute on completion.

     ### Usage Example: ###
     ```
     let quizResultsQuery = CIOQuizQuery(quizID: "123", answers: [["1"], ["1", "2"]], quizVersionID: "some-version-id", quizSessionID: "some-session-id")
     
     constructorIO.getQuizResults(forQuery: quizResultsQuery) { response in
        let data = response.data!
        let error = response.error!
     }
     ```
     */
    public func getQuizResults(forQuery query: CIOQuizQuery, completionHandler: @escaping  QuizResultsQueryCompletionHandler) {
        let request = self.buildQuizRequest(data: query, finalize: true)
        executeGetQuizResults(request, completionHandler: completionHandler)
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
        - The group to search within. Only required if searching within a group, i.e. "Pumpkin in Canned Goods"
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
        - The group to search within. Only required if searching within a group, i.e. "Pumpkin in Canned Goods"
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
        - resultID: Identifier of result set
        - analyticsTags Additional analytics tags to pass
        - items: The list of items returned in the search
        - slAdvertiser: The advertiser ID
        - slCampaignID: The campaign ID
        - slCampaignOwner: The campaign owner
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackSearchResultsLoaded(searchTerm: "tooth", resultCount: 789, customerIDs: ["1234567-AB", "1234765-CD", "1234576-DE"], items: [CIOItem(id: "1234567-AB", name: "Toothpicks")])
     ```
     */
    public func trackSearchResultsLoaded(searchTerm: String, resultCount: Int, customerIDs: [String]? = nil, items: [CIOItem]? = nil, resultID: String? = nil, slAdvertiser: String? = nil, slCampaignID: String? = nil, slCampaignOwner: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount, resultID: resultID, url: "Not Available", customerIDs: customerIDs, items: items, slAdvertiser: slAdvertiser, slCampaignID: slCampaignID, slCampaignOwner: slCampaignOwner, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user clicks a result that appears within a search product listing page

     - Parameters:
        - itemName: The item name.
        - customerID: The item ID.
        - variationID: The variation ID
        - searchTerm: The term that the user searched for if searching (defaults to 'TERM_UNKNOWN')
        - sectionName The name of the autocomplete section the term came from (defaults to "products")
        - resultID: Identifier of result set
        - slAdvertiser: The advertiser ID
        - slCampaignID: The campaign ID
        - slCampaignOwner: The campaign owner
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackSearchResultClick(itemName: "Fashionable Toothpicks", customerID: "1234567-AB", variationID: "1234567-AB-47398", searchTerm: "tooth", sectionName: "Products",  resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackSearchResultClick(itemName: String, customerID: String, variationID: String? = nil, searchTerm: String? = nil, sectionName: String? = nil, resultID: String? = nil, slAdvertiser: String? = nil, slCampaignID: String? = nil, slCampaignOwner: String? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let term = searchTerm == nil ? "TERM_UNKNOWN" : (searchTerm!.isEmpty) ? "TERM_UNKNOWN" : searchTerm
        let data = CIOTrackSearchResultClickData(searchTerm: term!, itemName: itemName, customerID: customerID, sectionName: section, resultID: resultID, variationID: variationID, slAdvertiser: slAdvertiser, slCampaignID: slCampaignID, slCampaignOwner: slCampaignOwner)
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user views a browse product listing page

     - Parameters:
        - filterName: The name of the primary filter that the user browsed for (i.e "color")
        - filterValue: The value of the primary filter that the user browsed for (i.e "blue")
        - resultCount: The number of results returned in total
        - customerIDs: The list of item id's returned in the browse
        - resultID: Identifier of result set
        - items: The list of items returned in the browse
        - slAdvertiser: The advertiser ID
        - slCampaignID: The campaign ID
        - slCampaignOwner: The campaign owner
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackBrowseResultsLoaded(filterName: "Category", filterValue: "Snacks", resultCount: 674, customerIDs: ["1234567-AB", "1234765-CD", "1234576-DE"], items: [CIOItem(id: "1234567-AB", name: "Toothpicks")])
     ```
     */
    public func trackBrowseResultsLoaded(filterName: String, filterValue: String, resultCount: Int, customerIDs: [String]? = nil, items: [CIOItem]? = nil, resultID: String? = nil, slAdvertiser: String? = nil, slCampaignID: String? = nil, slCampaignOwner: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let data = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, resultID: resultID, url: "Not Available", customerIDs: customerIDs, items: items, slAdvertiser: slAdvertiser, slCampaignID: slCampaignID, slCampaignOwner: slCampaignOwner, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
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
        - slAdvertiser: The advertiser ID
        - slCampaignID: The campaign ID
        - slCampaignOwner: The campaign owner
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackBrowseResultClick(filterName: "Category", filterValue: "Snacks", customerID: "7654321-BA", variationID: "7654321-BA-738", resultPositionOnPage: 4, sectionName: "Products", resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackBrowseResultClick(customerID: String, variationID: String? = nil, filterName: String, filterValue: String, resultPositionOnPage: Int?, sectionName: String? = nil, resultID: String? = nil, slAdvertiser: String? = nil, slCampaignID: String? = nil, slCampaignOwner: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackBrowseResultClickData(filterName: filterName, filterValue: filterValue, customerID: customerID, resultPositionOnPage: resultPositionOnPage, sectionName: section, resultID: resultID, variationID: variationID, slAdvertiser: slAdvertiser, slCampaignID: slCampaignID, slCampaignOwner: slCampaignOwner, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user views a pod of recommendation results

     - Parameters:
        - podID: The pod ID
        - numResultsViewed: The count of results that is visible to the user
        - customerIDs: The items that were loaded
        - resultPage: The current page that recommedantion result is on
        - resultCount: The total number of recommendation results
        - sectionName: The name of the autocomplete section the term came from
        - resultID: Identifier of result set
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackRecommendationResultsView(podID: "pdp_best_sellers", numResultsViewed: 5, customerIDs: ["1234567-AB", "1234765-CD", "1234576-DE"], resultPage: 1, resultCount: 10, resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackRecommendationResultsView(podID: String, numResultsViewed: Int? = nil, customerIDs: [String]? = nil, resultPage: Int? = nil, resultCount: Int? = nil, sectionName: String? = nil, resultID: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackRecommendationResultsViewData(podID: podID, numResultsViewed: numResultsViewed, customerIDs: customerIDs, resultPage: resultPage, resultCount: resultCount, sectionName: section, resultID: resultID, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))

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
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackRecommendationResultClick(podID: "pdp_best_sellers", strategyID: "best_sellers", customerID: "P183021", variationID: "7281930", numResultsPerPage: 30, resultPage: 1, resultCount: 15, resultPositionOnPage: 1, resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
     ```
     */
    public func trackRecommendationResultClick(podID: String, strategyID: String? = nil, customerID: String, variationID: String? = nil, numResultsPerPage: Int? = nil, resultPage: Int? = nil, resultCount: Int? = nil, resultPositionOnPage: Int? = nil, sectionName: String? = nil, resultID: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackRecommendationResultClickData(podID: podID, strategyID: strategyID, customerID: customerID, variationID: variationID, numResultsPerPage: numResultsPerPage, resultPage: resultPage, resultCount: resultCount, resultPositionOnPage: resultPositionOnPage, sectionName: section, resultID: resultID, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user performs an action indicating interest in an item (add to cart, add to wishlist, etc.)

     - Parameters:
        - itemName: The item name.
        - customerID: The item ID.
        - variationID: The variation ID
        - revenue: The revenue of the item.
        - searchTerm: The term that the user searched for if searching (defaults to 'TERM_UNKNOWN')
        - sectionName The name of the autocomplete section the term came from (defaults to "products")
        - conversionType: The type of conversion (defaults to "add_to_cart")
        - displayName: Display name for the custom conversion type
        - isCustomType: Specify if type is a custom conversion type
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackConversion(itemName: "Fashionable Toothpicks", customerID: "1234567-AB", variationID: "1234567-AB-47398", revenue: 12.99, searchTerm: "tooth")
     ```
     */
    public func trackConversion(itemName: String, customerID: String, variationID: String? = nil, revenue: Double?, searchTerm: String? = nil, sectionName: String? = nil, conversionType: String? = nil, displayName: String? = nil, isCustomType: Bool? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let type = conversionType ?? Constants.Track.defaultConversionType
        let term = searchTerm == nil ? "TERM_UNKNOWN" : (searchTerm!.isEmpty) ? "TERM_UNKNOWN" : searchTerm
        let data = CIOTrackConversionData(searchTerm: term!, itemName: itemName, customerID: customerID, sectionName: section, revenue: revenue, conversionType: type, variationID: variationID, displayName: displayName, isCustomType: isCustomType, analyticsTags: analyticsTags)
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
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackPurchase(customerIDs: ["123-AB", "456-CD"], revenue: 34.49, orderID: "343-315")
     ```
     */
    public func trackPurchase(customerIDs: [String], sectionName: String? = nil, revenue: Double? = nil, orderID: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackPurchaseData(customerIDs: customerIDs, sectionName: section, revenue: revenue, orderID: orderID, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user completes an order (usually fired on order confirmation page)

     - Parameters:
        - items: The items purchased
        - revenue: The revenue of the purchase
        - orderID: The order identifier
        - sectionName The name of the autocomplete section the term came from (defaults to "products")
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackPurchase(customerIDs: ["123-AB", "456-CD"], revenue: 34.49, orderID: "343-315")
     ```
     */
    public func trackPurchase(items: [CIOItem], sectionName: String? = nil, revenue: Double? = nil, orderID: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackPurchaseData(items: items, sectionName: section, revenue: revenue, orderID: orderID, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user views a product detail page

     - Parameters:
        - customerID: The item ID
        - itemName: The item name
        - variationID: The id of the variation
        - sectionName: The name of the section the product is in.
        - analyticsTags Additional analytics tags to pass
        - url: The url of the product
     
     ### Usage Example: ###
     ```
     constructorIO.trackItemDetailLoad(customerID: "7654321-BA", itemName: "Pencil", variationID: "7654321-BA-738", sectionName: "Products", "test.com/764321")
     ```
     */
    public func trackItemDetailLoad(customerID: String, itemName: String, variationID: String? = nil, sectionName: String? = nil, url: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackItemDetailLoadData(itemName: itemName, customerID: customerID, variationID: variationID, sectionName: section, url: url ?? "Not Available", analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    private func trackSessionStart(session: Int, completionHandler: TrackingCompletionHandler? = nil) {
        let request = self.buildSessionStartRequest(session: session)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user views a quizzes results page

     - Parameters:
        - quizID: The quiz identifier
        - quizVersionID: The quiz version identifier
        - quizSessionID: The quiz session identifier associated with this conversion event
        - resultID: The identifier of result set returned by the Constructor quiz response
        - resultPage: The current page of the results
        - resultCount: The total number of results
        - sectionName The name of the autocomplete section the results came from
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackQuizResultsLoaded(quizID: "coffee-quiz", quizVersionID: "1231244", quizSessionID: "123", resultCount: 20)
     ```
     */
    public func trackQuizResultsLoaded(quizID: String, quizVersionID: String, quizSessionID: String, resultID: String? = nil, resultPage: Int? = nil, resultCount: Int? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackQuizResultsLoadedData(quizID: quizID, quizVersionID: quizID, quizSessionID: quizSessionID, resultID: resultID, resultPage: resultPage, resultCount: resultCount, sectionName: section, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user clicks a result that appears within a quizzes results page

     - Parameters:
        - quizID: The quiz identifier
        - quizVersionID: The quiz version identifier
        - quizSessionID: The quiz session identifier associated with this conversion event
        - customerID: The item ID.
        - variationID: The variation ID
        - itemName: The product item name
        - resultID: The identifier of result set returned by the Constructor quiz response
        - resultPage: The current page of the results
        - resultCount: The total number of results
        - numResultsPerPage: The number of results on the current page
        - resultPositionOnPage: The position of clicked item
        - sectionName The name of the autocomplete section the result came from
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
     
     ### Usage Example: ###
     ```
     constructorIO.trackQuizResultClick(quizID: "coffee-quiz", quizVersionID: "1231244", quizSessionID: "123", customerID: "123", itemName: "espresso")
     ```
     */
    public func trackQuizResultClick(quizID: String, quizVersionID: String, quizSessionID: String, customerID: String, variationID: String? = nil, itemName: String? = nil, resultID: String? = nil, resultPage: Int? = nil, resultCount: Int? = nil, numResultsPerPage: Int? = nil, resultPositionOnPage: Int? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackQuizResultClickData(quizID: quizID, quizVersionID: quizVersionID, quizSessionID: quizSessionID, customerID: customerID, variationID: variationID, itemName: itemName, resultID: resultID, resultPage: resultPage, resultCount: resultCount, numResultsPerPage: numResultsPerPage, resultPositionOnPage: resultPositionOnPage, sectionName: section, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Track when a user clicks a result that appears within a quizzes results page

     - Parameters:
        - quizID: The quiz identifier
        - quizVersionID: The quiz version identifier
        - quizSessionID: The quiz session identifier associated with this conversion event
        - customerID: The item ID.
        - variationID: The variation ID
        - itemName: The product item name
        - revenue: The sale price if available, otherwise the regular (retail) price of item
        - conversionType: The type of conversion (defaults to "add_to_cart")
        - isCustomType: The flag to specify if type is custom conversion type
        - displayName: The display name for the custom conversion type
        - sectionName The name of the autocomplete section the result came from
        - analyticsTags Additional analytics tags to pass
        - completionHandler: The callback to execute on completion.
 
     ### Usage Example: ###
     ```
     constructorIO.trackQuizConversion(quizID: "coffee-quiz", quizVersionID: "1231244", quizSessionID: "3123", customerID: "123", variationID: "167", itemName: "espresso", revenue: 20.0)
     ```
     */
    public func trackQuizConversion(quizID: String, quizVersionID: String, quizSessionID: String, customerID: String, variationID: String? = nil, itemName: String? = nil, revenue: Double? = nil, conversionType: String? = nil, isCustomType: Bool? = nil, displayName: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil, completionHandler: TrackingCompletionHandler? = nil) {
        let section = sectionName ?? self.config.defaultItemSectionName ?? Constants.Track.defaultItemSectionName
        let data = CIOTrackQuizConversionData(quizID: quizID, quizVersionID: quizVersionID, quizSessionID: quizSessionID, customerID: customerID, variationID: variationID, itemName: itemName, revenue: revenue, conversionType: conversionType, isCustomType: isCustomType, displayName: displayName, sectionName: section, analyticsTags: mergeDictionary(baseDictionary: self.config.defaultAnalyticsTags, newDictionary: analyticsTags))
        let request = self.buildRequest(data: data)
        executeTracking(request, completionHandler: completionHandler)
    }

    /**
     Set a custom clientID

     - Parameters:
        - clientID: The Client ID

     ### Usage Example: ###
     ```
     constructorIO.setClientId(clientID: "new-client-id")
     ```
     */
    public func setClientId(clientID: String) {
        self.clientID = clientID
        clientIdLoader.saveClientId(clientID)
    }

    /**
     Set a custom sessionID

     - Parameters:
        - sessionID: The Session ID

     ### Usage Example: ###
     ```
     constructorIO.setSessionId(sessionID: 1234)
     ```
     */
    public func setSessionId(sessionID: Int) {
        self.sessionID = sessionID
    }
    
    private func mergeDictionary(baseDictionary: [String: String]?, newDictionary: [String: String]?) -> [String: String]? {
        if (newDictionary == nil || newDictionary!.isEmpty) {
            return baseDictionary
        } else if (baseDictionary != nil && !baseDictionary!.isEmpty) {
            return baseDictionary!.merging(newDictionary!) { (_, new) in new }
        }
        
        return nil
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

    private func buildQuizRequest(data: CIORequestData, finalize: Bool) -> URLRequest {
        let requestBuilder = RequestBuilder(apiKey: self.config.apiKey, baseQuizURL: self.config.baseQuizURL ?? Constants.Query.baseQuizURLString)
        self.attachClientID(requestBuilder: requestBuilder)
        self.attachUserID(requestBuilder: requestBuilder)
        self.attachSessionIDWithIncrement(requestBuilder: requestBuilder)
        self.attachABTestCells(requestBuilder: requestBuilder)
        self.attachSegments(requestBuilder: requestBuilder)
        requestBuilder.build(trackData: data)
        return requestBuilder.getQuizRequest(finalize: finalize)
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
        self.config.testCells?.forEach({ [unowned requestBuilder] cell in
            if !cell.key.isEmpty {
                requestBuilder.set(testCellKey: cell.key, testCellValue: cell.value)
            }
        })
    }

    private func attachSegments(requestBuilder: RequestBuilder) {
        requestBuilder.set(segments: Array(Set((self.config.segments ?? []) + Constants.Query.defaultSegments)))
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

    private func executeBrowseFacets(_ request: URLRequest, completionHandler: @escaping BrowseFacetsQueryCompletionHandler) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }

        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(BrowseFacetsTaskResponse(error: error))
                return
            }

            let data = response.data!
            do {
                let parsedResponse = try self.parseBrowseFacets(data)
                dispatchHandlerOnMainQueue(BrowseFacetsTaskResponse(data: parsedResponse))
            } catch {
                dispatchHandlerOnMainQueue(BrowseFacetsTaskResponse(error: error))
            }
        }
    }

    private func executeBrowseFacetOptions(_ request: URLRequest, completionHandler: @escaping BrowseFacetOptionsQueryCompletionHandler) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }

        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(BrowseFacetOptionsTaskResponse(error: error))
                return
            }

            let data = response.data!
            do {
                let parsedResponse = try self.parseBrowseFacetOptions(data)
                dispatchHandlerOnMainQueue(BrowseFacetOptionsTaskResponse(data: parsedResponse))
            } catch {
                dispatchHandlerOnMainQueue(BrowseFacetOptionsTaskResponse(error: error))
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

    private func executeGetQuizNextQuestion(_ request: URLRequest, completionHandler: @escaping QuizQuestionQueryCompletionHandler) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }

        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(QuizQuestionTaskResponse(error: error))
                return
            }

            let data = response.data!
            do {
                let parsedResponse = try self.parseQuizQuestion(data)
                dispatchHandlerOnMainQueue(QuizQuestionTaskResponse(data: parsedResponse))
            } catch {
                dispatchHandlerOnMainQueue(QuizQuestionTaskResponse(error: error))
            }
        }
    }

    private func executeGetQuizResults(_ request: URLRequest, completionHandler: @escaping QuizResultsQueryCompletionHandler) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler(response)
            }
        }

        self.networkClient.execute(request) { response in
            if let error = response.error {
                dispatchHandlerOnMainQueue(QuizResultsTaskResponse(error: error))
                return
            }

            let data = response.data!
            do {
                let parsedResponse = try self.parseQuizResults(data)
                dispatchHandlerOnMainQueue(QuizResultsTaskResponse(data: parsedResponse))
            } catch {
                dispatchHandlerOnMainQueue(QuizResultsTaskResponse(error: error))
            }
        }
    }

    class PIIPattern {
        let pattern: String
        let replaceBy: String

        init(pattern: String, replaceBy: String) {
            self.pattern = pattern
            self.replaceBy = replaceBy
        }
    }

    let PIIPatterns = [
        // Email
        PIIPattern(pattern: #"[\w\-+\\.]+@([\w-]+\.)+[\w-]{2,4}"#, replaceBy: "<email_omitted>"),
        // Phone
        PIIPattern(pattern: #"^(?:\+\d{11,12}|\+\d{1,3}\s\d{3}\s\d{3}\s\d{3,4}|\(\d{3}\)\d{7}|\(\d{3}\)\s\d{3}\s\d{4}|\(\d{3}\)\d{3}-\d{4}|\(\d{3}\)\s\d{3}-\d{4})$"#, replaceBy: "<phone_omitted>"),
        // Visa, Mastercard, Amex, Discover, JCB and Diners Club, regex source: https://www.regular-expressions.info/creditcard.html
        PIIPattern(pattern: #"^(?:4[0-9]{15}|(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|6(?:011|5[0-9]{2})[0-9]{12}|(?:2131|1800|35\d{3})\d{11})$"#, replaceBy: "<credit_omitted>")
    ]

    private func containsPII(query: String, pattern: String) -> Bool {
        return query.range(
            of: pattern,
            options: .regularExpression
        ) != nil
    }

    private func getQueryParams(request: URLRequest) -> [String: String]? {
        guard let url = request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
            return nil
        }

        var keyValuePairs = [String: String]()
        for item in queryItems {
            if let name = item.name.removingPercentEncoding, let value = item.value?.removingPercentEncoding {
                keyValuePairs[name] = value
            }
        }

        return keyValuePairs
    }

    private func replacePathParam(request: URLRequest, name: String, newValue: String) -> URLRequest {
        guard var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) else {
            return request // Return if URL components cannot be created
        }

        var newRequest = request

        // Check if the path contains the parameter placeholder
        var path = components.path
        if path.contains(name) {
            path = path.replacingOccurrences(of: name, with: newValue)
            components.path = path
            newRequest.url = components.url
        }

        return newRequest
    }

    private func replaceQueryParamValue(request: URLRequest, name: String, newValue: String) -> URLRequest {
        guard var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) else {
            return request // Return if URL components cannot be created
        }

        var newRequest = request

        if var queryItems = components.queryItems {
            // Find and replace all occurrences of the query parameter by name
            for (index, item) in queryItems.enumerated() where item.name == name {
                queryItems[index].value = newValue
            }

            components.queryItems = queryItems // Update the query items with replaced values
            newRequest.url = components.url // Update the URL of the new request
        } else {
            // Add the query parameter if it doesn't exist
            components.queryItems = [URLQueryItem(name: name, value: newValue)]
            newRequest.url = components.url // Update the URL of the new request
        }

        return newRequest
    }

    public func obfuscatePIIRequest(request: URLRequest) -> URLRequest {
        let paths = request.url?.path.components(separatedBy: "/")
        let params = getQueryParams(request: request)

        var obfuscatedRequest = request

        for pattern in PIIPatterns {
            for path in paths ?? [] where containsPII(query: path, pattern: pattern.pattern) {
                obfuscatedRequest = replacePathParam(request: obfuscatedRequest, name: path, newValue: pattern.replaceBy)
            }
            for (key, value) in params ?? [:] where containsPII(query: value, pattern: pattern.pattern) {
                obfuscatedRequest = replaceQueryParamValue(request: obfuscatedRequest, name: key, newValue: pattern.replaceBy)
            }
        }

        return obfuscatedRequest
    }

    private func executeTracking(_ request: URLRequest, completionHandler: TrackingCompletionHandler?) {
        let dispatchHandlerOnMainQueue = { response in
            DispatchQueue.main.async {
                completionHandler?(response)
            }
        }

        // PII detection & request obfuscation
        let requestWithoutPII = obfuscatePIIRequest(request: request)

        self.networkClient.execute(requestWithoutPII) { response in
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

    private func parseBrowseFacets(_ browseFacetsResponseData: Data) throws -> CIOBrowseFacetsResponse {
        return try self.browseFacetsParser.parse(browseFacetsResponseData: browseFacetsResponseData)
    }

    private func parseBrowseFacetOptions(_ browseFacetOptionsResponseData: Data) throws -> CIOBrowseFacetOptionsResponse {
        return try self.browseFacetOptionsParser.parse(browseFacetOptionsResponseData: browseFacetOptionsResponseData)
    }

    private func parseRecommendations(_ recommendationsResponseData: Data) throws -> CIORecommendationsResponse {
        return try self.recommendationsParser.parse(recommendationsResponseData: recommendationsResponseData)
    }

    private func parseQuizQuestion(_ quizQuestionResponseData: Data) throws -> CIOQuizQuestionResponse {
        return try self.quizQuestionParser.parse(quizQuestionResponseData: quizQuestionResponseData)
    }

    private func parseQuizResults(_ quizResultsResponseData: Data) throws -> CIOQuizResultsResponse {
        return try self.quizResultsParser.parse(quizResultsResponseData: quizResultsResponseData)
    }

    // MARK: CIOSessionManagerDelegate

    public func sessionDidChange(from: Int, to: Int) {
        self.trackSessionStart(session: to)
    }

}
// swiftlint:enable type_body_length file_length
