//
//  CIODebugEvent.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing a tracking event that was sent while debug mode was enabled, with its request and the outcome of that request

 The request is reported exactly as it was sent: PII found in the URL path and query is obfuscated, but the request and response bodies are not redacted.
 */
public struct CIODebugEvent {

    /**
     A number that increases with every tracking event its `ConstructorIO` instance records, in the order the tracking methods were called. Calls made while debug mode is off are not counted. Use it (and not the order in which events are delivered) to tell which event was fired first
     */
    public let sequence: Int

    /**
     The tracking event that was sent
     */
    public let name: CIOTrackingEventName

    /**
     The time at which the tracking method was called
     */
    public let firedAt: Date

    /**
     The URL the request was sent to
     */
    public let url: URL?

    /**
     The HTTP method of the request
     */
    public let httpMethod: String

    /**
     The query parameters of the request, with their names and values percent-decoded
     */
    public let queryItems: [URLQueryItem]

    /**
     The body of the request, or nil if it had none. It is not redacted
     */
    public let body: String?

    /**
     The error that the completion handler of the tracking call received, or nil if it received none. It can be nil for an event that failed, see `succeeded`
     */
    public let error: Error?

    /**
     The HTTP status code of the response, or nil if no response was received
     */
    public let statusCode: Int?

    /**
     The body of the response, or nil if it was empty or no response was received. It is not redacted
     */
    public let responseBody: String?

    /**
     The transport error (i.e. a timeout or a lost connection) of a request that did not get a complete response
     */
    public let underlyingError: Error?

    /**
     Whether the event was accepted, which means that its request got a response with a status code in the 2xx range

     The completion handler of a tracking call only receives an error for some of the failing status codes, so an event can have failed although its `error` is nil.
     */
    public var succeeded: Bool {
        guard self.error == nil else {
            return false
        }
        guard let statusCode = self.statusCode else {
            return true
        }
        return (200..<300).contains(statusCode)
    }

    /**
     The reason why the event failed, or nil if it succeeded. It is the message returned by the server if there is one, otherwise the transport error, otherwise a description of the status code
     */
    public var errorMessage: String? {
        guard !self.succeeded else {
            return nil
        }
        if let serverMessage = self.serverMessage {
            return serverMessage
        }
        if let underlyingError = self.underlyingError, !underlyingError.localizedDescription.isEmpty {
            return underlyingError.localizedDescription
        }
        if let error = self.error {
            // The description is built from the error type alone, as the server sent no message to add to it
            let description = (error as? CIOError).map { CIOError(errorType: $0.errorType).description() } ?? error.localizedDescription
            return description.isEmpty ? String(describing: error) : description
        }
        return self.statusCode.map { "HTTP \($0): \(HTTPURLResponse.localizedString(forStatusCode: $0))" }
    }

    /**
     Get the value of a query parameter of the request

     - Parameters:
        - name: The name of the query parameter

     - Returns: The value of the first query parameter with that name, or nil if there is none

     ### Usage Example: ###
     ```
     let section = event.queryValue(for: "section")
     ```
     */
    public func queryValue(for name: String) -> String? {
        return self.queryItems.first(where: { $0.name == name })?.value
    }

    private var serverMessage: String? {
        if let message = (self.error as? CIOError)?.errorMessage, !message.isEmpty {
            return message
        }

        // The message is only read into the error for the status codes that the SDK reports as errors, so for the other ones it is looked up in the response
        guard let data = self.responseBody?.data(using: .utf8),
              let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
              let message = json["message"] as? String, !message.isEmpty else {
            return nil
        }
        return message
    }

    init(sequence: Int, name: CIOTrackingEventName, firedAt: Date, request: URLRequest, response: NetworkResponse) {
        self.sequence = sequence
        self.name = name
        self.firedAt = firedAt
        self.url = request.url
        self.httpMethod = request.httpMethod ?? "GET"
        self.queryItems = request.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false)?.queryItems } ?? []
        self.body = CIODebugEvent.text(from: request.httpBody)
        self.error = response.error
        self.statusCode = response.statusCode
        self.responseBody = CIODebugEvent.text(from: response.body)
        self.underlyingError = response.underlyingError
    }

    private static func text(from data: Data?) -> String? {
        guard let data = data, !data.isEmpty else {
            return nil
        }

        // Bytes that are not valid UTF-8 are replaced, so that such a body is still shown. The failable initializer would drop the whole body.
        // swiftlint:disable optional_data_string_conversion
        return String(decoding: data, as: UTF8.self)
        // swiftlint:enable optional_data_string_conversion
    }
}

extension CIODebugEvent: CustomStringConvertible {

    /**
     A summary of the event over several lines: its sequence number, name and outcome, then the request. For an event that failed, the status code, the error message and the response body are added
     */
    public var description: String {
        var lines = [
            "#\(self.sequence) \(self.name.rawValue) \(self.succeeded ? "OK" : "FAILED")",
            "  \(self.httpMethod) \(self.url?.absoluteString ?? "<no url>")"
        ]
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
