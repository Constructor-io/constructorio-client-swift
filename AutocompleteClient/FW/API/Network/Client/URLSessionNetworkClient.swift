//
//  URLSessionNetworkClient.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class URLSessionNetworkClient: NetworkClient {

    func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            // Check for transport errors
            if let error = error {
//                let err: Error = CIOError(rawValue: (error as NSError).code) ?? error
                let err: Error = CIOError(errorType: CIOErrorType(rawValue: (error as NSError).code) ?? CIOErrorType.unknownError)
                completionHandler(NetworkResponse(error: err))
                return
            }

            // Check for response code
            guard let httpResponse = response as? HTTPURLResponse else {
//                completionHandler(NetworkResponse(error: CIOError.unknownError))
                completionHandler(NetworkResponse(error: CIOError(errorType: .unknownError)))
                return
            }

            ConstructorIO.logger.log(Constants.Logging.recieveURLResponse(httpResponse))

            if !(200...299).contains(httpResponse.statusCode) {

                // Check for response string
                if let responseString = String(bytes: data!, encoding: .utf8) {

                    // Check if response code corresponds to a ConstructorIOError
                    if let constructorError = CIOError(rawValue: httpResponse.statusCode) {
                        completionHandler(NetworkResponse(error: constructorError))
                        return
                    }
                }
            // Check if response code corresponds to a ConstructorIOError
//            if let constructorError = CIOError(rawValue: httpResponse.statusCode) {
//                completionHandler(NetworkResponse(error: constructorError))
//                return
//            }

            // Check if response code corresponds to a ConstructorIOError
            if let constructorErrorType = CIOErrorType(rawValue: httpResponse.statusCode) {
                let constructorError = CIOError(errorType: constructorErrorType)
                completionHandler(NetworkResponse(error: constructorError))
                return
            }

            // Check if response code corresponds to a ConstructorIOError
//            if let constructorError = CIOError(rawValue: httpResponse.statusCode) {
//                completionHandler(NetworkResponse(error: constructorError))
//                return
//            }

            // No errors
            guard let data = data else {
                completionHandler(NetworkResponse(error: CIOError(errorType: .unknownError)))
                return
            }

            completionHandler(NetworkResponse(data: data))
        }

        task.resume()

        ConstructorIO.logger.log(Constants.Logging.performURLRequest(request))
    }
}
