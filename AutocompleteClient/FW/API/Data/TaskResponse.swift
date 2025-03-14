//
//  TaskResponse.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Task response must be constructed through one of the two constructors so it's impossible to have a response
 that has no data and no error
*/
public class TaskResponse<T, E> {
    public let data: T?
    public let error: E?

    public init(data: T) {
        self.data = data
        self.error = nil
    }

    public init(error: E) {
        self.data = nil
        self.error = error
    }
}
