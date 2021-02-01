//
//  String+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/1/28.
//

import Foundation

extension String {
    func sub(_ start: Int, _ count: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex =  self.index(self.startIndex, offsetBy: start + count)
        return String(self[startIndex..<endIndex])
    }
    
    // 取字符数组
    func characters() -> [Character] {
        var result = [Character]()
        
        if self.count > 0 {
            for char in self {
                result.append(char)
            }
        }
        
        return result
    }
}
