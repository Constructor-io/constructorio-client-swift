//
//  CIORequestData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol CIORequestData {

    var url: String { get }

    func decorateRequest(requestBuilder: RequestBuilder)

    func httpMethod() -> String
}

extension CIORequestData {
    // default httpMethod is GET
    func httpMethod() -> String {
        return "GET"
    }
}
