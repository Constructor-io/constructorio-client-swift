//
//  CIOResponseParser.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct CIOResponseParser: AbstractResponseParser {

    func parse(autocompleteResponseData: Data) throws -> CIOResponse {
        do {
            let json = try JSONSerialization.jsonObject(with: autocompleteResponseData) as! JSONObject
            // TODO: Use string constants
            let isSingleSection = json.keys.contains(Constants.Response.singleSectionResultField)

            return isSingleSection ? try parse(singleSectionJson: json) : try parse(multiSectionJson: json)
        } catch {
            throw CIOError.invalidResponse
        }
    }

    private func parse(singleSectionJson json: JSONObject) throws -> CIOResponse {
        guard let section = json[Constants.Response.singleSectionResultField] as? [JSONObject] else {
            throw CIOError.invalidResponse
        }

        
        let results = self.jsonToAutocompleteItems(jsonObjects: section)
        var metadata = json
        metadata[Constants.Response.singleSectionResultField] = nil
        return CIOResponse(sections: [Constants.Response.singleSectionResultField: results],
                                     metadata: metadata, json: json)
    }

    private func parse(multiSectionJson json: JSONObject) throws -> CIOResponse {
        guard let sections = json[Constants.Response.multiSectionResultField] as? [String: [JSONObject]] else {
            throw CIOError.invalidResponse
        }

        var results = [String: [CIOResult]]()
        
        for section in sections {
            results[section.key] = self.jsonToAutocompleteItems(jsonObjects: section.value)
        }

        var metadata = json
        metadata[Constants.Response.multiSectionResultField] = nil
        return CIOResponse(sections: results, metadata: metadata, json: json)
    }

    fileprivate func jsonToAutocompleteItems(jsonObjects: [JSONObject]) -> [CIOResult]{
        return jsonObjects.flatMap { CIOAutocompleteResult(json: $0) }
                        .reduce([CIOResult](), { (arr, autocompleteResult) in
                            let first = CIOResult(autocompleteResult: autocompleteResult, group: nil)
                            
                            var itemsInGroups: [CIOResult] = []
                            if let groups = autocompleteResult.groups{
                                for group in groups{
                                    let itemInGroup = CIOResult(autocompleteResult: autocompleteResult, group: group)
                                    itemsInGroups.append(itemInGroup)
                                }
                            }
                            
                            return arr + [first] + itemsInGroups
                        })
    }
    
}
