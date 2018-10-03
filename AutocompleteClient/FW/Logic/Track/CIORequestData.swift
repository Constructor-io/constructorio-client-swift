//
//  CIORequestData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol CIORequestData{
    
    var url: String { get }

    func decorateRequest(requestBuilder: RequestBuilder)
    
    func httpMethod() -> String
}

public extension CIORequestData{
    // default httpMethod is GET
    public func httpMethod() -> String{
        return "GET"
    }
}
