//
//  CIOProductInsightsAgentFeedbackLabel.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Enum representing the feedback a user can give on a Product Insights Agent answer
 */
public enum CIOProductInsightsAgentFeedbackLabel: String {

    /**
     The user found the answer useful
     */
    case thumbsUp = "thumbs_up"

    /**
     The user did not find the answer useful
     */
    case thumbsDown = "thumbs_down"
}
