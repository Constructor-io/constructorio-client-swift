//
//  String+Price.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension String{
    func price() -> Float{
        if self.hasPrefix("$"){
            return Float(self.substring(from: self.index(after: self.startIndex))) ?? 0
        }else if self.hasSuffix("$"){
            return Float(self.substring(to: self.index(before: self.endIndex))) ?? 0
        }else{
            return Float(self) ?? 0
        }
    }
}
