//
//  CIODebugEventListener.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Protocol for receiving the tracking events of a `ConstructorIO` instance while debug mode is enabled

 Add a listener with `addDebugEventListener(_:)`. It is called on the main queue with every tracking event of that instance, once the request of the event has completed and before the completion handler of the tracking call. Events arrive in the order of their responses, which can differ from the order in which they were fired, so use the `sequence` of an event to tell which one was fired first.
 */
public protocol CIODebugEventListener: AnyObject {

    /**
     Called when a tracking event was sent and its request has completed

     - Parameters:
        - event: The tracking event, with its request and the outcome of that request
     */
    func didTrack(event: CIODebugEvent)
}
