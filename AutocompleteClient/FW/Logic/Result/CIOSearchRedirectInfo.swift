//
//  CIOSearchRedirectInfo.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the Search redirect info
 */
public struct CIOSearchRedirectInfo {
    /**
     The redirect URL
     */
    public let url: String

    /**
     Match ID
     */
    public let matchID: Int

    /**
     Rule ID
     */
    public let ruleID: Int
}

public extension CIOSearchRedirectInfo {
    /**
     Create a Search redirect info object
     
     -  Parameters:
        - object: JSON Object
     */
    init?(object: JSONObject?) {
        guard let json = object else { return nil }
        guard let data = json["data"] as? JSONObject else { return nil }
        guard let url = data["url"] as? String else { return nil }
        guard let matchID = data["match_id"] as? Int else { return nil }
        guard let ruleID = data["rule_id"] as? Int else { return nil }

        self.url = url
        self.matchID = matchID
        self.ruleID = ruleID
    }
}
