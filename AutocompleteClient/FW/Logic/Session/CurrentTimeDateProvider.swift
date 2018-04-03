//
//  CurrentTimeDateProvider.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 3/12/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation

struct CurrentTimeDateProvider: DateProvider{
 
    func provideDate() -> Date{
        return Date()
    }
}
