//
//  ClosureAutocompleteViewModelDelegate.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import UIKit

public class ClosureAutocompleteViewModelDelegate: AutocompleteViewModelDelegate {

    public var onIgnoreResult: ((AutocompleteResult) -> Void)?
    public var onSetResult: ((AutocompleteResult) -> Void)?

    public init(viewModel: AutocompleteViewModel) {
        viewModel.delegate = self
    }

    public func viewModel(_ viewModel: AbstractAutocompleteViewModel, didSetResult result: AutocompleteResult) {
        self.onSetResult?(result)
    }

    public func viewModel(_ viewModel: AbstractAutocompleteViewModel, didIgnoreResult result: AutocompleteResult) {
        self.onIgnoreResult?(result)
    }

}
