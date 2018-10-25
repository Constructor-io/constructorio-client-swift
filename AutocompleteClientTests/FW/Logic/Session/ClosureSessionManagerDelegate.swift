//
//  ClosureSessionManagerDelegate.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete

class ClosureSessionManagerDelegate: CIOSessionManagerDelegate{
    
    let sessionChangeHandler: (_ from: Int, _ to: Int) -> Void
    
    init(sessionChangeHandler: @escaping (_ from: Int, _ to: Int) -> Void){
        self.sessionChangeHandler = sessionChangeHandler
    }
    
    func sessionDidChange(from: Int, to: Int){
        self.sessionChangeHandler(from, to)
    }
}
