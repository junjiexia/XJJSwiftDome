//
//  XJJCheck.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/1/28.
//

import Foundation
import UIKit

class XJJCheck {
    /*
     perfectMatch: 是否完全匹配
     */
    class func checkFont(_ fontName: String, perfectMatch: Bool? = true) {
        var isCheck = false
        
        for fontFamily in UIFont.familyNames {
            for font in UIFont.fontNames(forFamilyName: fontFamily) {
                print("字体类型: " + fontFamily + " -- " + font)
                if perfectMatch == true {
                    if font == fontName {
                        isCheck = true
                        print("找到字体 " + fontName)
                    }
                }else {
                    if font.contains(fontName) {
                        isCheck = true
                        print("找到字体包含字段 " + fontName)
                    }
                }
            }
        }
        
        if !isCheck { print("没有找到字体 " + fontName) }
    }
    
}
