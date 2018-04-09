//
//  Constants.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

struct Constants {

    struct UI {
        static let CellIdentifier = "SearchItemCellID"
        
        static let defaultFontSize: CGFloat = 16
        static let defaultRowHeight: CGFloat = 44
        static let defaultSectionHeaderHeight: CGFloat = 44
        static let defaultSearchBarPlaceholder = ""
        static let defaultScreenTitle = ""
        static let fadeInDuration: TimeInterval = 0.4
        static let fadeOutDuration: TimeInterval = 0.4
        static let fireQueryDelayInSeconds: TimeInterval = 0.5

        struct Font {
            static var defaultFontNormal: UIFont {
                let fontSize: CGFloat = Constants.UI.defaultFontSize
                return UIFont.systemFont(ofSize: fontSize)
            }

            static var defaultFontBold: UIFont {
                let fontSize: CGFloat = Constants.UI.defaultFontSize
                return UIFont.boldSystemFont(ofSize: fontSize)
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
        static let expectedStatusCode = 204
    }

    struct TrackAutocomplete {
        static let pathString = "autocomplete"
        static let autocompleteSection = "autocomplete_section"
    }

    struct TrackAutocompleteResultClicked {
        static let selectType = "select"
        static let searchType = "search"
        static let type = "select"
        static let trigger = "tr"
        static let triggerType = "click"
        static let originalQuery = "original_query"
        static let dateTime = "_dt"
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
}
