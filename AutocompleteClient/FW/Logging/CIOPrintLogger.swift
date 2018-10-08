//
//  CIOPrintLogger.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class CIOPrintLogger: CIOLogger{
    public func log(_ message: String){
        #if DEBUG
            print(message)
        #endif
    }
}
