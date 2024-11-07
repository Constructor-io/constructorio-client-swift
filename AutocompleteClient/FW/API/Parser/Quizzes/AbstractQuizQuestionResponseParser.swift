//
//  AbstractQuizQuestionResponseParser.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractQuizQuestionResponseParser {

    func parse(quizQuestionResponseData: Data) throws -> CIOQuizQuestionResponse
}
