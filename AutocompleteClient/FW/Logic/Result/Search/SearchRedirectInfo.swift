//
//  SearchRedirectInfo.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct SearchRedirectInfo {
    let url: String
    let matchID: Int
    let ruleID: Int
}

extension SearchRedirectInfo {
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
