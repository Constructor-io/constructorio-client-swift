//
//  CIOAutocompleteDelegate.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

@objc
public protocol CIOAutocompleteDelegate: AnyObject {

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
     - parameter result: Selected CIOAutocompleteResult object.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOAutocompleteResult)

    /**
     Called when a cell for search result has been shown.

     - parameter controller: A CIOAutocompleteViewController in which the selection occurred.
     - parameter result: Selected CIOAutocompleteResult object.
     - parameter indexPath: UITableViewCell IndexPath.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, willDisplayResult result: CIOAutocompleteResult, at indexPath: IndexPath)

    /**
     Called when a search is performed.

     - parameter controller: A CIOAutocompleteViewController in which the search occurred.
     - parameter searchTerm: A term used in the search.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, didPerformSearch searchTerm: String)

    /**
     Called during parsing to ask whether to parse a certain result. If the user returns false for an item
     with nil group (the original item), the search-in-group items won't get parsed.

     - parameter controller: A CIOAutocompleteViewController in which the search occurred.
     - parameter result: An autocomplete result received from the server.
     - parameter group: A group in which the search should be performed.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, shouldParseResult result: CIOResult, inGroup group: CIOGroup?) -> Bool

    /**
      Maximum number of items in group to be displayed for an item at index. Does not get called for the base item(with nil group). By default, 2 items are shown for the first item(itemIndex=0) and 0 for every other.

     - parameter controller: A CIOAutocompleteViewController in which the results are shown.
     - parameter item: Item to be displayed.
     - parameter itemIndex: Index of an item being displayed.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, maximumGroupsShownPerResult result: CIOResult, itemIndex: Int) -> Int

    /**
     Called when a results have been loaded.

     - parameter controller: A CIOAutocompleteViewController in which the selection occurred.
     - parameter results: Loaded results.
     - parameter searchTerm: Requested search term.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, didLoadResults results: [CIOAutocompleteResult], for searchTerm: String)

    /**
     Called if an error occurs.

     - parameter controller: A CIOAutocompleteViewController in which the selection occurred.
     - parameter error: Error that occured.
     */
    @objc
    optional func autocompleteController(controller: CIOAutocompleteViewController, errorDidOccur error: Error)
}
