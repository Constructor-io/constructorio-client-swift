//
//  CIODebugEventListener.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Receives tracking events while debug mode is enabled. Always called on the main queue, before the tracking call's completion handler.
 */
public protocol CIODebugEventListener: AnyObject {
    func didTrack(event: CIODebugEvent)
}
