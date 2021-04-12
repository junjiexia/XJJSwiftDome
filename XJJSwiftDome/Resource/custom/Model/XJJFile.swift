//
//  XJJFile.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/1.
//

/****************
 *** UserDefaults 存储
 *** Plist 存储
 *** 文件存储
 ****************/

import Foundation
import UIKit

class XJJFile {
    //MARK: - UserDefaults
    class func save(boolValue: Bool, forKey: String) {
        UserDefaults.standard.set(boolValue, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    class func save(stringValue: String, forKey: String) {
        UserDefaults.standard.set(stringValue, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    class func save(intValue: Int, forKey: String) {
        UserDefaults.standard.set(intValue, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    class func save(doubleValue: Double, forKey: String) {
        UserDefaults.standard.set(doubleValue, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    class func bool(forKey: String) -> Bool? {
        if let value = UserDefaults.standard.object(forKey: forKey) as? Bool {
            return value
        }
        return nil
    }
    
    class func string(forKey: String) -> String? {
        if let value = UserDefaults.standard.object(forKey: forKey) as? String {
            return value
        }
        return nil
    }
    
    class func int(forKey: String) -> Int? {
        if let value = UserDefaults.standard.object(forKey: forKey) as? Int {
            return value
        }
        return nil
    }
    
    class func double(forKey: String) -> Double? {
        if let value = UserDefaults.standard.object(forKey: forKey) as? Double {
            return value
        }
        return nil
    }
    
    //MARK: - Plist
    static var tempFilesPath: String = {
        return NSHomeDirectory() + "/Documents/TempFiles/"
    }()
    static var cachesPath: String = {
        return NSHomeDirectory() + "/Library/Caches/myCaches/"
    }()
    static var tmpPath: String = {
        return NSTemporaryDirectory()
    }()
    
    //MARK: - 删除数据
    class func removeFile(_ path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
                return true
            }catch {
                return false
            }
        }
        
        return true
    }
    
    class func removeAllFile(with folderPath: String) -> Bool {
        if removeFile(folderPath) {
            return createFolder(folderPath)
        }
        
        return false
    }
    
    class func removeTemp() -> Bool {
        return removeAllFile(with: tempFilesPath)
    }
    
    class func removeCaches() -> Bool {
        return removeAllFile(with: cachesPath)
    }
    
    //MARK: - 获取数据
    class func getData(filePath: String) -> Data? {
        if FileManager.default.fileExists(atPath: filePath) {
            return FileManager.default.contents(atPath: filePath)
        }
        
        return nil
    }
    
    class func getImage(temp fileName: String) -> UIImage? {
        let path = tempFilesPath + fileName
        return UIImage(contentsOfFile: path)
    }
    
    //MARK: - 保存数据
    // fileName: JPEG格式图片
    class func saveImage(temp image: UIImage, _ fileName: String) -> String? {
        let now = file_date("yyyyMMddHHmmss")
        let path = tempFilesPath + now + "-" + fileName
        
        if FileManager.default.fileExists(atPath: path) {
            _ = removeFile(path)
        }
        
        guard createFolder(tempFilesPath) else {return nil}
        
        return self.saveData(data: image.jpegData(compressionQuality: 1), toPath: path)
    }
    
    class func saveData(data: Data?, withFileName: String?) -> String? {
        let toPath: String = tempFilesPath + (withFileName ?? file_date("yyyyMMddHHmmss"))
        return self.saveData(data: data, toPath: toPath)
    }
    
    class func saveData(data: Data?, toPath: String) -> String? {
        if let _d = data {
            let isSuccess: Bool = FileManager.default.createFile(atPath: toPath, contents: _d, attributes: nil)
            if isSuccess {
                print(" 💫 ", "保存数据成功！ filePath: ", toPath)
                return toPath
            }else {
                print(" 💫 ", "保存数据失败！")
                return nil
            }
        }else {
            print(" 💫 ", "保存数据为空！")
            return nil
        }
    }
    
    class func saveFile(from filePath: String, _ fileName: String) -> String? {
        let now = file_date("yyyyMMddHHmmss")
        let path = tempFilesPath + now + "-" + fileName
        
        if FileManager.default.fileExists(atPath: path) {
            _ = removeFile(path)
        }
        
        guard createFolder(tempFilesPath) else {return nil}
        
        do {
            try FileManager.default.moveItem(atPath: filePath, toPath: path)
            print(" 💫 ", "保存文件成功！ filePath: ", path)
        }catch {
            print(" 💫 ", "保存文件失败！ error: ", error)
            return nil
        }
        
        return path
    }
    
    class func saveFileToTmp(from filePath: String, _ fileName: String) -> String? {
        let path = tmpPath + fileName
        
        if FileManager.default.fileExists(atPath: path) {
            _ = removeFile(path)
        }
        
        guard createFolder(tmpPath) else {return nil}
        
        do {
            try FileManager.default.moveItem(atPath: filePath, toPath: path)
            print(" 💫 ", "保存文件成功！ filePath: ", path)
        }catch {
            print(" 💫 ", "保存文件失败！ error: ", error)
            return nil
        }
        
        return path
    }
    
    class func saveFileToCaches(from filePath: String, _ fileName: String) -> String? {
        let path = cachesPath + fileName
        
        if FileManager.default.fileExists(atPath: path) {
            _ = removeFile(path)
        }
        
        guard createFolder(cachesPath) else {return nil}
        
        do {
            try FileManager.default.moveItem(atPath: filePath, toPath: path)
            print(" 💫 ", "保存文件成功！ filePath: ", path)
        }catch {
            print(" 💫 ", "保存文件失败！ error: ", error)
            return nil
        }
        
        return path
    }
    
    // 创建文件夹
    class func createFolder(_ path: String) -> Bool {
        guard !directoryIsExists(path) else {return true}
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        }catch {
            print(" 💫 ", "创建文件夹失败！ error: ", error)
            return false
        }
    }
    
    // 判断文件夹是否存在
    class func directoryIsExists(_ path: String) -> Bool {
        var directoryExists = ObjCBool.init(false)
        let fileExists = FileManager.default.fileExists(atPath: path, isDirectory: &directoryExists)
        
        return fileExists && directoryExists.boolValue
    }
    
    /// 计算缓存大小
    static var cacheSize: Float {
        get{
            // 路径
            let basePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let fileManager = FileManager.default
            // 遍历出所有缓存文件加起来的大小
            var total: Float = 0
            if fileManager.fileExists(atPath: basePath!) {
                if let childrenPath = fileManager.subpaths(atPath: basePath!) {
                    for path in childrenPath {
                        let childPath = basePath!.appending("/").appending(path)
                        do{
                            let attr: [FileAttributeKey : Any] = try fileManager.attributesOfItem(atPath: childPath)
                            let fileSize = attr[FileAttributeKey.size] as! Float
                            total += fileSize
                        }catch _ {
                            
                        }
                    }
                }
            }
            // 缓存文件大小
            return total
        }
    }
    
    /// 清除所有缓存
    ///
    /// - returns: 是否清理成功
    class func clearCache() -> Bool {
        var result = true
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            // 拼接文件路径
            let path = cachePath?.appending("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                // 循环删除
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    // 删除失败
                    result = false
                }
            }
        }
        
        return result
    }
}

extension XJJFile {
    static func file_date(_ format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
}
