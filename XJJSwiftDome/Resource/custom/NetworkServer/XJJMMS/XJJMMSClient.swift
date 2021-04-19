//
//  XJJMMSClient.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/16.
//

import Foundation
import UIKit

class XJJMMSClient: NSObject {
    
    private var clientSocket: XJJAsyncSocket! // socket
    private var serverAddress: String? // 服务器地址
    private var port: UInt16 = 1755 // 端口，默认：1755
    private var headerDic: [String : Any]? = nil // 处理接收信息用到
    
    init(host: String, port: UInt16? = nil) {
        super.init()
        self.serverAddress = host
        if let _port = port { self.port = _port }
        self.initSocket()
    }
    
    private func initSocket() {
        clientSocket = XJJAsyncSocket()
        clientSocket.delegate = self
        clientSocket.delegateQueue = DispatchQueue.global()
    }
    
    /// 连接服务器
    func socketConnect() {
        guard !clientSocket.isConnected else {return}
        guard let host = serverAddress else {return}
        do {
            try clientSocket.connect(toHost: host, onPort: port)
            mms_print("连接服务器...")
        } catch {
            mms_print("连接服务器 错误:", error)
        }
    }
    
    /// 断开 socket 链接
    func disconnect() {
        if clientSocket.isConnected {
            clientSocket.disconnect()
        }
    }
}

extension XJJMMSClient: GCDAsyncSocketDelegate {
    
    func socketDidCloseReadStream(_ sock: GCDAsyncSocket) {
        print("read close stream")
    }
    
    func socket(_ sock: GCDAsyncSocket, didReadPartialDataOfLength partialLength: UInt, tag: Int) {
        let progress = sock.progress(ofReadReturningTag: nil, bytesDone: nil, total: nil)
        mms_print("客户端接收数据大小:", partialLength, "...tag:", tag, "...进度:", progress)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        if headerDic == nil {
            headerDic = data.JSONToAny() as? [String : Any]
            
            if headerDic == nil {
                mms_print("当前数据包头为空")
                clientSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: tag)
            }else {
                if let length = headerDic?["size"] as? UInt {
                    let _tag: Int = (headerDic?["tag"] as? Int) ?? 0
                    clientSocket.readData(toLength: length, withTimeout: -1, tag: _tag)
                }
            }
            return
        }
        
        if let packetLength: UInt = headerDic?["size"] as? UInt {
            if packetLength <= 0 || Int(packetLength) != data.count {
                mms_print("当前数据包错误")
                clientSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: tag)
                return
            }
        }
        
        // 处理 data 数据
        mms_print("客户端接收, header:", headerDic ?? "no header")
        let fileName: String? = headerDic?["fileName"] as? String
        self.dataProcessing(data, fileName, sock)

        headerDic = nil
        
        clientSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: tag)
    }
    
    // 处理 data 数据
    func dataProcessing(_ data: Data, _ fileName: String?, _ socket: GCDAsyncSocket) {
        if let json = data.JSONToAny() as? [String: Any] {
            mms_print("客户端接收, json 数据:", json)
            self.analysisDict(data, socket)
        }
        else if let result = String(data: data, encoding: .utf8) {
            mms_print("客户端接收, 字符串数据:", result)
            self.analysisString(result)
        }
        else if let image = UIImage(data: data) {
            mms_print("客户端接收, 图片:", image)
            XJJFTP.share.saveImageToAlbum(image)
        }
        else if let videoPath = XJJFile.saveData(data: data, withFileName: fileName) {
            mms_print("客户端接收, 视频路径:", videoPath)
            XJJFTP.share.saveVideoToAlbum(videoPath)
        }
        else
        {
            mms_print("客户端接收, 未知类型...")
        }
    }
    
    //json数据处理
    private func analysisDict(_ data: Data, _ socket: GCDAsyncSocket) {
        
    }
    
    //字符串处理
    private func analysisString(_ message: String) {
        
    }
}
