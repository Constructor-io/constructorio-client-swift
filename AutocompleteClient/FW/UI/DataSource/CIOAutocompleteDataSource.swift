//
//  CIOAutocompleteDataSource.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

@objc
public protocol CIOAutocompleteDataSource: class {

    /**
     Returns a custom cell nib to be used in the CIOAutocompleteViewController.
     
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     */
    @objc
    optional func customCellNib(in autocompleteController: CIOAutocompleteViewController) -> UINib

    /**
     Returns a custom cell class to be used in the CIOAutocompleteViewController.
     
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     */
    @objc
    optional func customCellClass(in autocompleteController: CIOAutocompleteViewController) -> AnyClass

    /**
     Customizes the search controller.
     
     - parameter searchController: UISearchController controlling the search bar shown in the CIOAutocompleteViewController
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     */
    @objc
    optional func customizeSearchController(searchController: UISearchController, in autocompleteController: CIOAutocompleteViewController)
    
    /**
     Styles the cell label used in the default UI. This method will not be called if you're using a custom cell nib or class.
     
     - parameter label: The UILabel to be customized
     - parameter indexPath: IndexPath of the customized cell
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     */
    @objc
    optional func styleResultLabel(label: UILabel, indexPath: IndexPath, in autocompleteController: CIOAutocompleteViewController)

    /**
     Styles the cell used in the default UI. This method will not be called if you're using a custom cell nib or class.
     
     - parameter cell: The UITableViewCell to be customized
     - parameter indexPath: IndexPath of the customized cell
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     */
    @objc
    optional func styleResultCell(cell: UITableViewCell, indexPath: IndexPath, in autocompleteController: CIOAutocompleteViewController)

    /**
     Provides the default font.

     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: The default CIOAutocompleteViewController font
     */
    @objc
    optional func fontNormal(in autocompleteController: CIOAutocompleteViewController) -> UIFont

    /**
     Provides the default bold font used to highlight the search results.
     
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: The default CIOAutocompleteViewController bold font
     */
    @objc
    optional func fontBold(in autocompleteController: CIOAutocompleteViewController) -> UIFont

    /**
     Provides the search results' row height.
     
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: The CIOAutocompleteViewController row height.
     */
    @objc
    optional func rowHeight(in autocompleteController: CIOAutocompleteViewController) -> CGFloat

    /**
     Determines whether the section header is shown. True by default.
     
     - parameter sectionName: Section name
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: Whether the section header should be displayed.
     */
    @objc
    optional func shouldShowSectionHeader(sectionName: String, in autocompleteController: CIOAutocompleteViewController) -> Bool
    
    /**
     Provides a section header view.
     
     - parameter sectionName: Section name
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: Section header view.
     */
    @objc
    optional func sectionHeaderView(sectionName: String, in autocompleteController: CIOAutocompleteViewController) -> UIView?
    
    /**
     Provides a section header view height. 44 by default
     
     - parameter sectionName: Section name
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: Section header height.
     */
    @objc
    optional func sectionHeaderViewHeight(sectionName: String, in autocompleteController: CIOAutocompleteViewController) -> CGFloat
    
    /**
     Provides a search suggestion section display name. By default, this value is "Search Suggestions".
     
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: Section name to be displayed in the section view
     */
    @objc
    optional func searchSuggestionsSectionName(in autocompleteController: CIOAutocompleteViewController) -> String
    
    /**
     Provides the search bar placeholder.
     
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: The UISearchBar placeholder value.
     */
    @objc
    optional func searchBarPlaceholder(in autocompleteController: CIOAutocompleteViewController) -> String

    /**
     Provides the view to be shown behind the UITableView. Not implementing this method will show the default background view.
     
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: The background view to be shown behind the UITableView.
     */
    @objc
    optional func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView?

    /**
     Provides a sort sections function.
     
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: Sort section function. The two parameters of type strings represent section names.
     */
    @objc
    optional func sectionSort(in autocompleteController: CIOAutocompleteViewController) -> ((String, String) -> Bool)
    
    /**
     Provides the view to be shown when an error occurs. Not implementing this method will show the default error view. The view should conform to the CIOErrorView protocol.
     
     - parameter autocompleteController: The sender CIOAutocompleteViewController
     
     - returns: The error view to be shown if an error occurs.
     */
    @objc
    optional func errorView(in autocompleteController: CIOAutocompleteViewController) -> UIView?

}
