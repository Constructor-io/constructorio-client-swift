//
//  CIOError.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public enum CIOErrorType: Int {
    case noConnection = -1009
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case tooManyRequests = 429
    case internalServerError = 500
    case serviceUnavailable = 503
    case invalidResponse = 1000
    case missingApiKey = 1001
    case unknownError = 1002
}

public struct CIOError: Error, Equatable {
    public let errorType: CIOErrorType
    public let errorMessage: String?

    public init(errorType: CIOErrorType, errorMessage: String? = nil) {
        self.errorType = errorType
        self.errorMessage = errorMessage
    }

    func string() -> String {
        switch self.errorType {
        case .noConnection: return "No Connection"
        case .badRequest: return "Bad Request"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not Found"
        case .methodNotAllowed: return "Method Not Allowed"
        case .tooManyRequests: return "Too Many Requests"
        case .internalServerError: return "Internal Server Error"
        case .serviceUnavailable: return "Service Unavailable"
        case .invalidResponse: return "Invalid Response"
        case .missingApiKey: return "Missing api key"
        case .unknownError: return "Unknown error"
        }
    }

    func description() -> String {
        var message: String

        switch self.errorType {
        case .noConnection: message = "The Internet connection appears to be offline."
        case .badRequest: message = "Your request is invalid."
        case .unauthorized: message = "Your api key is wrong."
        case .forbidden: message = "You are not authorized to access the requested resource."
        case .notFound: message = "The specified resource could not be found."
        case .methodNotAllowed: message = "You tried to access a resource with an invalid method."
        case .tooManyRequests: message = "You’re making too many requests."
        case .internalServerError: message = "We had a problem with our server. Try again later."
        case .serviceUnavailable: message = "We’re temporarially offline for maintanance. Please try again later."
        case .invalidResponse: message = "We had a problem with our server. Try again later."
        case .missingApiKey: message = "Missing api key"
        case .unknownError: message = "Error occurred. Try again later."
        default: message = self.errorMessage!
        }

        return "Error Code \(self.errorType.rawValue): \(self.string()) - \(message)"

    }
}

/**
 Represents any error that may occur in using ConstructorIO services.
 */
//public enum CIOError: Int, Error {
//    case noConnection = -1009
//    case badRequest = 400
//    case unauthorized = 401
//    case forbidden = 403
//    case notFound = 404
//    case methodNotAllowed = 405
//    case tooManyRequests = 429
//    case internalServerError = 500
//    case serviceUnavailable = 503
//    case invalidResponse = 1000
//    case missingApiKey = 1001
//    case unknownError = 1002
//}
//
//extension CIOError: CustomStringConvertible {
//
//    /// The string representation of this CIOError.
//    public var string: String {
//        switch self {
//        case .noConnection: return "No Connection"
//        case .badRequest: return "Bad Request"
//        case .unauthorized: return "Unauthorized"
//        case .forbidden: return "Forbidden"
//        case .notFound: return "Not Found"
//        case .methodNotAllowed: return "Method Not Allowed"
//        case .tooManyRequests: return "Too Many Requests"
//        case .internalServerError: return "Internal Server Error"
//        case .serviceUnavailable: return "Service Unavailable"
//        case .invalidResponse: return "Invalid Response"
//        case .missingApiKey: return "Missing api key"
//        case .unknownError: return "Unknown error"
//        }
//    }
//
//    /// Get a description of this CIOError.
//    public var description: String {
//        let errorMessage: String
//        switch self {
//        case .noConnection: errorMessage = "The Internet connection appears to be offline."
//        case .badRequest: errorMessage = "Your request is invalid."
//        case .unauthorized: errorMessage = "Your api key is wrong."
//        case .forbidden: errorMessage = "You are not authorized to access the requested resource."
//        case .notFound: errorMessage = "The specified resource could not be found."
//        case .methodNotAllowed: errorMessage = "You tried to access a resource with an invalid method."
//        case .tooManyRequests: errorMessage = "You’re making too many requests."
//        case .internalServerError: errorMessage = "We had a problem with our server. Try again later."
//        case .serviceUnavailable: errorMessage = "We’re temporarially offline for maintanance. Please try again later."
//        case .invalidResponse: errorMessage = "We had a problem with our server. Try again later."
//        case .missingApiKey: errorMessage = "Missing api key"
//        case .unknownError: errorMessage = "Error occurred. Try again later."
//        }
//
//        return "Error Code \(self.rawValue): \(self.string) - \(errorMessage)"
//    }
//}

extension CIOError: LocalizedError {

    public var errorDescription: String? {
        return self.string()
    }

}
