//
//  AbstractQuizQuestionResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractQuizQuestionResponseParser {

    func parse(quizQuestionResponseData: Data) throws -> CIOQuizQuestionResponse
}
