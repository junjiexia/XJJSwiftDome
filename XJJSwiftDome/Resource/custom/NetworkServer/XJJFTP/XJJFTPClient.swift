//
//  XJJFTPClient.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/5.
//

import Foundation
import UIKit

class XJJFTPClient: NSObject {
    
    var sendProgress: ((Float) -> Void)?
    
    weak var delegate: XJJFTPClientDelegate?
    
    private var clientSocket: XJJAsyncSocket!
    private var headerDic: [String : Any]? = nil // 处理接收信息用到
    private var name: String = "myFTPClient"
    private var serverUrl: String = "127.0.0.1"
        
    init(_ name: String, serverUrl: String? = nil) {
        super.init()
        self.name = name
        if let path = serverUrl { self.serverUrl = path }
        self.initSocket()
    }
    
    private func initSocket() {
        clientSocket = XJJAsyncSocket()
        clientSocket.identity = name
        clientSocket.delegate = self
        clientSocket.delegateQueue = DispatchQueue.global()
    }
    
    /// 连接服务器
    func socketConnect() {
        guard !clientSocket.isConnected else {return}
        do {
            try clientSocket.connect(toHost: serverUrl, onPort: XJJFTPConfig.port)
            ftp_print("连接服务器...")
        } catch {
            ftp_print("连接服务器 错误:", error)
        }
    }
    
    /// 断开 socket 链接
    func disconnect() {
        if clientSocket.isConnected {
            clientSocket.disconnect()
        }
    }
        
    /// 发送消息
    ///
    /// - Parameter data: 消息的二进制
    func sendData(_ data: Data, _ tag: Int, _ fileName: String) {

        var headerDic: [String : Any] = [String : Any]()
        headerDic["size"] = data.count
        headerDic["tag"] = tag
        headerDic["fileName"] = fileName
        headerDic["userName"] = name
        
        guard var mData = headerDic.toJSONData() else {return}
        mData.append(GCDAsyncSocket.crlfData()) // 分界
        mData.append(data)
        
        ftp_print("客户端发送, 数据:", data, "...header:", headerDic)
        ftp_print("客户端发送, 是否是主线程:", RunLoop.current.isEqual(RunLoop.main))
        
        clientSocket.write(mData, withTimeout: -1, tag: tag)
    }
    
    func sendInfo(_ info: [String: Any]) {
        do {
            let json = try JSONSerialization.data(withJSONObject: info, options: .prettyPrinted)
            self.sendData(json, XJJFTPConfig.client_send_infos_tag, XJJFTPConfig.info)
        }catch {
            ftp_print("客户端发送，json转换错误:", error)
        }
    }
    
    func sendMessage(_ message: String) {
        guard let data = message.data(using: .utf8) else {return}
        self.sendData(data, XJJFTPConfig.client_send_message_tag, XJJFTPConfig.message)
    }
}

extension XJJFTPClient: GCDAsyncSocketDelegate {
    
    func socket(_ sock: GCDAsyncSocket, didWritePartialDataOfLength partialLength: UInt, tag: Int) {
        let progress = clientSocket.progress(ofWriteReturningTag: nil, bytesDone: nil, total: nil)
        ftp_print("客户端发送, 进度:", progress, "...大小:", partialLength, "...tag:", tag)
        DispatchQueue.main.async {
            if !progress.isNaN {
                self.delegate?.clientSingleProgress?(tag, progress)
            }
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        ftp_print("客户端发送完成...", tag, "是否是主线程:", RunLoop.current.isEqual(RunLoop.main))
        DispatchQueue.main.async {
            self.delegate?.clientSingleEndTransfer?(tag)
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        ftp_print("连接服务器成功，url：", url.path)
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        ftp_print("连接服务器成功，host：", host, "prot：", port)
        clientSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: XJJFTPConfig.client_connect_tag)
        clientSocket.perform {[weak self] in
            guard let sself = self else {return}
            sself.clientSocket.enableBackgroundingOnSocket()
        }
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        ftp_print("服务器连接断开", err ?? "no error.")
    }
    
    func socket(_ sock: GCDAsyncSocket, didReadPartialDataOfLength partialLength: UInt, tag: Int) {
        let progress = sock.progress(ofReadReturningTag: nil, bytesDone: nil, total: nil)
        ftp_print("客户端接收数据大小:", partialLength, "...tag:", tag, "...进度:", progress)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        if headerDic == nil {
            headerDic = data.JSONToAny() as? [String : Any]
            
            if headerDic == nil {
                ftp_print("当前数据包头为空")
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
                ftp_print("当前数据包错误")
                clientSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: tag)
                return
            }
        }
        
        // 处理 data 数据
        ftp_print("客户端接收, header:", headerDic ?? "no header")
        let fileName: String? = headerDic?["fileName"] as? String
        self.dataProcessing(data, fileName, sock)

        headerDic = nil
        
        clientSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: tag)
    }
    
    // 处理 data 数据
    func dataProcessing(_ data: Data, _ fileName: String?, _ socket: GCDAsyncSocket) {
        if let json = data.JSONToAny() as? [String: Any] {
            ftp_print("客户端接收, json 数据:", json)
            self.analysisDict(data, socket)
        }
        else if let result = String(data: data, encoding: .utf8) {
            ftp_print("客户端接收, 字符串数据:", result)
            self.analysisString(result)
        }
        else if let image = UIImage(data: data) {
            ftp_print("客户端接收, 图片:", image)
            XJJFTP.share.saveImageToAlbum(image)
        }
        else if let videoPath = XJJFile.saveData(data: data, withFileName: fileName) {
            ftp_print("客户端接收, 视频路径:", videoPath)
            XJJFTP.share.saveVideoToAlbum(videoPath)
        }
        else
        {
            ftp_print("客户端接收, 未知类型...")
        }
    }
    
    //json数据处理
    private func analysisDict(_ data: Data, _ socket: GCDAsyncSocket) {
        
    }
    
    //字符串处理
    private func analysisString(_ message: String) {
        if message == "ready" {
            DispatchQueue.main.async {
                self.delegate?.sendDataReady?()
            }
        }
    }
}

@objc protocol XJJFTPClientDelegate: NSObjectProtocol {
    // 单条数据接收
    @objc optional func clientSingleProgress(_ id: Int, _ progress: Float) // 传输中
    @objc optional func clientSingleEndTransfer(_ id: Int) // 传输完成
    // 收到服务端 ready 消息后，发送数据给服务器（上传）
    @objc optional func sendDataReady() //
}
