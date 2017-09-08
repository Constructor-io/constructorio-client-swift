//
//  ClosureAutocompleteViewModelDelegate.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
@testable import ConstructorIO

class ClosureAutocompleteViewModelDelegate: AutocompleteViewModelDelegate {

    var onIgnoreResult: ((AutocompleteResult) -> Void)?
    var onSetResult: ((AutocompleteResult) -> Void)?

    init(viewModel: AutocompleteViewModel) {
        viewModel.delegate = self
    }

    func viewModel(_ viewModel: AutocompleteViewModel, didSetResult result: AutocompleteResult) {
        self.onSetResult?(result)
    }

    func viewModel(_ viewModel: AutocompleteViewModel, didIgnoreResult result: AutocompleteResult) {
        self.onIgnoreResult?(result)
    }

}
