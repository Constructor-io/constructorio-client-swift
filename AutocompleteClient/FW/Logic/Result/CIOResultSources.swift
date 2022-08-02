//
//  CIOResultSources.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//
import Foundation

/**
 Struct encapsulating a result source
 */
public class CIOResultSources: NSObject {
    /**
     Number of token match results
     */
    public let tokenMatch: CIOResultSourceData
    
    /**
     Number of embedding match results
     */
    public let embeddingsMatch: CIOResultSourceData
    
    /**
     Create a result sources object
     
     - Parameters:
        - json: JSON data from server reponse
     */
    init?(json: JSONObject?) {
        guard let json = json,
        let tokenMatchJson = json["token_match"] as? JSONObject,
        let embeddingsMatchJson = json["embeddings_match"] as? JSONObject,
        let tokenMatchData: CIOResultSourceData = CIOResultSourceData(json: tokenMatchJson),
        let embeddingsMatchData: CIOResultSourceData = CIOResultSourceData(json: embeddingsMatchJson) else {
            return nil
        }
        
        self.tokenMatch = tokenMatchData
        self.embeddingsMatch = embeddingsMatchData
    }
}
