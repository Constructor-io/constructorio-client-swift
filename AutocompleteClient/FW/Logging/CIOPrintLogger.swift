//
//  CIOPrintLogger.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class CIOPrintLogger: CIOLogger {
    func log(_ message: String) {
        #if DEBUG
            print(message)
        #endif
    }
}
