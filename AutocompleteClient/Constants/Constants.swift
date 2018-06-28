//
//  Constants.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

struct Constants {

    static var versionString: () -> String = {
        var prefix = "cioios-"
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String{
            return "\(prefix)\(version)"
        }else{
            return prefix
        }
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
            static var defaultFontColorNormal: UIColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.0)
            static var defaultFontColorBold: UIColor = UIColor.black
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

    struct Query {
        static let autocompleteKey = "autocomplete_key"
        static let baseURLString = "https://ac.cnstrc.com"
        static let httpMethod = "GET"
        static let queryStringFormat = "%@/%@/%@"
        
        static let sessionIncrementTimeoutInSeconds: TimeInterval = 1800 // 30 mins
    }

    struct AutocompleteQuery {
        static let pathString = "autocomplete"
        static let numResults = "num_results"
        static let numResultsForSectionNamePrefix = "num_results_"
    }

    struct SearchQuery {
        static let pathString = "search"
        static let page = "page"
        static let numResultsPerPage = "num_results_per_page"
        static let numResultsPerPageForSectionNamePrefix = "num_results_per_page_"
    }

    struct Response {
//        static let expectedStatusCode = 200
        static let singleSectionResultField = "suggestions"
        static let multiSectionResultField = "sections"
    }

    struct Result {
        static let data = "data"
        static let value = "value"
        static let description = "description"
        
        // groups
        static let groups = "groups"
        static let displayName = "display_name"
        static let groupID = "group_id"
        static let path = "path"
    }

    struct Track {
        static let httpMethod = "GET"
        static let autocompleteKey = "autocomplete_key"
        static let baseURLString = "https://ac.cnstrc.com"
        static let trackStringFormat = "%@/%@/%@/%@"
        static let trackBehaviorStringFormat = "%@/%@"
        static let expectedStatusCode = 204
        static let dateTime = "_dt"
    }

    struct TrackAutocomplete {
        static let pathString = "autocomplete"
        static let autocompleteSection = "autocomplete_section"
        static let searchTerm = "term"
        static let action = "action"
        static let actionSearchResults = "search-results"
        static let actionFocus = "focus"
        static let actionSessionStart = "session_start"
    }

    struct TrackSearch{
        static let format = "%@/autocomplete/%@/search"
        static let originalQuery = "original_query"
        static let pathBehavior = "behavior"
    }
    
    struct TrackAutocompleteResultClicked {
        static let selectType = "select"
        static let searchType = "search"
        static let type = "select"
        static let trigger = "tr"
        static let triggerType = "click"
        static let originalQuery = "original_query"
        static let groupName = "group[group_name]"
        static let groupID = "group[group_id]"
    }

    struct TrackConversion {
        static let type = "conversion"
        static let item = "item"
        static let itemId = "item_id"
        static let revenue = "revenue"
    }

    struct TrackSearchTermTyped {
        static let type = "search"
    }
    
    struct Logging{
        private static let prefix = "[ConstructorIO]:"
        private static let format: (_ message: String) -> String = { message in return "\(Logging.prefix) \(message)" }
        
        static let performURLRequest: (_ request: URLRequest) -> String = { request in return Logging.format("Performing URL Request \(request)") }
    }
}
