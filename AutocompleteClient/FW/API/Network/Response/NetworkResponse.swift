//
//  NetworkResponse.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class NetworkResponse: TaskResponse<Data, Error> {

    // Raw response details, kept so debug mode can show why a request failed
    var statusCode: Int?
    var body: Data?
    var underlyingError: Error?
}
