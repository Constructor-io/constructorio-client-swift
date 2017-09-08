//
//  CIOAutocompleteDelegate.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

@objc
public protocol CIOAutocompleteDelegate: class {

    /**
     Called when CIOAutocompleteViewController's view is loaded (viewDidLoad).
     */
    @objc
    optional func autocompleteControllerDidLoad(controller: CIOAutocompleteViewController)

    /**
     Called when CIOAutocompleteViewController's view is about to appear (viewWillAppear).
     */
    @objc
    optional func autocompleteControllerWillAppear(controller: CIOAutocompleteViewController)
    
    /**
     Called when a search result has been selected.
     
     - parameter controller: A CIOAutocompleteViewController in which the selection occurred.
     - parameter result: Selected CIOResult object.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOResult)

    /**
     Called when a search is performed.
     
     - parameter controller: A CIOAutocompleteViewController in which the search occurred.
     - parameter searchTerm: A term used in the search.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, didPerformSearch searchTerm: String)

    
    /**
     Called if an error occurs.
     
     - parameter controller: A CIOAutocompleteViewController in which the selection occurred.
     - parameter error: Error that occured.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, errorDidOccur error: Error)
}
