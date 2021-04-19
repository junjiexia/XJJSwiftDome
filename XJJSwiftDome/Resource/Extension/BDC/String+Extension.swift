//
//  String+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/1/28.
//

import Foundation
import UIKit

extension String {
    public func sub(_ start: Int, _ count: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex =  self.index(self.startIndex, offsetBy: start + count)
        return String(self[startIndex..<endIndex])
    }
    
    // 取字符数组
    public func characters() -> [Character] {
        var result = [Character]()
        
        if self.count > 0 {
            for char in self {
                result.append(char)
            }
        }
        
        return result
    }
    
    public static func isEmpty(_ string: String?) -> Bool {
        return string == nil || string == ""
    }
}

extension String {
    public func getSize(_ font: UIFont) -> CGSize {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return rect.size
    }
    
    public func getHeight(_ font: UIFont, _ width: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    public func getHeight(_ font: UIFont, _ width: CGFloat, _ maxHeight: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height) > maxHeight ? maxHeight : ceil(rect.height)
    }
    
    public func getWidth(_ font: UIFont, _ height: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    public func getWidth(_ font: UIFont, _ height: CGFloat, _ maxWidth: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width) > maxWidth ? maxWidth : ceil(rect.width)
    }
}
