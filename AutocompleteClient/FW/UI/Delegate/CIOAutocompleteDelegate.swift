//
//  CIOAutocompleteDelegate.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

@objc
public protocol CIOAutocompleteDelegate: class{

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
     Called during parsing to ask whether to parse results in a certain section. If the user returns false,
     the whole section will be ignored.
     
     - parameter controller: A CIOAutocompleteViewController in which the search occurred.
     - parameter sectionName: Section name
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, shouldParseResultsInSection sectionName: String) -> Bool
   
    /**
     Called during parsing to ask whether to parse a certain result. If the user returns false for an item
     with nil group (the original item), the search-in-group items won't get parsed.
     
     - parameter controller: A CIOAutocompleteViewController in which the search occurred.
     - parameter result: An autocomplete result received from the server.
     - parameter group: A group in which the search should be performed.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, shouldParseResult result: CIOAutocompleteResult, inGroup group: CIOGroup?) -> Bool
    
    /**
      Maximum number of items in group to be displayed for an item at index. Does not get called for the base item(with nil group). By default, 2 items are shown for the first item(itemIndex=0) and 0 for every other.
     
     - parameter controller: A CIOAutocompleteViewController in which the results are shown.
     - parameter item: Item to be displayed.
     - parameter itemIndex: Index of an item being displayed.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, maximumNumberOfGroupsForItem item: CIOAutocompleteResult, itemIndex: Int) -> Int
    
    /**
     Called if an error occurs.
     
     - parameter controller: A CIOAutocompleteViewController in which the selection occurred.
     - parameter error: Error that occured.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, errorDidOccur error: Error)
}
