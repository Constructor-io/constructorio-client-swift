//
//  NetworkResponse.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class NetworkResponse: TaskResponse<Data, Error> {

    // The details below describe the raw response. They are kept so that debug mode can show why a request failed, and only debug mode reads them.
    // They and the initializers below are internal on purpose: they are not part of the public API of the SDK, although NetworkResponse is public.

    // The HTTP status code, nil if no HTTP response was received
    private(set) var statusCode: Int?

    // The raw response body, which is also kept when the request failed
    private(set) var body: Data?

    // The transport error reported by URLSession, such as a timeout or a lost connection
    private(set) var underlyingError: Error?

    convenience init(data: Data, statusCode: Int?) {
        self.init(data: data)
        self.statusCode = statusCode
        self.body = data
    }

    convenience init(error: Error, statusCode: Int?, body: Data?, underlyingError: Error? = nil) {
        self.init(error: error)
        self.statusCode = statusCode
        self.body = body
        self.underlyingError = underlyingError
    }
}
