//
//  UIView+FindSubview.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

extension UIView{
    
    func findSubview(_ filter: (UIView) -> Bool) -> UIView?{
        for v in self.subviews{
            if filter(v){
                return v
            }else if let view = v.findSubview(filter){
                return view
            }
        }
        return nil
    }
}
