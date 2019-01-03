//
//  AutocompleteViewModelDelegate.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol AutocompleteViewModelDelegate: class {
    func viewModel(_ viewModel: AutocompleteViewModel, didIgnoreResult result: AutocompleteResult)
    func viewModel(_ viewModel: AutocompleteViewModel, didSetResult result: AutocompleteResult)
}
