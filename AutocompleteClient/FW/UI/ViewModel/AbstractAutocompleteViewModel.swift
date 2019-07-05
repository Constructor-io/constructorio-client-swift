//
//  AbstractAutocompleteViewModel.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol AbstractAutocompleteViewModel {

    var results: [AutocompleteViewModelSection] { get set }
    var delegate: AutocompleteViewModelDelegate? { get set }
    var screenTitle: String { get set }
    var modelSorter: (String, String) -> Bool { get set }
    var searchTerm: String { get }

    func set(searchResult: AutocompleteResult, completionHandler: @escaping () -> Void)

    func getResult(atIndexPath indexPath: IndexPath) -> CIOResult
    func getSectionName(atIndex index: Int) -> String

}
