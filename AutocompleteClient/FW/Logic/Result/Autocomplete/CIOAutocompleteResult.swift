//
//  CIOAutocompleteResult.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Class encapsulating a single autocomplete result item.
 */
@objc public class CIOAutocompleteResult: NSObject {

    /// Convenience dictionary that contains all String only properties of this item.
    public let stringData: [String: String]

    /// The nested data JSON object of this item.
    public let data: JSONObject

    public var groups: [CIOGroup]?

    /// The ID of this item.
    public let id: String

    /// The name of this item.
    public let value: String

    /// The raw JSON of this item.
    public let json: JSONObject

    public init?(json: JSONObject) {
        guard let value = json[Constants.Result.value] as? String else {
            return nil
        }

        self.data = json[Constants.Result.data] as? JSONObject ?? [:]

        guard let id = data["id"] as? String else{
            return nil
        }

        var stringData = [String: String]()
        // Build stringData dictionary
        data.forEach { key, val in
            // If value is a String, add to stringData
            guard let stringVal = val as? String else { return }
            stringData[key] = stringVal
        }

        // parse groups
        if let data = json[Constants.Result.data] as? [String: Any],
            let groupsArr = data[Constants.Result.groups] as? [[String:Any]]{
            var groups = [CIOGroup]()
            for dict in groupsArr{

                guard let name = dict[Constants.Result.displayName] as? String else{
                    continue
                }

                guard let groupID = dict[Constants.Result.groupID] as? String else{
                    continue
                }

                let path = dict[Constants.Result.path] as? String

                groups.append(CIOGroup(displayName: name, groupID: groupID, path: path))
            }
            self.groups = groups
        }else{
            self.groups = nil
        }

        self.stringData = stringData
        self.value = value
        self.id = id
        self.json = json
    }
}
