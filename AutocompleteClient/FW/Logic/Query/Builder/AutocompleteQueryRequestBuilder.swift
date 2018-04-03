//
//  AutocompleteQueryRequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class AutocompleteQueryRequestBuilder: QueryRequestBuilder {

    init(query: CIOAutocompleteQuery, autocompleteKey: String, session: Int, clientID: String?) {
        super.init(query: query.query, autocompleteKey: autocompleteKey)
        set(numResults: query.numResults)
        set(numResultsForSection: query.numResultsForSection)
        set(session: session)
        if let cID = clientID{
            self.set(clientID: cID)
        }
    }
    
    func set(clientID: String){
        queryItems.append(URLQueryItem(name: "i", value: clientID))
    }
    
    func set(session: Int){
        queryItems.append(URLQueryItem(name: "s", value: String(session)))
    }

    func set(numResults: Int?) {
        guard let numResults = numResults else { return }
        queryItems.append(URLQueryItem(name: Constants.AutocompleteQuery.numResults, value: String(numResults)))
    }

    func set(numResultsForSection: [String: Int]?) {
        guard let numResultsForSection = numResultsForSection else { return }
        numResultsForSection.forEach {
            let name = AutocompleteQueryRequestBuilder.queryItemNameForSection(withName: $0.key)
            queryItems.append(URLQueryItem(name: name, value: String($0.value)))
        }
    }

    override func getQueryPathString() -> String {
        return Constants.AutocompleteQuery.pathString
    }

    static func queryItemNameForSection(withName name: String) -> String {
        return Constants.AutocompleteQuery.numResultsForSectionNamePrefix + name
    }
}
