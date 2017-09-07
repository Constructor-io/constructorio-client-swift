//
//  URLSessionNetworkClient.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class URLSessionNetworkClient: NetworkClient {

    func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let err = error {
                completionHandler(NetworkResponse(error: err))
                return
            }

            // Check for response code
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(NetworkResponse(error: CIOError.unknownError))
                return
            }

            // Check if response code corresponds to a ConstructorIOError
            if let constructorError = CIOError(rawValue: httpResponse.statusCode) {
                completionHandler(NetworkResponse(error: constructorError))
            }

            // No errors
            guard let data = data else {
                completionHandler(NetworkResponse(error: CIOError.unknownError))
                return
            }

            completionHandler(NetworkResponse(data: data))
        }

        task.resume()
    }
}
