//
//  UIColor+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/22.
//

import Foundation
import UIKit

extension UIColor {
    // 随机颜色
    public class var randomColor: UIColor {
        get {
            return UIColor(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1)
        }
    }
    
    // 相对颜色
    public var invertColor: UIColor {
        get {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return UIColor(red: 1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
    }
    
    // 十六进制颜色字串
    public var hexText: String {
        get {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return String(format: "%02X%02X%02X-%.2f", Int(r * 0xff), Int(g * 0xff), Int(b * 0xff), a)
        }
    }
}


