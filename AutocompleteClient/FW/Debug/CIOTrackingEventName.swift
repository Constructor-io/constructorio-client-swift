//
//  CIOTrackingEventName.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Stable identifiers for every tracking event the SDK can send. Raw values are suitable for use in external configuration (i.e. journey definitions).
 */
public enum CIOTrackingEventName: String, CaseIterable {
    case sessionStart = "session_start"
    case inputFocus = "input_focus"
    case mediaImpressionView = "media_impression_view"
    case mediaImpressionClick = "media_impression_click"
    case resultsImpressionView = "results_impression_view"
    case autocompleteSelect = "autocomplete_select"
    case searchSubmit = "search_submit"
    case searchResultsLoaded = "search_results_loaded"
    case searchResultClick = "search_result_click"
    case browseResultsLoaded = "browse_results_loaded"
    case browseResultClick = "browse_result_click"
    case recommendationResultsView = "recommendation_results_view"
    case recommendationResultClick = "recommendation_result_click"
    case conversion = "conversion"
    case purchase = "purchase"
    case itemDetailLoad = "item_detail_load"
    case quizResultsLoaded = "quiz_results_loaded"
    case quizResultClick = "quiz_result_click"
    case quizConversion = "quiz_conversion"
    case genericResultClick = "generic_result_click"
    case agentSubmit = "agent_submit"
    case agentResultLoadStarted = "agent_result_load_started"
    case agentResultLoadFinished = "agent_result_load_finished"
    case agentResultClick = "agent_result_click"
    case agentResultView = "agent_result_view"
    case agentSearchSubmit = "agent_search_submit"
}
