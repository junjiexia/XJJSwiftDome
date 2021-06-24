//
//  String+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/1/28.
//

import Foundation
import UIKit

extension String {
    /// 替换
    mutating func replace(_ str: String, _ toStr: String) {
        var string = self
        
        if let range = string.range(of: str) {
            string.replaceSubrange(range, with: toStr)
        }
        
        self = string
    }
    
    /// 子字符串
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
    
    // 取子字符串数组，每项字符串长度都为：subCount
    func substrings(_ subCount: Int) -> [String] {
        var result = [String]()
        
        if self.count > 0 {
            // 分组
            var count = self.count / subCount
            let remainder = self.count % subCount
            if remainder > 0 {
                count += 1
            }
            for i in 0..<count {
                let index = self.index(String.Index(utf16Offset: i * subCount, in: self), offsetBy: subCount)
                let subStr = String(self.prefix(upTo: index))
                result.append(subStr)
            }
        }
        
        return result
    }
    
    // 删除末尾字符
    mutating func deleteLastPunctuation(_ char: Character) {
        let str = self
        if str.last == char {
            self = String(str.prefix(upTo: str.index(str.endIndex, offsetBy: -1)))
            self.deleteLastPunctuation(char)
        }
    }
    
    // 删除字符串
    func removeText(_ text: String) -> String {
        if self.contains(text) {
            return self.replacingOccurrences(of: text, with: "")
        }
        return self
    }
    
    // 删除末尾字符串
    func removeLastText(_ text: String) -> String {
        let chr = Character(text)
        if self.last == chr {
            return String(self.prefix(upTo: self.index(self.endIndex, offsetBy: -1)))
        }else {
            return self
        }
    }
    
    // 返回括号内的内容
    func subInBrackets() -> String {
        let arr = self.components(separatedBy: "(")
        if arr.count > 1 {
            return arr[1].components(separatedBy: ")").first ?? ""
        }
        
        return ""
    }
    
    public static func isEmpty(_ string: String?) -> Bool {
        return string == nil || string == ""
    }
}

//MARK: - 数字字符串处理
extension String {
    static func INT(_ int_str: String?) -> Int {
        if let str = int_str, let i = Int(str) {
            return i
        }
        return 0
    }
    
    // String(format: %.f%%) 自动四舍五入
    static func percentage(_ num: Double?, decimalCount: Int? = 0) -> String {
        if let n = num, n > 0 {
            return String(format: "%.\(decimalCount!)f%%", n * 100)
        }
        return "0%"
    }
}

//MARK: - Mac 地址处理
extension String {
    func macType() -> String { // 带 ：的大写 Mac 地址
        if !self.contains(":") {
            var arr: [String] = []
            
            let j = 2
            let count = self.count / 2 + (self.count % 2 == 0 ? 0 : 1)
            for i in 0..<count {
                if i * j + j > self.count {
                    let str = self.sub(i * j, 1)
                    arr.append(str)
                }else {
                    let str = self.sub(i * j, j)
                    arr.append(str)
                }
            }
            
            return arr.joined(separator: ":").uppercased()
        }
        return self.uppercased()
    }
    
    func tabType() -> String { // 不带 ：的十六进制地址
        return removeText(":").lowercased()
    }
}

//MARK: - 汉字及编码
extension String {
    
    var unicodeStr: String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
    func utf8Str() -> String {
        guard includeChinese() else {return self}
        return self.utf8HTMLStr()
    }
    
    func unicode() -> String {
        guard includeChinese() else {return self}
        
        
        return ""
    }
    
    func includeChinese() -> Bool {
        for (_, value) in self.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        
        return false
    }
    
    func toUTF8() -> String {
        var arr = [UInt8]()
        arr += self.utf8
        return String(bytes: arr, encoding: .utf8) ?? self
    }
    
    func GBK() -> String {
        let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
        let str = String(data: data(using: .utf8)!, encoding: String.Encoding(rawValue: enc))
        return str ?? self
    }
    
    func utf8UrlStr() -> String {
        var set = CharacterSet()
        set.formUnion(CharacterSet.urlQueryAllowed)
        set.remove(charactersIn: "[].:/?&=;+!@#$()',*\"")
        return self.addingPercentEncoding(withAllowedCharacters: set) ?? self
    }
    
    func utf8HTMLStr() -> String {
        var result = ""
        
        for item  in self.utf16 {
            let str = String(format: "%04x", item)
            result.append("&#x" + str + ";")
        }
        
        return result
    }
}

//MARK: - 拼音 -- 一般用于人员列表排序
extension String {
    // 判断字符串中是否有中文
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            if (0x4e00 < ch.value  && ch.value < 0x9fff) { return true } // 中文字符范围：0x4e00 ~ 0x9fff
        }
        return false
    }
    
    // 获取大写首字母
    func firstChar() -> String {
        guard self.count > 0 else {return ""}
        
        var firstString: String = ""
        
        //判断首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate(format: "SELF MATCHES %@", regexA)
        
        if isIncludeChinese() {
            let strPinYin = pinyinString()
            //截取大写首字母
            firstString = String(strPinYin.first!).uppercased()
        }else {
            firstString =  String(self.first!).uppercased()
        }
        
        return predA.evaluate(with: firstString) ? firstString : "#"
    }
    
    func pinyinString() -> String {
        //转变成可变字符串
        let mutableString = NSMutableString(string: self)
        
        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        
        //去掉声调
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: .current)
        
        //多音字
        let strPinYin = polyphoneStringHandle(nameString: self, pinyinString: pinyinString)
        
        return strPinYin
    }
    
    // 多音字处理，根据需要添自行加
    func polyphoneStringHandle(nameString: String, pinyinString: String) -> String {
        if nameString.hasPrefix("沈") {return "shen"}
        return pinyinString
    }
}

//MARK: - 进制转换
enum NumberType: Int {
    case Octal = 8
    case Hex = 16
    case Decimal = 10
}

extension String {
    
    // 整形的 utf8 编码范围
    static let intRange = 48...57
    // 小写 a~f 的 utf8 的编码范围
    static let lowercaseRange = 97...102
    // 大写 A~F 的 utf8 的编码范围
    static let uppercasedRange = 65...70
    
    // byte数组转字符串（Mac）
    // bytes: byte数组
    // capChar: 插入的字符
    // range: 截取范围（元组）
    // type: 进制
    static func bytesToString(_ bytes: [UInt8],
                              _ capChar: String,
                              _ range: (Int, Int),
                              _ type: NumberType) -> String
    {
        var result = ""
        let count = range.0 + range.1
        
        if bytes.count > count {
            for i in range.0..<count {
                var str = ""
                switch type {
                case .Octal:
                    str = String(format: "%o", bytes[i])
                case .Hex:
                    str = String(format: "%02X", bytes[i])
                case .Decimal:
                    str = String(format: "%d", bytes[i])
                }
                
                result += str
                if i < (count - 1) {
                    result += capChar
                }
            }
        }
        
        return result
    }
    
    // byte数组转日期字符串
    // bytes: byte数组
    // range: 截取范围（元组）
    static func bytesTpDateString(_ bytes: [UInt8],
                                  _ range: (Int, Int)) -> String {
        var result = ""
        let count = range.0 + range.1
        
        if bytes.count > count {
            for i in range.0..<count {
                result += String(format: "%02d", bytes[i])
            }
        }
        
        return result
    }
    
    // 字符串转data
    // type: 传入的字符串的进制类型
    func stringToData(_ type: NumberType) -> Data {
        var bytes: [UInt8] = []
        
        switch type {
        case .Decimal:
            bytes = self.decStringToBytes()
        case .Hex:
            bytes = self.hexStringToBytes()
        case .Octal:
            break
        }
        
        return Data(bytes)
    }
    
    // 十进制字符串转byte数组
    func decStringToBytes() -> [UInt8] {
        var bytes: [UInt8] = []
        
        if self.count > 0, self.count % 2 == 0 {
            var sum = 0
            // 整形的 utf8 编码范围
            let intRange = 48...57
            for (index, c) in self.utf8CString.enumerated() {
                var intC = Int(c.byteSwapped)
                if intC == 0 {
                    break
                } else if intRange.contains(intC) {
                    intC -= 48
                } else {
                    print("字符串格式不对，每个字符都需要在0~9内")
                    break
                }
                sum = sum * 10 + intC

                if index % 2 != 0 {
                    bytes.append(UInt8(sum))
                    sum = 0
                }
            }
        }
        
        return bytes
    }
    
    // 十六进制字符串转byte数组
    func hexStringToBytes() -> [UInt8] {
        var bytes: [UInt8] = []
        
        if self.count > 0, self.count % 2 == 0 {
            var sum = 0

            for (index, c) in self.utf8CString.enumerated() {
                var intC = Int(c.byteSwapped)
                if intC == 0 {
                    break
                } else if String.intRange.contains(intC) {
                    intC -= 48
                } else if String.lowercaseRange.contains(intC) {
                    intC -= 87
                } else if String.uppercasedRange.contains(intC) {
                    intC -= 55
                } else {
                    print("字符串格式不对，每个字符都需要在0~9，a~f，A~F内")
                    break
                }
                sum = sum * 16 + intC
                // 每两个十六进制字母代表8位，即一个字节
                if index % 2 != 0 {
                    bytes.append(UInt8(sum))
                    sum = 0
                }
            }
        }
        
        return bytes
    }
    
    // 单个十六进制转十进制
    func hexToDec() -> Int {
        var result = -1
        
        if self.count > 0 {
            for c in self.utf8 {
                var i = Int(c.byteSwapped)
                if i  == 0 {
                    result = 0
                }else if String.intRange.contains(i) {
                    i -= 48
                }else if String.lowercaseRange.contains(i) {
                    i -= 87
                }else if String.uppercasedRange.contains(i) {
                    i -= 55
                }else {
                    break
                }
                
                result = result * 16 + i
            }
        }
        
        return result
    }
}

//MARK: - 获取文字长宽
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
