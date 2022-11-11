//
//  AbstractQuizNextQuestionResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractQuizNextQuestionResponseParser {

    func parse(quizNextQuestionResponseData: Data) throws -> CIOQuizNextQuestionResponse
}
