//
//  CIODebugEvent.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 A snapshot of a tracking event sent while debug mode is enabled. The request is captured after PII obfuscation, exactly as it was sent.
 */
public struct CIODebugEvent {

    /**
     Order in which the event was fired, starting at 1 for each ConstructorIO instance. Responses can arrive out of order, so use this (not delivery order) when reasoning about sequences.
     */
    public let sequence: Int

    /**
     The tracking event that was fired
     */
    public let name: CIOTrackingEventName

    /**
     When the event was fired
     */
    public let firedAt: Date

    /**
     The request URL
     */
    public let url: URL?

    /**
     The HTTP method of the request
     */
    public let httpMethod: String

    /**
     The query parameters of the request
     */
    public let queryItems: [URLQueryItem]

    /**
     The request body, if any, decoded as UTF-8
     */
    public let body: String?

    /**
     The error returned by the request, or nil if it succeeded
     */
    public internal(set) var error: Error?

    /**
     The HTTP status code of the response, or nil if no response was received (e.g. no connection)
     */
    public internal(set) var statusCode: Int?

    /**
     The response body, if any, decoded as UTF-8
     */
    public internal(set) var responseBody: String?

    /**
     The transport-level error (e.g. timeout, no connection), if the request never got a response
     */
    public internal(set) var underlyingError: Error?

    public var succeeded: Bool {
        return self.error == nil
    }

    /**
     A human-readable explanation of why the request failed, or nil if it succeeded. Prefers the server's message, then the transport error, then a generic description of the status code.
     */
    public var errorMessage: String? {
        guard let error = self.error else { return nil }
        if let message = (error as? CIOError)?.errorMessage, !message.isEmpty {
            return message
        }
        if let underlyingError = self.underlyingError {
            return underlyingError.localizedDescription
        }
        if let cioError = error as? CIOError {
            return cioError.description()
        }
        return error.localizedDescription
    }

    /**
     Returns the first value of the query parameter with the given name
     */
    public func queryValue(for name: String) -> String? {
        return self.queryItems.first(where: { $0.name == name })?.value
    }

    init(sequence: Int, name: CIOTrackingEventName, firedAt: Date, request: URLRequest, error: Error? = nil) {
        self.sequence = sequence
        self.name = name
        self.firedAt = firedAt
        self.url = request.url
        self.httpMethod = request.httpMethod ?? "GET"
        self.queryItems = request.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false)?.queryItems } ?? []
        self.body = request.httpBody.flatMap { String(data: $0, encoding: .utf8) }
        self.error = error
    }

    mutating func complete(with response: NetworkResponse) {
        self.error = response.error
        self.statusCode = response.statusCode
        self.responseBody = response.body.flatMap { $0.isEmpty ? nil : String(data: $0, encoding: .utf8) }
        self.underlyingError = response.underlyingError
    }
}

extension CIODebugEvent: CustomStringConvertible {
    /// "OK", or "FAILED (<reason>)"
    public var statusDescription: String {
        if let cioError = self.error as? CIOError {
            return "FAILED (\(cioError.errorType)\(cioError.errorMessage.map { ": \($0)" } ?? ""))"
        } else if let error = self.error {
            return "FAILED (\(error.localizedDescription))"
        }
        return "OK"
    }

    public var description: String {
        var lines = ["#\(self.sequence) \(self.name.rawValue) \(self.statusDescription)", "  \(self.httpMethod) \(self.url?.absoluteString ?? "<no url>")"]
        if let body = self.body {
            lines.append("  body: \(body)")
        }
        if !self.succeeded {
            if let statusCode = self.statusCode {
                lines.append("  status code: \(statusCode)")
            }
            if let errorMessage = self.errorMessage {
                lines.append("  error: \(errorMessage)")
            }
            if let responseBody = self.responseBody {
                lines.append("  response: \(responseBody)")
            }
        }
        return lines.joined(separator: "\n")
    }
}
