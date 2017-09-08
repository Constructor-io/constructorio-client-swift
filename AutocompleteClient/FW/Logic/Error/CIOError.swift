//
//  CIOError.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Represents any error that may occur in using ConstructorIO services.
 */
public enum CIOError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case tooManyRequests = 429
    case internalServerError = 500
    case serviceUnavailable = 503
    case invalidResponse = 1000
    case missingAutocompleteKey = 1001
    case unknownError = 1002
}

extension CIOError: CustomStringConvertible {

    /// The string representation of this CIOError.
    public var string: String {
        switch self {
        case .badRequest: return "Bad Request"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not Found"
        case .methodNotAllowed: return "Method Not Allowed"
        case .tooManyRequests: return "Too Many Requests"
        case .internalServerError: return "Internal Server Error"
        case .serviceUnavailable: return "Service Unavailable"
        case .invalidResponse: return "Invalid Response"
        case .missingAutocompleteKey: return "Missing Autocomplete Key"
        case .unknownError: return "Unknown error"
        }
    }

    /// Get a description of this CIOError.
    public var description: String {
        let errorMessage: String
        switch self {
        case .badRequest: errorMessage = "Your request is invalid."
        case .unauthorized: errorMessage = "Your API token is wrong."
        case .forbidden: errorMessage = "You are not authorized to access the requested resource."
        case .notFound: errorMessage = "The specified resource could not be found."
        case .methodNotAllowed: errorMessage = "You tried to access a resource with an invalid method."
        case .tooManyRequests: errorMessage = "You’re making too many requests."
        case .internalServerError: errorMessage = "We had a problem with our server. Try again later."
        case .serviceUnavailable: errorMessage = "We’re temporarially offline for maintanance. Please try again later."
        case .invalidResponse: errorMessage = "We had a problem with our server. Try again later."
        case .missingAutocompleteKey: errorMessage = "Missing Autocomplete Key"
        case .unknownError: errorMessage = "Error occurred. Try again later."
        }

        return "Error Code \(self.rawValue): \(self.string) - \(errorMessage)"
    }
}

extension CIOError: LocalizedError {

    public var errorDescription: String? {
        return self.string
    }

}
