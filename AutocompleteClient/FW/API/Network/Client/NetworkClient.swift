//
//  NetworkClient.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol NetworkClient {

    func execute(_ request: URLRequest, completionHandler: @escaping (_ response: NetworkResponse) -> Void)
}
