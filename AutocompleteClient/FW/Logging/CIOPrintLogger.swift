//
//  CIOPrintLogger.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class CIOPrintLogger: CIOLogger {
    public func log(_ message: String) {
        #if DEBUG
            print(message)
        #endif
    }
}
