//
//  CIODebugEvent+Parameters.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension CIODebugEvent {

    /**
     Returns every value of a parameter, wherever the request carries it. `name` is matched against the query
     parameters, then the top-level keys of the JSON body. `items[].item_id` reads a field from each element of a
     body array, and `term` also reads the search term that autocomplete endpoints put in the URL path.
     */
    func parameterValues(for name: String) -> [String] {
        if let range = name.range(of: "[].") {
            let arrayKey = String(name[..<range.lowerBound])
            let fieldKey = String(name[range.upperBound...])
            let elements = self.jsonBody?[arrayKey] as? [[String: Any]] ?? []
            return elements.compactMap { CIODebugEvent.stringValue($0[fieldKey]) }
        }

        let queryValues = self.queryItems.filter { $0.name == name }.compactMap { $0.value }
        if !queryValues.isEmpty {
            return queryValues
        }

        if let value = CIODebugEvent.stringValue(self.jsonBody?[name]) {
            return [value]
        }

        if name == Constants.Track.searchTerm, let term = self.pathSearchTerm {
            return [term]
        }

        return []
    }

    /// The first non-empty value of a parameter
    func parameterValue(for name: String) -> String? {
        return self.parameterValues(for: name).first { !$0.isEmpty }
    }

    /// Autocomplete endpoints carry the term in the path: /autocomplete/{term}/search or /autocomplete/{term}/click_through
    private var pathSearchTerm: String? {
        guard let components = self.url?.pathComponents, components.count >= 3, components[1] == "autocomplete" else { return nil }
        return components[2]
    }

    private var jsonBody: [String: Any]? {
        guard let data = self.body?.data(using: .utf8) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }

    private static func stringValue(_ value: Any?) -> String? {
        switch value {
        case let string as String:
            return string
        case let number as NSNumber:
            return number.stringValue
        default:
            return nil
        }
    }
}
