//
//  ClosureSessionManagerDelegate.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete

class ClosureSessionManagerDelegate: CIOSessionManagerDelegate {

    let sessionChangeHandler: (_ from: Int, _ to: Int) -> Void

    init(sessionChangeHandler: @escaping (_ from: Int, _ to: Int) -> Void) {
        self.sessionChangeHandler = sessionChangeHandler
    }

    func sessionDidChange(from: Int, to: Int) {
        self.sessionChangeHandler(from, to)
    }
}
