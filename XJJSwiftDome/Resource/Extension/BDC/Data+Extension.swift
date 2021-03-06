//
//  Data+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/2.
//

import Foundation
import UIKit

extension Dictionary {
    
    /// 将字典转为 JSON  data
    ///
    /// - Returns: JSON data
    func toJSONData() -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {return nil}
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
        }catch {
            return nil
        }
    }
}

extension Array {
    
    /// 将数组转为 JSON data
    ///
    /// - Returns: JSON data
    func toJSONData() -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {return nil}
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
        }catch {
            return nil
        }
    }
}


extension String {
    func toJSONData() -> Data? {
        return self.data(using: .utf8)
    }
}

extension Data {
    
    func JSONToStr() -> String {
        return String(data: self, encoding: .utf8) ?? ""
    }
    
    /// JSON 解析
    ///
    /// - Returns: JSON 解析后的对象
    func JSONToAny() -> Any {
        do {
            let result = try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
            return result
        } catch  {
            return self
        }
    }
    
    static func JSONData(filePath: String) -> Data? {
        let url = URL(fileURLWithPath: filePath)
        
        do {
            let jsonData = try Data(contentsOf: url)
            return jsonData
        }catch {
            return nil
        }
    }
    
}

extension Data {
    func compressImage(maxKB: CGFloat? = 1024.0) -> UIImage? {
        let size = CGFloat(self.count) / 1024.0 / maxKB!
        var rate: CGFloat = 1.0 - 0.1 * size
        if rate < 0.1 { rate = 0.1 }
        
        return UIImage(data: self, scale: rate)
    }
}

/*
 Codable（json 编码、解码） 协议数据转换扩展
 需要转换的 Model 需要遵循 Codable 协议，并且 键值对 需要与具体数据一一对应（key 需要一模一样，value 需要类型一致），有一定局限性，但是很方便，不用写转换方法
 Codable 包含 Encodable（json 编码协议）和 Decodable（json 解码协议）
 */
extension Data {
    static func arrToDict<T: Encodable>(_ arr: [T], _ key: String? = "1") -> [String: Any]? {
        let encode = JSONEncoder()
        encode.outputFormatting = .prettyPrinted
        
        var dict: [String: Any] = [:]
        var arrM: [[String: Any]?] = []
        
        for model in arr {
            autoreleasepool {
                if let data = try? encode.encode(model) {
                    if let dic = ((try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]) as [String : Any]??) {
                        arrM.append(dic)
                    }
                }
            }
        }
        dict.updateValue(arrM, forKey: key!)
        print("- arrToDict -", dict)
        
        return dict
    }
    
    static func modelToDict<T: Encodable>(_ model: T) -> [String: Any]? {
        let encode = JSONEncoder()
        encode.outputFormatting = .prettyPrinted
        guard let data = try? encode.encode(model) else {return nil}
        guard let dic = ((try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]) as [String : Any]??) else {return nil}
        
        return dic
    }
    
    static func modelToStr<T: Encodable>(_ model: T) -> String? {
        let encode = JSONEncoder()
        encode.outputFormatting = .prettyPrinted
        guard let data = try? encode.encode(model) else {return nil}
        guard let dic = ((try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? String) as String??) else {return nil}
        
        return dic
    }
    
    static func dictToArr<T: Decodable>(_ dic: [String: Any], _ key: String? = "1") -> [T]? {
        guard let arr = dic[key!] as? [Any] else {return nil}
        
        var result: [T] = []
        for dict in arr {
            autoreleasepool {
                if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                    if let value = try? JSONDecoder().decode(T.self, from: data) {
                        result.append(value)
                    }
                }
            }
        }
        
        print("- dictToArr -", arr, result)
        
        return result
    }
    
    static func dictToModel<T: Decodable>(_ dic: [String: Any]) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) else {return nil}
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {return nil}
        
        return result
    }
    
    static func strToModel<T: Decodable>(_ str: String) -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: str, options: .prettyPrinted) else {return nil}
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {return nil}
        
        return result
    }
    
    func dataToModel<T: Decodable>() -> T? {
        guard let result = try? JSONDecoder().decode(T.self, from: self) else {return nil}
        
        return result
    }
}
