//
//  CIORequestData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol CIORequestData {

    func decorateRequest(requestBuilder: RequestBuilder)

    func url(with baseURL: String) -> String

    func urlWithFormat(baseURL: String, format: String) -> String

    func queryItems(baseItems: [URLQueryItem]) -> [URLQueryItem]

    func httpMethod() -> String

    func httpBody(baseParams: [String: Any]) -> Data?
}

extension CIORequestData {
    // default httpMethod is GET
    func httpMethod() -> String {
        return "GET"
    }

    // default body is null
    func httpBody(baseParams: [String: Any]) -> Data? {
        return nil
    }

    // default query items is all of them
    func queryItems(baseItems: [URLQueryItem]) -> [URLQueryItem] {
        return baseItems
    }

    // default to empty string
    func urlWithFormat(baseURL: String, format: String) -> String {
        return ""
    }
}
