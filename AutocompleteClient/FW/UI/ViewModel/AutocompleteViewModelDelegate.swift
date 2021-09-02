//
//  AutocompleteViewModelDelegate.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol AutocompleteViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: AbstractAutocompleteViewModel, didIgnoreResult result: AutocompleteResult)
    func viewModel(_ viewModel: AbstractAutocompleteViewModel, didSetResult result: AutocompleteResult)
}
