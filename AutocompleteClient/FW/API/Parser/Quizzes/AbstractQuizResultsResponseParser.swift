//
//  AbstractQuizResultsResponseParser.swift
//  ConstructorAutocomplete
//
//  Created by Islam Mouatafa on 11/11/22.
//  Copyright © 2022 xd. All rights reserved.
//

import Foundation

protocol AbstractQuizResultsResponseParser {

    func parse(quizResultsResponseData: Data) throws -> CIOQuizResultsResponse
}
