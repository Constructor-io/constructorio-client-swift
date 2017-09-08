//
//  TaskResponse.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

/**
 Task response must be constructed through one of the two constructors so it's impossible to have a response
 that has no data and no error
*/
public class TaskResponse<T, E> {
    let data: T?
    let error: E?

    init(data: T) {
        self.data = data
        self.error = nil
    }

    init(error: E) {
        self.data = nil
        self.error = error
    }
}
