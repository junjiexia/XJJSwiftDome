//
//  XJJFTP.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/5.
//

/* FTP
 通过三次握手，由客户端发送文件，服务端获取文件
 */

import Foundation
import UIKit

class XJJFTP {
    
    static let share = XJJFTP()
    
    private var server: XJJFTPServer!
    private var client: XJJFTPClient!
    
    init() {
        self.server = XJJFTPServer()
    }
    
    // 1. 开启服务端，传输需要服务端开启
    func startServer() {
        self.server.startServer()
    }
    
    // 2. 创建本机客户端
    //默认值：本机ip
    func creatClient(name: String, _ serverPath: String? = nil) {
        self.client = XJJFTPClient(name, serverUrl: serverPath)
        self.client.socketConnect()
//        self.sendMessage("测试，是否成功...")
    }
    
    // 3. 发送image或者video前，先发送信息给对方确认
    func sendInfo(_ info: [String: Any]) {
        self.client.sendInfo(info)
    }
    
    // 4-1. 发送消息
    func sendMessage(_ message: String) {
        self.client.sendMessage(message)
    }
    
    // 4-2. 发送数据文件
    func sendFiles(data: XJJFTPModel) {
        for i in 0..<data.files.count {
            data.files[i].tag = i + 1
            let item = data.files[i]
            switch item.fileType {
            case .fileData:
                //path，url都不能用，只能用data
                if let _d = item.fileData {
                    self.sendFile(_d, item.tag, item.fileName)
                }
            case .filePath:
                self.sendFile(URL(fileURLWithPath: item.filePath), item.tag, item.fileName)
            }
        }
    }
    
    func sendFile(_ fileData: Data?, _ tag: Int, _ fileName: String) {
        guard let data = fileData else {return}
        self.client.sendData(data, tag, fileName)
    }
    
    func sendFile(_ fileUrl: URL?, _ tag: Int, _ fileName: String) {
        guard let url = fileUrl else {return}
        print("file url: ", url)
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            self.client.sendData(data, tag, fileName)
        }catch {
            print(error)
        }
    }
}

extension XJJFTP {
    //保存图片到相册
    func saveImageToAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject)
    {
        print("=====save image...=====")
        if let error = didFinishSavingWithError {
            print("error:", error)
            return
        }
        print("=====save image complete=====")
    }
    
    //保存视频到相册
    func saveVideoToAlbum(_ videoPath: String) {
        UISaveVideoAtPathToSavedPhotosAlbum(videoPath,
                                            self,
                                            #selector(video(_:didFinishSavingWithError:contextInfo:)),
                                            nil)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError: NSError?, contextInfo: AnyObject)
    {
        print("=====save video...=====")
        print("=====video path:", videoPath)
        if let error = didFinishSavingWithError {
            print("error:", error)
            return
        }
        print("=====save video complete=====")
        _ = XJJFile.removeFile(videoPath)
    }
}
