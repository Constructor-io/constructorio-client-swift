//
//  QuizResultsResponseParser.swift
//  ConstructorAutocomplete
//
//  Created by Islam Mouatafa on 11/11/22.
//  Copyright © 2022 xd. All rights reserved.
//

import Foundation

class QuizResultsResponseParser: AbstractQuizResultsResponseParser {
    func parse(quizResultsResponseData: Data) throws -> CIOQuizResultsResponse {

        do {
            let json = try JSONSerialization.jsonObject(with: quizResultsResponseData) as? JSONObject

            guard let response = json?["response"] as? JSONObject else {
                throw CIOError(errorType: .invalidResponse)
            }

            let facetsObj: [JSONObject]? = response["facets"] as? [JSONObject]
            let resultsObj: [JSONObject]? = response["results"] as? [JSONObject]
            let sortOptionsObj: [JSONObject]? = response["sort_options"] as? [JSONObject]
            let groupsObj = response["groups"] as? [JSONObject]

            let facets: [CIOFilterFacet] = (facetsObj)?.compactMap { obj in return CIOFilterFacet(json: obj) } ?? []
            let results: [CIOResult] = (resultsObj)?.compactMap { obj in return CIOResult(json: obj) } ?? []
            let sortOptions: [CIOSortOption] = (sortOptionsObj)?.compactMap({ obj  in return CIOSortOption(json: obj) }) ?? []
            let groups: [CIOFilterGroup] = groupsObj?.compactMap({ obj  in return CIOFilterGroup(json: obj) }) ?? []
            let totalNumResults = response["total_num_results"] as? Int ?? 0
            let resultSources: CIOResultSources? = CIOResultSources(json: response["result_sources"] as? JSONObject)

            let resultID = json?["result_id"] as? String ?? ""
            let quizVersionId = json?["quiz_version_id"] as? String ?? ""
            let quizId = json?["quiz_id"] as? String ?? ""
            let quizSessionId = json?["quiz_session_id"] as? String ?? ""

            return CIOQuizResultsResponse(
                facets: facets,
                groups: groups,
                results: results,
                sortOptions: sortOptions,
                totalNumResults: totalNumResults,
                resultSources: resultSources,
                resultID: resultID,
                quizVersionId: quizVersionId,
                quizSessionId: quizSessionId,
                quizId: quizId
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
