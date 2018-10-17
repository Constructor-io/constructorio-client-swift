//
//  NoSessionLoader.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete

class NoSessionLoader: SessionLoader{
    func loadSession() -> Session? {
        return nil
    }
    func saveSession(_ session: Session) {}
    
    func clearSession() {}
}
