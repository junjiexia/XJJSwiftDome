//
//  XJJHTTPResult.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/2.
//

import Foundation

class XJJHTTPResult<T: Codable>: Codable {
    var data: T?
}

// 任何类型的数据：字符串、整型、浮点型、百分比
class XJJAny: Codable {
    var int: Int?
    var double: Double?
    var string: String?
    var percentText: String?

    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self)
        {
            string = stringValue
            int = Int(stringValue)
            double = Double(stringValue)
            percentText = self.percentage()
        } else if let intValue = try? container.decode(Int.self)
        {
            int = intValue
            double = Double(intValue)
            string = String(intValue)
            percentText = self.percentage()
        } else if let doubleValue = try? container.decode(Double.self)
        {
            double = doubleValue
            int =  Int(doubleValue)
            string = String(doubleValue)
            percentText = self.percentage()
        } else
        {
            
        }
    }
    
    class func compare(double value: Double, min: XJJAny?, max: XJJAny?) -> Bool {
        if let n = min?.double {
            if value < n {
                return false
            }
        }
        
        if let x = max?.double {
            if value > x {
                return false
            }
        }
        
        return true
    }
    
    private func percentage() -> String? {
        if let pw = double {
            return String(format: "%.f%%", pw)
        }
        
        return nil
    }
}
