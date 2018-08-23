//
//  CIOMatcher.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import Mockingjay
@testable import ConstructorAutocomplete

class CIOMatcher{
    
    private var URL: String?
    private var parameters: [CIOMatcherParameter]
    private var pathComponents: [String]
    private var method: HTTPMethod?
    
    init(){
        self.URL = nil
        self.parameters = []
        self.pathComponents = []
    }
    
    func httpMethod(_ method: HTTPMethod) -> CIOMatcher{
        self.method = method
        return self
    }
    
    func URL(_ url: String) -> CIOMatcher{
        self.URL = url
        return self
    }
    
    func pathComponent(_ component: String) -> CIOMatcher{
        self.pathComponents.append(component)
        return self
    }
    
    func parameter(key: String, value: String) -> CIOMatcher{
        self.parameters.append(CIOMatcherParameter(key: key, value: value))
        return self
    }
    
    func create() -> (_ request: URLRequest) -> Bool{
        return { (_ request: URLRequest) -> Bool in
            
            let absoluteURLString = request.url!.absoluteString
            
            // check if url has correct prefix
            if let url = self.URL, !absoluteURLString.hasPrefix(url){
                return false
            }
            
            // check if methods match
            if let method = self.method, request.httpMethod != method.description{
                return false
            }
            
            // check if all parameters are present
            for parameter in self.parameters{
                if !absoluteURLString.contains("\(parameter.key)=\(parameter.value)"){
                    return false
                }
            }
            
            // check if all path components are present
            for component in self.pathComponents{
                if !request.url!.absoluteURL.pathComponents.contains(component){
                    return false
                }
            }
            
            return true
        }
    }
}

extension CIOMatcher{
    func attachAutocompleteKeyParameter() -> CIOMatcher{
        return self.parameter(key: Constants.Query.autocompleteKey, value: TestConstants.testAutocompleteKey)
    }
}
