//
//  CIOResponseParser.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct CIOResponseParser: AbstractResponseParser {

    weak var delegate: ResponseParserDelegate?
    
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
        
        for section in sections{
            if self.delegate?.shouldParseResults(inSectionWithName: section.key) ?? true{
                results[section.key] = self.jsonToAutocompleteItems(jsonObjects: section.value)
            }
        }

        var metadata = json
        metadata[Constants.Response.multiSectionResultField] = nil
        return CIOResponse(sections: results, metadata: metadata, json: json)
    }

    fileprivate func jsonToAutocompleteItems(jsonObjects: [JSONObject]) -> [CIOResult]{
        return jsonObjects.flatMap { CIOAutocompleteResult(json: $0) }
                        .reduce([CIOResult](), { (arr, autocompleteResult) in
                            let first = CIOResult(autocompleteResult: autocompleteResult, group: nil)
                            
                            // If the base result is filtered out, we don't show
                            // the group search options.
                            if !self.delegateFilter(autocompleteResult, nil){
                                return []
                            }
                            
                            var itemsInGroups: [CIOResult] = []
                            if let groups = autocompleteResult.groups{
                                for group in groups{
                                    if self.delegateFilter(autocompleteResult, group){
                                        let itemInGroup = CIOResult(autocompleteResult: autocompleteResult, group: group)
                                        itemsInGroups.append(itemInGroup)
                                    }
                                }
                            }
                            
                            return arr + [first] + itemsInGroups
                        })
    }
    
    fileprivate func delegateFilter(_ result: CIOAutocompleteResult, _ group: CIOGroup?) -> Bool{
        return self.delegate?.shouldParseResult(result: result, inGroup: group) ?? true
    }
}
