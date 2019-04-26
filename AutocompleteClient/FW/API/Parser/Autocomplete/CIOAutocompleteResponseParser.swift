//
//  CIOAutocompleteResponseParser.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOAutocompleteResponseParser: AbstractAutocompleteResponseParser {

    public weak var delegate: ResponseParserDelegate?

    public init() {}

    public func parse(autocompleteResponseData: Data) throws -> CIOAutocompleteResponse {
        do {
            if let json = try JSONSerialization.jsonObject(with: autocompleteResponseData) as? JSONObject {
                let isSingleSection = json.keys.contains(Constants.Response.singleSectionResultField)
                return isSingleSection ? try parse(singleSectionJson: json) : try parse(multiSectionJson: json)
            } else {
                throw CIOError.invalidResponse
            }
        } catch {
            throw CIOError.invalidResponse
        }
    }

    private func parse(singleSectionJson json: JSONObject) throws -> CIOAutocompleteResponse {
        guard let section = json[Constants.Response.singleSectionResultField] as? [JSONObject] else {
            throw CIOError.invalidResponse
        }

        let results = self.jsonToAutocompleteItems(jsonObjects: section)
        var metadata = json
        metadata[Constants.Response.singleSectionResultField] = nil
        return CIOAutocompleteResponse(sections: [Constants.Response.singleSectionResultField: results],
                                     metadata: metadata, json: json)
    }

    private func parse(multiSectionJson json: JSONObject) throws -> CIOAutocompleteResponse {
        guard let sections = json[Constants.Response.multiSectionResultField] as? [String: [JSONObject]] else {
            throw CIOError.invalidResponse
        }

        var results = [String: [CIOResult]]()

        for section in sections {
            results[section.key] = self.jsonToAutocompleteItems(jsonObjects: section.value)
        }

        var metadata = json
        metadata[Constants.Response.multiSectionResultField] = nil
        return CIOAutocompleteResponse(sections: results, metadata: metadata, json: json)
    }

    fileprivate func jsonToAutocompleteItems(jsonObjects: [JSONObject]) -> [CIOResult] {

        return jsonObjects.flatMap { CIOAutocompleteResult(json: $0) }
                        .enumerated()
                        .reduce([CIOResult](), { (arr, enumeratedAutocompleteResult) in

                            let autocompleteResult = enumeratedAutocompleteResult.element
                            let index = enumeratedAutocompleteResult.offset

                            let first = CIOResult(autocompleteResult: autocompleteResult, group: nil)

                            // If the base result is filtered out, we don't show
                            // the group search options.
                            if let shouldParseResult = self.delegateShouldParseResult(autocompleteResult, nil), shouldParseResult == false {
                                return []
                            }

                            var itemsInGroups: [CIOResult] = []

                            // create a parse handler to avoid code duplication down below
                            let parseItemHandler = { (group: CIOGroup) in
                                let itemInGroup = CIOResult(autocompleteResult: autocompleteResult, group: group)
                                itemsInGroups.append(itemInGroup)
                            }

                            if let groups = autocompleteResult.groups {
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
                            }

                            return arr + [first] + itemsInGroups
                        })
    }

    fileprivate func delegateMaximumGroupsShownPerResult(result: CIOAutocompleteResult, at index: Int) -> Int {
        return self.delegate?.maximumGroupsShownPerResult(result: result, at: index) ?? Int.max
    }

    fileprivate func delegateShouldParseResult(_ result: CIOAutocompleteResult, _ group: CIOGroup?) -> Bool? {
        return self.delegate?.shouldParseResult(result: result, inGroup: group)
    }
}
