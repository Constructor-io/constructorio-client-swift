//
//  Constants.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public struct Constants {

    public static var versionString: () -> String = {
        var prefix = "cioios-"
        if let version = Bundle(for: ConstructorIO.self).object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return "\(prefix)\(version)"
        } else {
            return prefix
        }
    }

    public struct UI {
        public static let CellIdentifier = "SearchItemCellID"

        public static let defaultFontSize: CGFloat = 16
        public static let defaultRowHeight: CGFloat = 50
        public static let defaultSectionHeaderHeight: CGFloat = 44
        public static let defaultSearchBarPlaceholder = ""
        public static let defaultScreenTitle = ""
        public static let fadeInDuration: TimeInterval = 0.4
        public static let fadeOutDuration: TimeInterval = 0.4
        public static let fireQueryDelayInSeconds: TimeInterval = 0.5

        public struct Color {
            static var defaultFontColorNormal: UIColor = UIColor(red: 0.61, green: 0.61, blue: 0.61, alpha: 1.0)
            static var defaultFontColorBold: UIColor = UIColor.black
        }

        public struct Font {
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

    public struct ABTesting {
        public static let keyFormat = "ef-%@"
    }

    public struct Query {
        public static let apiKey = "key"
        public static let baseURLString = "https://ac.cnstrc.com"
        public static let httpMethod = "GET"
        public static let queryStringFormat = "%@/%@/%@"
        public static let sessionIncrementTimeoutInSeconds: TimeInterval = 1800 // 30 mins
    }

    public struct ClientID {
        public static let key = "kClientID"
    }

    public struct AutocompleteQuery {
        public static let pathString = "autocomplete"
        public static let numResults = "num_results"
        public static let numResultsForSectionNamePrefix = "num_results_"
        public static let queryItemForSection = { (name: String) -> String in return Constants.AutocompleteQuery.numResultsForSectionNamePrefix + name }

        public static let sectionNameSearchSuggestions = "Search Suggestions"
        public static let sectionNameProducts = "Products"

        public static let defaultItemCountPerSection = 10
    }

    public struct Response {
        public static let singleSectionResultField = "suggestions"
        public static let multiSectionResultField = "sections"
    }

    public struct Result {
        public static let data = "data"
        public static let value = "value"
        public static let description = "description"

        // groups
        public static let groups = "groups"
        public static let displayName = "display_name"
        public static let groupID = "group_id"
        public static let path = "path"
    }

    public struct Track {
        public static let httpMethod = "GET"
        public static let apiKey = "key"
        public static let baseURLString = "https://ac.cnstrc.com"
        public static let expectedStatusCode = 204

        public static let autocompleteSection = "autocomplete_section"
        public static let searchTerm = "term"
        public static let searchTermRegex = ".*[A-Za-z0-9].*"
        public static let trigger = "tr"
        public static let triggerType = "click"
        public static let originalQuery = "original_query"
        public static let groupName = "group[group_name]"
        public static let groupID = "group[group_id]"
        public static let name = "name"
        public static let customerID = "customer_id"
        public static let customerIDs = "customer_ids"
        public static let revenue = "revenue"
        public static let dateTime = "_dt"
        public static let defaultItemSectionName = "Products"
        public static let unknownTerm = "TERM_UNKNOWN"
    }

    public struct TrackSessionStart {
        public static let format = "%@/behavior?action=session_start"
    }

    public struct TrackInputFocus {
        public static let format = "%@/behavior?action=focus"
    }

    public struct TrackAutocompleteSelect {
        public static let format = "%@/autocomplete/%@/select"
    }

    public struct TrackSearchSubmit {
        public static let format = "%@/autocomplete/%@/search"
    }

    public struct TrackSearchResultsLoaded {
        public static let format = "%@/behavior?action=search-results"
    }

    public struct TrackSearchResultClick {
        public static let format = "%@/autocomplete/%@/click_through"
    }

    public struct TrackConversion {
        public static let format = "%@/autocomplete/%@/conversion"
    }

    public struct TrackPurchase {
        public static let format = "%@/autocomplete/TERM_UNKNOWN/purchase"
    }

    public struct Logging {
        private static let prefix = "[ConstructorIO]:"
        private static let format: (_ message: String) -> String = { message in return "\(Logging.prefix) \(message)" }
        public static let performURLRequest: (_ request: URLRequest) -> String = { request in return Logging.format("Performing URL Request \(request)") }
    }

    public struct Session {
        public static let key = "constructor.io/session"
        public static let id = "constructor.io/session/id"
        public static let createdAt = "constructor.io/session/createdAt"
    }
}
