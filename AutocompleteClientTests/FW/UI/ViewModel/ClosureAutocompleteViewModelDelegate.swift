//
//  ClosureAutocompleteViewModelDelegate.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

public class ClosureAutocompleteViewModelDelegate: AutocompleteViewModelDelegate {

    public var onIgnoreResult: ((AutocompleteResult) -> Void)?
    public var onSetResult: ((AutocompleteResult) -> Void)?

    public init(viewModel: AutocompleteViewModel) {
        viewModel.delegate = self
    }

    func viewModel(_ viewModel: AbstractAutocompleteViewModel, didSetResult result: AutocompleteResult) {
        self.onSetResult?(result)
    }

    func viewModel(_ viewModel: AbstractAutocompleteViewModel, didIgnoreResult result: AutocompleteResult) {
        self.onIgnoreResult?(result)
    }

}
