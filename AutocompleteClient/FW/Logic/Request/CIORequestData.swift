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

    func httpMethod() -> String
}

extension CIORequestData {
    // default httpMethod is GET
    func httpMethod() -> String {
        return "GET"
    }
}
