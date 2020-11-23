//
//  CIOAutocompleteResponseParser.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct CIOAutocompleteResponseParser: AbstractAutocompleteResponseParser {

    weak var delegate: ResponseParserDelegate?

    init() {}

    func parse(autocompleteResponseData: Data) throws -> CIOAutocompleteResponse {
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
        return CIOAutocompleteResponse(sections: [Constants.Response.singleSectionResultField: results], json: json)
    }

    private func parse(multiSectionJson json: JSONObject) throws -> CIOAutocompleteResponse {
        guard let sections = json[Constants.Response.multiSectionResultField] as? [String: [JSONObject]] else {
            throw CIOError.invalidResponse
        }

        var results = [String: [CIOAutocompleteResult]]()

        for section in sections {
            results[section.key] = self.jsonToAutocompleteItems(jsonObjects: section.value)
        }

        return CIOAutocompleteResponse(sections: results, json: json)
    }

    fileprivate func jsonToAutocompleteItems(jsonObjects: [JSONObject]) -> [CIOAutocompleteResult] {

        return jsonObjects.compactMap { CIOResult(json: $0) }
                        .enumerated()
                        .reduce([CIOAutocompleteResult](), { (arr, enumeratedAutocompleteResult) in

                            let result = enumeratedAutocompleteResult.element
                            let index = enumeratedAutocompleteResult.offset

                            let first = CIOAutocompleteResult(result: result, group: nil)

                            // If the base result is filtered out, we don't show
                            // the group search options.
                            if let shouldParseResult = self.delegateShouldParseResult(result, nil), shouldParseResult == false {
                                return []
                            }

                            var itemsInGroups: [CIOAutocompleteResult] = []

                            // create a parse handler to avoid code duplication down below
                            let parseItemHandler = { (group: CIOGroup) in
                                let itemInGroup = CIOAutocompleteResult(result: result, group: group)
                                itemsInGroups.append(itemInGroup)
                            }

                            if let groups = result.data.groups {
                                let maximumNumberOfGroupItems = self.delegateMaximumGroupsShownPerResult(result: result, at: index)

                                groupLoop: for group in groups {
                                    if itemsInGroups.count >= maximumNumberOfGroupItems {
                                        break groupLoop
                                    }

                                    if let shouldParseResultInGroup = self.delegateShouldParseResult(result, group) {
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

    fileprivate func delegateMaximumGroupsShownPerResult(result: CIOResult, at index: Int) -> Int {
        return self.delegate?.maximumGroupsShownPerResult(result: result, at: index) ?? Int.max
    }

    fileprivate func delegateShouldParseResult(_ result: CIOResult, _ group: CIOGroup?) -> Bool? {
        return self.delegate?.shouldParseResult(result: result, inGroup: group)
    }
}
