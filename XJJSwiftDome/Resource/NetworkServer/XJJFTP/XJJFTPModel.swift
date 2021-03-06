//
//  XJJFTPModel.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/5.
//

import Foundation
import UIKit

class XJJFTPFileModel: NSObject, Codable {
    
    enum SourceType: String, Codable {
        case filePath = "filePath"
        case fileData = "fileData"
    }
    
    var tag: Int = 0 // 文件标识
    var userName: String = "" // 本机名称
    var fileName: String = "" // 文件名称
    var filePath: String = "" // 文件路径
    var fileData: Data? // 文件数据Data
    var fileSize: Int = 0 // 文件大小
    var fileType: SourceType = .fileData // 文件类型
    
    // 本地路径
    init(urlString id: Int, fileName: String, filePath: String, fileSize: Int, fileType: SourceType) {
        super.init()
        self.tag = id
        self.fileName = fileName
        self.filePath = filePath
        self.fileSize = fileSize
        self.fileType = fileType
    }
    
    // Data数据
    init(data id: Int, fileName: String, fileData: Data, fileSize: Int, fileType: SourceType) {
        super.init()
        self.tag = id
        self.fileName = fileName
        self.fileData = fileData
        self.fileSize = fileSize
        self.fileType = fileType
    }
}

class XJJFTPModel: NSObject, Codable {
    
    var userName: String = "" // 本机名称
    var toUserName: String = "" // 发送名称
    var ipAddress: String = "" // 发送ip地址
    var sendTime: String = "" // 发送时间
    var files: [XJJFTPFileModel] = [] // 发送数据组
        
    init(userName: String, toUserName: String, ipAddress: String, files: [XJJFTPFileModel]) {
        super.init()
        self.userName = userName
        self.toUserName = toUserName
        self.ipAddress = ipAddress
        self.sendTime = self.send_Time("HH:mm")
        self.files = files
        self.files.forEach { $0.userName = userName }
    }
    
    func send_Time(_ format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
}

//MARK: - 头文件模型
class XJJFTPHeaderModel: NSObject, Codable {
    var tag: Int = 0 // 文件标识
    var userName: String = "" // 用户名称
    var fileName: String = "" // 文件名称
    var size: Int = 0 // 文件大小
}
