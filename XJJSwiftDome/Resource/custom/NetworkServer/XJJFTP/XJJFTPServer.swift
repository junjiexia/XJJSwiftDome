//
//  XJJFTPServer.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/5.
//

import Foundation
import UIKit

class XJJFTPServer: NSObject {
        
    weak var delegate: XJJFTPServerDelegate?
    
    private var serverSocket: XJJAsyncSocket!
    private var clientSockets: [GCDAsyncSocket] = [] // 保存链接的客户端 socke 的向客户端发送消息是用的该 socket
    private var headerDic: [String : Any]? = nil
    private var name: String = "myFTPServer"
    
    init(_ name: String? = nil) {
        super.init()
        if let _n = name { self.name = _n }
        self.initSocket()
    }
    
    private func initSocket() {
        serverSocket = XJJAsyncSocket()
        serverSocket.identity = name
        serverSocket.delegate = self
        serverSocket.delegateQueue = DispatchQueue.global()
    }
    
    func startServer() {
        do {
            try serverSocket.accept(onPort: XJJFTPConfig.port)
            ftp_print("服务器启动成功...端口为：", XJJFTPConfig.port)
        } catch  {
            ftp_print("服务器启动失败, 错误:", error)
        }
    }
    
    func send(_ dict: [String: Any], _ clientSocket: GCDAsyncSocket) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            self.sendData(data: jsonData, XJJFTPConfig.server_send_infos_tag, XJJFTPConfig.info, clientSocket)
        }catch {
            ftp_print("服务器发送, json转换错误:", error)
        }
    }
    
    func sendMessage(_ message: String, _ clientSocket: GCDAsyncSocket) {
        guard let data = message.data(using: .utf8) else {return}
        self.sendData(data: data, XJJFTPConfig.server_send_message_tag, XJJFTPConfig.message, clientSocket)
    }
    
    func sendData(data: Data, _ tag: Int, _ fileName: String, _ clientSocket: GCDAsyncSocket) {
        
        var headerDic: [String : Any] = [String : Any]();
        headerDic["size"] = data.count
        headerDic["tag"] = tag
        headerDic["fileName"] = fileName
        headerDic["userName"] = name
        
        guard var mData = headerDic.toJSONData() else {return}
        mData.append(GCDAsyncSocket.crlfData()) // 分界
        mData.append(data)
        
        ftp_print("服务器发送, 数据:", data, "...header:", headerDic)
        ftp_print("服务器发送, 是否是主线程:", RunLoop.current.isEqual(RunLoop.main))
        
        clientSocket.write(mData, withTimeout: -1, tag: tag)
    }
}

extension XJJFTPServer: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        ftp_print("服务器写入完成...", tag)
        ftp_print("服务器写入完成，是否是主线程:", RunLoop.current.isEqual(RunLoop.main))
    }
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        ftp_print("服务器有新的连接")
        if let socket = newSocket as? XJJAsyncSocket {
            socket.tag = (clientSockets.count + 1) * XJJFTPConfig.id_tag // 对应客户端id = (客户端在数组中的下标 + 1) * XJJFTPConfig.id_tag
            clientSockets.append(socket)
            newSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: socket.tag)
        }else {
            clientSockets.append(newSocket)
            newSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: XJJFTPConfig.server_accept_tag)
        }
    }
    
    //这里获取不到userName和fileName，只能以tag值做唯一标识
    func socket(_ sock: GCDAsyncSocket, didReadPartialDataOfLength partialLength: UInt, tag: Int) {
        let progress = sock.progress(ofReadReturningTag: nil, bytesDone: nil, total: nil)
        ftp_print("服务器接收大小:", partialLength, "...tag:", tag, "...进度:", progress)
        DispatchQueue.main.async {
            if !progress.isNaN {
                self.delegate?.serverSingleProgress?(tag, progress)
            }
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        var userName = ""
        var fileName = ""
        var newTag: Int = 0 // 客户端id + 文件id
        
        if headerDic == nil {
            headerDic = data.JSONToAny() as? [String : Any]
            
            if headerDic == nil {
                ftp_print("当前数据包头为空")
                sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: tag)
            }else {
                if let length = headerDic?["size"] as? UInt {
                    userName = headerDic?["userName"] as? String ?? ""
                    fileName = headerDic?["fileName"] as? String ?? ""
                    let _tag = headerDic?["tag"] as? Int ?? 0
                    newTag = _tag + tag
                    ftp_print("服务器接收, 当前用户:", userName, "tag:", newTag)
                    sock.readData(toLength: length, withTimeout: -1, tag: newTag)
                }
            }
            return;
        }
        
        if let packetLength: UInt = headerDic?["size"] as? UInt {
            if packetLength <= 0 || Int(packetLength) != data.count {
                ftp_print("当前数据包错误")
                sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: newTag)
                return
            }
        }
        
        fileName = headerDic?["fileName"] as? String ?? ""
        userName = headerDic?["userName"] as? String ?? ""
        ftp_print("服务器接收, header:", headerDic ?? "no header")
        headerDic = nil
        // 处理 data 数据
        self.dataProcessing(data, fileName, sock, tag)
        DispatchQueue.main.async {
            self.delegate?.serverSingleEndTransfer?(newTag)
        }
        
        sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: newTag)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        ftp_print("服务器有客户端断开连接：", sock, "发现错误：", err.debugDescription)
    }
    
    // 处理 data 数据
    func dataProcessing(_ data: Data, _ fileName: String?, _ socket: GCDAsyncSocket, _ tag: Int) {
        if let json = data.JSONToAny() as? [String: Any] {
            ftp_print("服务器接收, json 数据:", json)
            self.analysisDict(data, socket, tag)
        }
        else if let result = String(data: data, encoding: .utf8) {
            ftp_print("服务器接收, 字符串数据:", result)
            self.analysisString(result)
        }
        else if let image = UIImage(data: data) {
            ftp_print("服务器接收, 图片:", image)
        }
        else if let videoPath = XJJFile.saveData(data: data, withFileName: fileName) {
            ftp_print("服务器接收, 视频路径:", videoPath)
        }
        else
        {
            ftp_print("服务器接收, 未知类型...")
        }
    }
    
    //json数据处理//
    private func analysisDict(_ data: Data, _ socket: GCDAsyncSocket, _ tag: Int) {
        
        if let model: XJJFTPHeaderModel = data.dataToModel() {
            
            DispatchQueue.main.async {
                self.delegate?.ftpHeaderReceive?(model, sendMessage: {[weak self] in
                    guard let sself = self else {return}
                    sself.sendMessage("ready", socket)
                })
            }
        }else {
            ftp_print("服务器接收, json数据解析错误!")
        }
    }
    
    //字符串处理
    private func analysisString(_ message: String) {
        
    }
}

@objc protocol XJJFTPServerDelegate: NSObjectProtocol {
    // 单条数据接收
    // id: 唯一标识
    // progress: 进度
    @objc optional func serverSingleProgress(_ id: Int, _ progress: Float) // 传输中
    @objc optional func serverSingleEndTransfer(_ id: Int) // 传输完成
    //头文件数据接收、处理
    // model: 获取到的数据
    // sendMessage: 调用，发送 ready 给客户端
    @objc optional func ftpHeaderReceive(_ model: XJJFTPHeaderModel, sendMessage: (() -> Void)?) //
}
