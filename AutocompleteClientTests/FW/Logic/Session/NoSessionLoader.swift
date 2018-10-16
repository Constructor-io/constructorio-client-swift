//
//  NoSessionLoader.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 10/16/18.
//  Copyright © 2018 xd. All rights reserved.
//

@testable import ConstructorAutocomplete

class NoSessionLoader: SessionLoader{
    func loadSession() -> Session? {
        return nil
    }
    func saveSession(_ session: Session) {}
    
    func clearSession() {}
}
