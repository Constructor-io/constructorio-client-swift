//
//  Constants.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

struct Constants {

    static var getConstructorSDKVersion: () -> String = {
        let SDKBundle = Bundle(for: RequestBuilder.self)  // No need for optional binding
        let sdkVersion = (SDKBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
        
        return sdkVersion
    }
    
    static var getCustomerAppVersion: () -> String = {
        let customerAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        
        return customerAppVersion
    }
    
    static var versionString: () -> String = {
        var prefix = "cioios-"

        let constrictorSDKVersion = Constants.getConstructorSDKVersion()
        let customerAppVersion = Constants.getCustomerAppVersion()
        
        return "\(prefix)\(customerAppVersion)::\(constrictorSDKVersion)"
    }

    struct UI {
        static let CellIdentifier = "SearchItemCellID"
        static let defaultFontSize: CGFloat = 16
        static let defaultRowHeight: CGFloat = 50
        static let defaultSectionHeaderHeight: CGFloat = 44
        static let defaultSearchBarPlaceholder = ""
        static let defaultScreenTitle = ""
        static let fadeInDuration: TimeInterval = 0.4
        static let fadeOutDuration: TimeInterval = 0.4
        static let fireQueryDelayInSeconds: TimeInterval = 0.5

        struct Color {
            static var defaultFontColorNormal = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.0)
            static var defaultFontColorBold = UIColor.black
        }

        struct Font {
            static var defaultFontNormal: UIFont {
                let fontSize: CGFloat = Constants.UI.defaultFontSize
                return UIFont(name: "HelveticaNeue", size: fontSize)!
            }

            static var defaultFontBold: UIFont {
                let fontSize: CGFloat = Constants.UI.defaultFontSize
                return UIFont(name: "HelveticaNeue-Bold", size: fontSize)!
            }
        }
    }

    struct ABTesting {
        static let keyFormat = "ef-%@"
    }

    struct Query {
        static let apiKey = "key"
        static let baseURLString = "https://ac.cnstrc.com"
        static let baseQuizURLString = "https://quizzes.cnstrc.com"
        static let defaultSegments = ["cio-ios", "cio-app"]
        static let httpMethod = "GET"
        static let sessionIncrementTimeoutInSeconds: TimeInterval = 1800 // 30 mins
        static let section = "section"
    }

    struct ClientID {
        static let key = "kClientID"
    }

    struct AutocompleteQuery {
        static let format = "%@/autocomplete/%@"
        static let numResults = "num_results"
        static let numResultsForSectionNamePrefix = "num_results_"
        static let queryItemForSection = { (name: String) -> String in return Constants.AutocompleteQuery.numResultsForSectionNamePrefix + name }
        static let sectionNameSearchSuggestions = "Search Suggestions"
        static let sectionFilterKey = { (section: String, key: String) -> String in "filters[\(section)][\(key)]" }
        static let sectionNameProducts = "Products"
        static let defaultItemCountPerSection = 10
    }

    struct SearchQuery {
        static let format = "%@/search/%@"
        static let page = "page"
        static let perPage = "num_results_per_page"
        static let groupFilter = "filters[group_id]"
        static let facetFilterKey = { (key: String) -> String in "filters[\(key)]" }
        static let fmtOptionsKey = { (key: String) -> String in "fmt_options[\(key)]" }
        static let section = "section"
        static let sortBy = "sort_by"
        static let sortOrder = "sort_order"
        static let defaultSectionName = "Products"
        static let defaultPage = 1
        static let defaultPerPage = 30
    }

    struct BrowseQuery {
        static let format = "%@/browse/%@/%@"
        static let page = "page"
        static let perPage = "num_results_per_page"
        static let groupFilter = "filters[group_id]"
        static let facetFilterKey = { (key: String) -> String in "filters[\(key)]" }
        static let fmtOptionsKey = { (key: String) -> String in "fmt_options[\(key)]" }
        static let section = "section"
        static let sortBy = "sort_by"
        static let sortOrder = "sort_order"
        static let defaultSectionName = "Products"
        static let defaultPage = 1
        static let defaultPerPage = 30
    }

    struct BrowseItemsQuery {
        static let format = "%@/browse/items"
        static let page = "page"
        static let perPage = "num_results_per_page"
        static let groupFilter = "filters[group_id]"
        static let facetFilterKey = { (key: String) -> String in "filters[\(key)]" }
        static let fmtOptionsKey = { (key: String) -> String in "fmt_options[\(key)]" }
        static let section = "section"
        static let sortBy = "sort_by"
        static let sortOrder = "sort_order"
        static let defaultSectionName = "Products"
        static let defaultPage = 1
        static let defaultPerPage = 30
    }

    struct BrowseGroupsQuery {
        static let format = "%@/browse/groups"
        static let defaultSectionName = "Products"
    }

    struct BrowseFacetsQuery {
        static let format = "%@/browse/facets"
        static let page = "page"
        static let perPage = "num_results_per_page"
        static let offset = "offset"
        static let showHiddenFacets = "fmt_options[show_hidden_facets]"
        static let section = "section"
        static let defaultSectionName = "Products"
        static let defaultPage = 1
        static let defaultPerPage = 20
        static let defaultShowHiddenFacets = false
        static let defaultOffset = 0
    }

    struct BrowseFacetOptionsQuery {
        static let format = "%@/browse/facet_options"
        static let facetName = "facet_name"
        static let showHiddenFacets = "fmt_options[show_hidden_facets]"
        static let section = "section"
        static let defaultSectionName = "Products"
        static let defaultPage = 1
        static let defaultShowHiddenFacets = false
    }

    struct RecommendationsQuery {
        static let format = "%@/recommendations/v1/pods/%@"
        static let section = "section"
        static let numResults = "num_results"
        static let itemID = "item_id"
        static let term = "term"
        static let groupFilter = "filters[group_id]"
        static let facetFilterKey = { (key: String) -> String in "filters[\(key)]" }
        static let defaultSectionName = "Products"
        static let defaultNumResults = 5
    }

    struct Response {
        static let singleSectionResultField = "suggestions"
        static let multiSectionResultField = "sections"
    }

    struct Result {
        static let data = "data"
        static let value = "value"
        static let description = "description"
        static let groups = "groups"
        static let displayName = "display_name"
        static let groupID = "group_id"
        static let path = "path"
    }

    struct Track {
        static let httpMethod = "GET"
        static let apiKey = "key"
        static let baseURLString = "https://ac.cnstrc.com"
        static let expectedStatusCode = 204
        static let autocompleteSection = "section"
        static let searchTerm = "term"
        static let trigger = "tr"
        static let triggerType = "click"
        static let originalQuery = "original_query"
        static let groupName = "group[group_name]"
        static let groupID = "group[group_id]"
        static let name = "name"
        static let customerID = "customer_id"
        static let customerIDs = "customer_ids"
        static let variationID = "variation_id"
        static let resultID = "result_id"
        static let revenue = "revenue"
        static let dateTime = "_dt"
        static let defaultItemSectionName = "Products"
        static let orderID = "order_id"
        static let defaultConversionType = "add_to_cart"
        static let conversionType = "type"
    }

    struct TrackSessionStart {
        static let format = "%@/behavior?action=session_start"
    }

    struct TrackInputFocus {
        static let format = "%@/behavior?action=focus"
    }

    struct TrackAutocompleteSelect {
        static let format = "%@/autocomplete/%@/select"
    }

    struct TrackSearchSubmit {
        static let format = "%@/autocomplete/%@/search"
    }

    struct TrackSearchResultsLoaded {
        static let format = "%@/behavior?action=search-results"
    }

    struct TrackSearchResultClick {
        static let format = "%@/autocomplete/%@/click_through"
    }

    struct TrackBrowseResultsLoaded {
        static let format = "%@/v2/behavioral_action/browse_result_load"
    }

    struct TrackBrowseResultClick {
        static let format = "%@/v2/behavioral_action/browse_result_click"
    }

    struct TrackItemDetailLoad {
        static let format = "%@/v2/behavioral_action/item_detail_load"
    }

    struct TrackRecommendationResultsView {
        static let format = "%@/v2/behavioral_action/recommendation_result_view"
    }

    struct TrackRecommendationResultClick {
        static let format = "%@/v2/behavioral_action/recommendation_result_click"
    }

    struct TrackConversion {
        static let format = "%@/v2/behavioral_action/conversion"
    }

    struct TrackPurchase {
        static let format = "%@/v2/behavioral_action/purchase"
    }

    struct trackQuizResultsLoaded {
        static let format = "%@/v2/behavioral_action/quiz_result_load"
    }

    struct trackQuizResultClick {
        static let format = "%@/v2/behavioral_action/quiz_result_click"
    }

    struct trackQuizConversion {
        static let format = "%@/v2/behavioral_action/quiz_conversion"
    }

    struct Logging {
        private static let prefix = "[ConstructorIO]:"
        private static let format: (_ message: String) -> String = { message in return "\(Logging.prefix) \(message)" }
        static let performURLRequest: (_ request: URLRequest) -> String = { request in return Logging.format("Performing URL Request \(request)") }
        static let recieveURLResponse: (_ response: HTTPURLResponse) -> String = { response in return Logging.format("Recieved URL Response \(response.statusCode)") }
    }

    struct Session {
        static let key = "constructor.io/session"
        static let id = "constructor.io/session/id"
        static let createdAt = "constructor.io/session/createdAt"
        static let clientId = "constructor.io/session/clientId"
    }

    struct Quiz {
        struct Question {
            static let format = "%@/v1/quizzes/%@/next"
        }
        struct Results {
            static let format = "%@/v1/quizzes/%@/results"
        }
        static let quizID = "quiz_id"
        static let answers = "a"
        static let quizVersionID = "quiz_version_id"
        static let quizSessionID = "quiz_session_id"
    }
}
