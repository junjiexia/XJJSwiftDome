//
//  Array+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/21.
//

import Foundation
import UIKit

extension Array {
    /*
     边缘求和
     返回对应下标前一个的求和，以及当前下标的求和
     */
    func edgeValue(and index: Int) -> (CGFloat, CGFloat) where Element == CGFloat {
        var min: CGFloat = 0
        var max: CGFloat = 0
        
        if self.count > 0 {
            for i in 0..<count {
                max += self[i]
                
                if i == index {
                    break
                }
                
                min += self[i]
            }
        }
        
        return (min, max)
    }
}
