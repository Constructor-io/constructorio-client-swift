//
//  CIOAutocompleteResponseParser.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOAutocompleteResponseParser: AbstractAutocompleteResponseParser {

    public var delegate: ResponseParserDelegate?
    public var maxGroups: Int? = 0
    
    init() {}

    public func parse(autocompleteResponseData: Data) throws -> CIOAutocompleteResponse {
        do {
            if let json = try JSONSerialization.jsonObject(with: autocompleteResponseData) as? JSONObject {
                let isSingleSection = json.keys.contains(Constants.Response.singleSectionResultField)
                return isSingleSection ? try parse(singleSectionJson: json) : try parse(multiSectionJson: json)
            } else {
                throw CIOError(errorType: .invalidResponse)
            }
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }
    }

    private func parse(singleSectionJson json: JSONObject) throws -> CIOAutocompleteResponse {
        guard let section = json[Constants.Response.singleSectionResultField] as? [JSONObject] else {
            throw CIOError(errorType: .invalidResponse)
        }
        guard let request: JSONObject = json["request"] as? JSONObject else {
            throw CIOError(errorType: .invalidResponse)
        }

        let results = self.jsonToAutocompleteItems(jsonObjects: section)
        var metadata = json
        metadata[Constants.Response.singleSectionResultField] = nil

        return CIOAutocompleteResponse(sections: [Constants.Response.singleSectionResultField: results], json: json, request: request)
    }

    private func parse(multiSectionJson json: JSONObject) throws -> CIOAutocompleteResponse {
        guard let sections = json[Constants.Response.multiSectionResultField] as? [String: [JSONObject]] else {
            throw CIOError(errorType: .invalidResponse)
        }
        guard let request: JSONObject = json["request"] as? JSONObject else {
            throw CIOError(errorType: .invalidResponse)
        }

        var results = [String: [CIOAutocompleteResult]]()

        for section in sections {
            results[section.key] = self.jsonToAutocompleteItems(jsonObjects: section.value)
        }

        var metadata = json
        metadata[Constants.Response.multiSectionResultField] = nil
        return CIOAutocompleteResponse(sections: results, json: json, request: request)
    }

    fileprivate func jsonToAutocompleteItems(jsonObjects: [JSONObject]) -> [CIOAutocompleteResult] {

        return jsonObjects.compactMap { CIOResult(json: $0) }
            .enumerated()
            .reduce([CIOAutocompleteResult](), { arr, enumeratedAutocompleteResult in

                let autocompleteResult = enumeratedAutocompleteResult.element
                let index = enumeratedAutocompleteResult.offset

                let first = CIOAutocompleteResult(result: autocompleteResult, group: nil)

                // If the base result is filtered out, we don't show
                // the group search options.
                if let shouldParseResult = self.delegateShouldParseResult(autocompleteResult, nil), shouldParseResult == false {
                    return []
                }

                var itemsInGroups: [CIOAutocompleteResult] = []

                // create a parse handler to avoid code duplication down below
                let parseItemHandler = { (group: CIOGroup) in
                    let itemInGroup = CIOAutocompleteResult(result: autocompleteResult, group: group)
                    itemsInGroups.append(itemInGroup)
                }

                let groups = autocompleteResult.data.groups
                let maximumNumberOfGroupItems = self.delegateMaximumGroupsShownPerResult(result: autocompleteResult, at: index)

                groupLoop: for group in groups {
                    if itemsInGroups.count >= maximumNumberOfGroupItems {
                        break groupLoop
                    }

                    if let shouldParseResultInGroup = self.delegateShouldParseResult(autocompleteResult, group) {
                        if shouldParseResultInGroup {
                            // method implemented by the delegate and returns true
                            parseItemHandler(group)
                        }
                    } else {
                        // method not implemeneted by the delegate
                        // we parse the result by default
                        parseItemHandler(group)
                    }
                }

                return arr + [first] + itemsInGroups
            })
    }

    fileprivate func delegateMaximumGroupsShownPerResult(result: CIOResult, at index: Int) -> Int {
        return self.delegate?.maximumGroupsShownPerResult(result: result, at: index) ?? self.maxGroups!
    }

    fileprivate func delegateShouldParseResult(_ result: CIOResult, _ group: CIOGroup?) -> Bool? {
        return self.delegate?.shouldParseResult(result: result, inGroup: group)
    }
}
