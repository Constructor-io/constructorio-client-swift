//
//  ClosureAutocompleteViewModelDelegate.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
@testable import ConstructorAutocomplete

class ClosureAutocompleteViewModelDelegate: AutocompleteViewModelDelegate {

    var onIgnoreResult: ((AutocompleteResult) -> Void)?
    var onSetResult: ((AutocompleteResult) -> Void)?

    init(viewModel: AutocompleteViewModel) {
        viewModel.delegate = self
    }

    func viewModel(_ viewModel: AbstractAutocompleteViewModel, didSetResult result: AutocompleteResult) {
        self.onSetResult?(result)
    }

    func viewModel(_ viewModel: AbstractAutocompleteViewModel, didIgnoreResult result: AutocompleteResult) {
        self.onIgnoreResult?(result)
    }

}
