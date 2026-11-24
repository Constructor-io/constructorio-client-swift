//
//  CIOTrackingEventName.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Enum representing the tracking events the SDK can send, one per tracking method

 The raw values are stable identifiers (i.e. `search_submit`) that are safe to use outside of the app, for example in logs or in test tooling. A case is added whenever a tracking method is added, so include a `default` case when switching over this enum.
 */
public enum CIOTrackingEventName: String, CaseIterable {

    /**
     A new session was started. The SDK sends this event on its own, there is no tracking method for it
     */
    case sessionStart = "session_start"

    /**
     The event sent by `trackInputFocus`
     */
    case inputFocus = "input_focus"

    /**
     The event sent by `trackMediaImpressionView`
     */
    case mediaImpressionView = "media_impression_view"

    /**
     The event sent by `trackMediaImpressionClick`
     */
    case mediaImpressionClick = "media_impression_click"

    /**
     The event sent by `trackResultsImpressionView`
     */
    case resultsImpressionView = "results_impression_view"

    /**
     The event sent by `trackAutocompleteSelect`
     */
    case autocompleteSelect = "autocomplete_select"

    /**
     The event sent by `trackSearchSubmit`
     */
    case searchSubmit = "search_submit"

    /**
     The event sent by `trackSearchResultsLoaded`
     */
    case searchResultsLoaded = "search_results_loaded"

    /**
     The event sent by `trackSearchResultClick`
     */
    case searchResultClick = "search_result_click"

    /**
     The event sent by `trackBrowseResultsLoaded`
     */
    case browseResultsLoaded = "browse_results_loaded"

    /**
     The event sent by `trackBrowseResultClick`
     */
    case browseResultClick = "browse_result_click"

    /**
     The event sent by `trackRecommendationResultsView`
     */
    case recommendationResultsView = "recommendation_results_view"

    /**
     The event sent by `trackRecommendationResultClick`
     */
    case recommendationResultClick = "recommendation_result_click"

    /**
     The event sent by `trackConversion`
     */
    case conversion = "conversion"

    /**
     The event sent by both `trackPurchase` methods
     */
    case purchase = "purchase"

    /**
     The event sent by `trackItemDetailLoad`
     */
    case itemDetailLoad = "item_detail_load"

    /**
     The event sent by `trackQuizResultsLoaded`
     */
    case quizResultsLoaded = "quiz_results_loaded"

    /**
     The event sent by `trackQuizResultClick`
     */
    case quizResultClick = "quiz_result_click"

    /**
     The event sent by `trackQuizConversion`
     */
    case quizConversion = "quiz_conversion"

    /**
     The event sent by `trackGenericResultClick`
     */
    case genericResultClick = "generic_result_click"

    /**
     The event sent by `trackAgentSubmit`
     */
    case agentSubmit = "agent_submit"

    /**
     The event sent by `trackAgentResultLoadStarted`
     */
    case agentResultLoadStarted = "agent_result_load_started"

    /**
     The event sent by `trackAgentResultLoadFinished`
     */
    case agentResultLoadFinished = "agent_result_load_finished"

    /**
     The event sent by `trackAgentResultClick`
     */
    case agentResultClick = "agent_result_click"

    /**
     The event sent by `trackAgentResultView`
     */
    case agentResultView = "agent_result_view"

    /**
     The event sent by `trackAgentSearchSubmit`
     */
    case agentSearchSubmit = "agent_search_submit"

    /**
     The event sent by `trackProductInsightsAgentFocus`
     */
    case productInsightsAgentFocus = "product_insights_agent_focus"

    /**
     The event sent by `trackProductInsightsAgentOutOfView`
     */
    case productInsightsAgentOutOfView = "product_insights_agent_out_of_view"

    /**
     The event sent by `trackProductInsightsAgentView`, when the Product Insights Agent element becomes visible
     */
    case productInsightsAgentView = "product_insights_agent_view"

    /**
     The event sent by `trackProductInsightsAgentViews`, which reports the periods of time the Product Insights Agent element was visible
     */
    case productInsightsAgentViews = "product_insights_agent_views"

    /**
     The event sent by `trackProductInsightsAgentQuestionClick`
     */
    case productInsightsAgentQuestionClick = "product_insights_agent_question_click"

    /**
     The event sent by `trackProductInsightsAgentQuestionSubmit`
     */
    case productInsightsAgentQuestionSubmit = "product_insights_agent_question_submit"

    /**
     The event sent by `trackProductInsightsAgentAnswerFeedback`
     */
    case productInsightsAgentAnswerFeedback = "product_insights_agent_answer_feedback"

    /**
     The event sent by `trackProductInsightsAgentResultClick`
     */
    case productInsightsAgentResultClick = "product_insights_agent_result_click"

    /**
     The event sent by `trackProductInsightsAgentAnswerView`
     */
    case productInsightsAgentAnswerView = "product_insights_agent_answer_view"
}
