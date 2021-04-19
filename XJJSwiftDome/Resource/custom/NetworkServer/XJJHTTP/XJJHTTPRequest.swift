//
//  XJJHTTPRequest.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/2.
//

import Foundation
import UIKit

final class XJJHTTPRequest: NSObject {
    
    static let share = XJJHTTPRequest()
    
    var timeout: TimeInterval = 120
    var method: String = "POST"
    
    var header: XJJHTTPHeader = [:]
    var params: XJJHTTPParams = [:]
    var body: Data?
    
    // 会话请求
    func request<T: Codable>(_ urlStr: String,
                             contentType: XJJHTTPDataType.TType,
                             method: String,
                             params: XJJHTTPParams,
                             header: XJJHTTPHeader,
                             body: Data?,
                             emptyFormat: Bool? = false,
                             callback: ((_ isSuccess: Bool, _ result: T?, _ d: String?, _ errorCode: Int?) -> Void)?) {
        guard XJJHTTPManager.share.networkEnable else {
            DispatchQueue.main.async {
                callback?(false, nil, nil, -4)
                http_print("无网络连接，请检查网络是否正常")
            }
            return
        }
        
        let paramsString = params.compactMap({ (key, value) -> String in
            let valueStr = "\(value)"
            return "\(key)=\(valueStr)"
            //return "\(key.utf8Str())=\(valueStr.utf8Str())"
        }).joined(separator: "&")
        
        self.urlString = urlStr + "?" + paramsString
        let url_str = self.urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: url_str!) else {
            DispatchQueue.main.async {
                callback?(false, nil, nil, -5)
            }
            http_print("request base:", "-url-", "invalid url:", self.urlString ?? "no url")
            return
        }
        
        self.method = method
        self.header = header
        self.params = params
        self.body = body
        
        self.createRequest(url)
        self.addHeaders(header)
        self.setupBody()
        
        //http_print(url_str ?? "")
        
        self.sendRequest(emptyFormat: emptyFormat, callback: callback)
    }
        
    override init() {
        super.init()
        
        let configuration = URLSessionConfiguration.default
        let queue: OperationQueue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: queue)
        
        self.cache.countLimit = 20
        self.cache.totalCostLimit = 10 * 1024 * 1024
        self.cache.delegate = self
        
        self.downloadTask = XJJHTTPDownloadTask()
        self.uploadTask = XJJHTTPUploadTask()
        self.streamTask = XJJHTTPStreamTask()
    }
    
    private var request: URLRequest!
    private var session: URLSession!
    private var downloadTask: XJJHTTPDownloadTask!
    private var uploadTask: XJJHTTPUploadTask!
    private var streamTask: XJJHTTPStreamTask!
    
    private var isHttps: Bool = false
    private var urlString: String? {
        didSet {
            guard let string = urlString else {return}
            self.checkUrlString(string)
        }
    }
    
    private let cache = NSCache<AnyObject, AnyObject>()
    
    private let boundaryStr: String = "--"
    private let boundaryID: String = "XyXy"
    
    private func checkUrlString(_ urlStr: String) {
        if urlStr.hasPrefix("https://") {
            self.isHttps = true
        }else {
            self.isHttps = false
        }
    }
    
    private func createRequest(_ url: URL) {
        self.request = URLRequest(url: url)
        self.request.timeoutInterval = timeout
        self.request.httpMethod = method
    }
    
    private func addHeaders(_ headers: XJJHTTPHeader) {
        guard headers.count > 0 else {return}
        for (key, value) in headers {
            
            self.request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func setupBody() {
        if let d = body {
            self.request.httpBody = d
        }
    }
    
    /**************
        normal
     **************/
    private func sendRequest<T: Codable>(emptyFormat: Bool? = false,
                                         callback: ((_ isSuccess: Bool,_ result: T?, _ d: String?, _ errorCode: Int?) -> Void)?) {
        //http_print("request base:", self.urlString ?? "", self.method, self.header, self.params)
        let urlStr = self.urlString ?? ""
                
        let task: URLSessionDataTask = self.session.dataTask(with: request) {[weak self] (data, response, error) in
            guard let sself = self else {return}
            http_print("response base:", response ?? (urlStr + "no response"))
            //http_print("current is main thread -- ", Thread.current == Thread.main)
            
            if error == nil {
                if let jsonData = data {
                    do { // 确定json格式处理
                        if emptyFormat == true {
                            let result = try JSONDecoder().decode(T.self, from: jsonData)
                            http_print("request base:", "-result-", jsonData.JSONToAny())
                            DispatchQueue.main.async {
                                callback?(true, result, "", 0)
                            }
                        }else {
                            let result = try JSONDecoder().decode(XJJHTTPResult<T>.self, from: jsonData)
                            http_print("request base:", "-result-", jsonData.JSONToAny(), "-result-T-", result)
                            DispatchQueue.main.async {
                                callback?(true, nil, "result", 0)
                            }
                        }
                    }catch { // 不确定json格式处理, 转成字符串查看数据
                        http_print("request base:", "-decode error-", urlStr, error)
                        DispatchQueue.main.async {
                            sself.jsonToStr(jsonData, callback: callback as? ((Bool, String?, String?, Int?) -> Void))
                        }
                    }
                }else { // 网络请求成功，数据返回失败
                    http_print("request base:", "-error-", urlStr, "success but no any data!")
                    DispatchQueue.main.async {
                        callback?(false, nil, nil, -2)
                    }
                }
            }else { // 网络请求失败
                http_print("request base:", "-error-", urlStr, error?.localizedDescription ?? "no value")
                DispatchQueue.main.async {
                    callback?(false, nil, nil, -1)
                }
            }
        }
        
        task.resume()
    }
    
    private func jsonToStr(_ jsonData: Data,
                           callback: ((_ isSuccess: Bool, _ result: String?, _ d: String?, _ errorCode: Int?) -> Void)?) {
        let resultStr = jsonData.JSONToStr()
        if resultStr.count > 0 { // 转字符串
            http_print("request base:", "-result-string", resultStr)
            callback?(false, resultStr, resultStr, -4)
        }else { // 转换失败
            http_print("request base:", "-error-", "data can't change to string type!")
            callback?(false, nil, "没有数据返回", -3)
        }
    }
}

//MARK: - URLSessionDelegate
extension XJJHTTPRequest: URLSessionDelegate {
    // URLSessionDelegate // 证书校验
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
    }
}

//MARK: - upload
extension XJJHTTPRequest: URLSessionTaskDelegate, URLSessionDataDelegate {
    /* ========== * upload * ========== */
    // 单文件上传
    func upload(_ uploadItem: XJJHTTPUploadWorkerItem,
                _ progressBlock: ((_ progress: Float) -> Void)?,
                _ finishedBlock: ((_ isSuccess: Bool, _ result: String) -> Void)?) {
        self.createUpload(uploadItem, { (progress) in
            DispatchQueue.main.async {
                progressBlock?(progress)
            }
        }) {[weak self] (isSuccess, result) in
            guard let sself = self else {return}
            if sself.uploadTask.items.count == 0 {
                sself.downloadTask.isRuning = false
            }
            
            DispatchQueue.main.async {
                finishedBlock?(isSuccess, result)
            }
        }
        
        self.upload()
    }
    
    // 多文件上传
    func batchUpload(_ arr: [XJJHTTPUploadWorkerItem],
                     _ progressBlock: ((_ progress: Float, _ index: Int) -> Void)?,
                     _ finishedBlock: ((_ isSuccess: Bool, _ index: Int, _ result: String) -> Void)?) {
        guard arr.count > 0 else {return}
        for i in 0..<arr.count {
            let item = arr[i]
            self.createUpload(item, { (progress) in
                DispatchQueue.main.async {
                    progressBlock?(progress, i)
                }
            }) {[weak self] (isSuccess, result) in
                guard let sself = self else {return}
                if sself.uploadTask.items.count == 0 {
                    sself.downloadTask.isRuning = false
                }
                
                DispatchQueue.main.async {
                    finishedBlock?(isSuccess, i, result)
                }
            }
        }
        
        self.upload()
    }
    /**************
        upload
     **************/
    private func createUpload(_ uploadItem: XJJHTTPUploadWorkerItem,
                              _ progressBlock: ((_ progress: Float) -> Void)?,
                              _ finishedBlock: ((_ isSuccess: Bool, _ result: String) -> Void)?) {
        guard let urlStr = uploadItem.urlStr, let data = uploadItem.data else {
            http_print("request base:", "-upload url or data-invalid:", uploadItem.urlStr ?? "no url", uploadItem.data ?? "no data")
            return
        }
        let url_str = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: url_str!) else {
            http_print("request base:", "-upload url-invalid url:", url_str ?? "no url")
            return
        }
        
        if self.uploadTask.items.count > 0 {
            self.downloadTask.maxIndex = -1
        }
        
        /// task item ///
        let item = XJJHTTPUploadItem()
        item.url = url
        self.uploadTask.maxIndex += 1
        item.identifier = self.uploadTask.maxIndex
        
        /// data ///
        //固定拼接的第一部分
        var top: String = ""
        top.append("\(boundaryStr)\(boundaryID)\r\n")
        top.append("Content-Disposition: form-data; name=\"\(uploadItem.name)\"; filename=\"\(uploadItem.fileName)\"\r\n")
        top.append("Content-Type: \(XJJHTTPDataType.get(uploadItem.uploadFileType))\r\n\r\n")
        
        //固定拼接第三部分
        var buttom: String = "\r\n"
        buttom.append("\(boundaryStr)\(boundaryID)\r\n")
        buttom.append("Content-Disposition: form-data; name=\"submit\"\r\n\r\n")
        buttom.append("Submit\r\n")
        buttom.append("\(boundaryStr)\(boundaryID)--\r\n")
        
        //拼接
        var fromData = top.data(using: .utf8)!
        fromData.append(data)
        fromData.append(buttom.data(using: .utf8)!)
        
        /// request ///
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        request.httpMethod = "POST"
        request.setValue("\(fromData.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("multipart/form-data; boundary=\(boundaryID)", forHTTPHeaderField: "Content-Type")
        //request.httpBody = fromData
        
        /// task ///
        let task = self.session.uploadTask(with: request, from: fromData)
        
        task.setValue(item.identifier, forKey: "uploadTaskIdentifier")
        item.task = task
        
        item.uploadProgressBlock = { progress in
            progressBlock?(progress)
        }
        
        item.uploadCompleteBlock = {[weak self] isSuccess, result in
            guard let sself = self else {return}
            finishedBlock?(isSuccess, result)
            item.clear()
            sself.uploadTask.items = sself.uploadTask.items.filter{ $0.identifier != item.identifier }
        }
        
        self.uploadTask.items.append(item)
    }
    
    private func upload() {
        guard self.uploadTask.items.count > 0 else {return}
        
        self.uploadTask.isRuning = true
        for item in self.uploadTask.items {
            item.task?.resume()
        }
    }
    
    /* ========== * delegate * ========== */
    // URLSessionTaskDelegate // 获取进度
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard self.uploadTask.items.count > 0 else {return}
        
        for item in self.uploadTask.items {
            if item.task?.taskIdentifier == task.taskIdentifier {
                http_print("request base:", "-upload-send bytes:", bytesSent, "total send bytes:", totalBytesSent, "total bytes:", totalBytesExpectedToSend)
                
                let progress: Float = Float(totalBytesSent / totalBytesExpectedToSend)
                item.uploadProgressBlock?(progress)
                http_print("request base:", "-upload-progress:", progress)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard self.uploadTask.items.count > 0 else {return}
        
        for item in self.uploadTask.items {
            if item.task?.taskIdentifier == task.taskIdentifier {
                http_print("request base:", "-upload completed-error:", error ?? "no error")
                
                if error != nil {
                    item.uploadCompleteBlock?(false, "")
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard self.uploadTask.items.count > 0 else {return}
        
        for item in self.uploadTask.items {
            if item.task?.taskIdentifier == dataTask.taskIdentifier {
                http_print("request base:", "-upload did receive-data:", data.JSONToStr())
                item.uploadCompleteBlock?(true, data.JSONToStr())
            }
        }
    }
}

//MARK: - download
extension XJJHTTPRequest: URLSessionDownloadDelegate {
    // 单个文件下载
    func download(_ urlStr: String,
                  _ fileName: String,
                  saveFileType: XJJHTTPFileSaveType? = nil,
                  needCache: Bool? = true,
                  _ callback: ((_ isSuccess: Bool, _ filePath: String?, _ data: Data?) -> Void)?) {
        if let data = self.cache.object(forKey: urlStr as AnyObject) as? Data {
            DispatchQueue.main.async {
                callback?(true, nil, data)
            }
            http_print("download", "-has cache-", data.count)
            return
        }else {
            self.createDownload(urlStr, fileName, saveFileType: saveFileType, needCache: needCache) {[weak self] (isSuccess, filePath, data) in
                guard let sself = self else {return}
                
                if sself.downloadTask.items.count == 0 {
                    sself.downloadTask.isRuning = false
                    if sself.downloadTask.tempItems.count > 0 {
                        sself.downloadTask.items = sself.downloadTask.tempItems
                        sself.downloadTask.tempItems = []
                        sself.download()
                    }
                }
                
                //http_print("request base:", "-download-", "Is main thread:", Thread.current.isMainThread)
                
                DispatchQueue.main.async {
                    callback?(isSuccess, filePath, data)
                }
            }
            self.download()
        }
    }
    
    // 多个文件下载
    func batchDownload(_ arr: [XJJHTTPDownloadWorkerItem],
                       _ callback: ((_ isSuccess: Bool, _ filePath: String?, _ data: Data?, _ index: Int) -> Void)?) {
        guard arr.count > 0 else {return}
        for i in 0..<arr.count {
            autoreleasepool {
                let item = arr[i]
                if let str = item.urlStr {
                    if let data = self.cache.object(forKey: str as AnyObject) as? Data {
                        DispatchQueue.main.async {
                            callback?(true, nil, data, i)
                        }
                        http_print("download", "-has cache-", "NO.\(i)", data.count)
                    }else {
                        self.createDownload(str, item.fileName ?? "file", saveFileType: item.saveFileType, needCache: item.needCache) {[weak self] (isSuccess, filePath, data) in
                            guard let sself = self else {return}
                            
                            if sself.downloadTask.items.count == 0 {
                                sself.downloadTask.isRuning = false
                                if sself.downloadTask.tempItems.count > 0 {
                                    sself.downloadTask.items = sself.downloadTask.tempItems
                                    sself.downloadTask.tempItems = []
                                    sself.download()
                                }
                            }
                            
                            //http_print("request base:", "-download-batch", "Is main thread:", Thread.current.isMainThread)
                            //http_print("request base:", "-download-taskCount", sself.downloadTask.items.count, sself.downloadTask.tempItems.count, sself.downloadTask.isRuning)
                            DispatchQueue.main.async {
                                callback?(isSuccess, filePath, data, i)
                            }
                        }
                    }
                }
            }
        }
        
        self.download()
    }
    /**************
        download
     **************/
    private func createDownload(_ urlStr: String,
                                _ fileName: String,
                                saveFileType: XJJHTTPFileSaveType? = nil,
                                needCache: Bool? = true,
                                _ callback: ((_ isSuccess: Bool, _ filePath: String?, _ data: Data?) -> Void)?) {
        let url_str = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: url_str!) else {
            http_print("request base:", "-download url-invalid url:", url_str ?? "no url")
            return
        }
        
        if self.downloadTask.items.count == 0, self.downloadTask.tempItems.count == 0 {
            self.downloadTask.maxIndex = -1
        }
        
        let item = XJJHTTPDownloadItem()
        item.fileName = fileName
        item.url = url
        item.fileSaveType = saveFileType ?? .caches
        self.downloadTask.maxIndex += 1
        item.identifier = self.downloadTask.maxIndex
        item.needCache = needCache!
        var request = URLRequest(url: item.url)
        request.timeoutInterval = timeout
        
        //http_print("request base:", "-download-create", "Is main thread:", Thread.current.isMainThread)
        
        if needCache == true {
            let task = self.session.dataTask(with: request) {[weak self] (data, response, error) in
                guard let sself = self else {return}
                item.clear()
                sself.downloadTask.items = sself.downloadTask.items.filter{ $0.identifier != item.identifier }
                guard error == nil else {
                    callback?(false, nil, nil)
                    http_print("request base:", "-download-error:", error ?? "no error")
                    return
                }
                
                sself.cache.setObject(data as AnyObject, forKey: urlStr as AnyObject, cost: data?.count ?? 0)
                http_print("request base:", "-download-result:", data?.JSONToStr() ?? "", "data count: ", data?.count ?? "0")
                callback?(true, nil, data)
            }
            item.dataTask = task
            item.task = nil
        }else {
            let task = self.session.downloadTask(with: request)
            task.setValue(item.identifier, forKey: "downloadTaskIdentifier")
            item.task = task
            item.dataTask = nil
            
            item.downloadResultblock = {[weak self] isSuccess, filePath in
                guard let sself = self else {return}
                item.clear()
                sself.downloadTask.items = sself.downloadTask.items.filter{ $0.identifier != item.identifier }
                callback?(isSuccess, filePath, nil)
            }
        }
        
        if self.downloadTask.isRuning {
            self.downloadTask.tempItems.append(item)
        }else {
            self.downloadTask.items.append(item)
        }
    }
    
    private func download() {
        guard self.downloadTask.items.count > 0 else {return}
        
        self.downloadTask.isRuning = true
        for item in self.downloadTask.items {
            if item.needCache == true {
                item.dataTask?.resume()
            }else {
                item.task?.resume()
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard self.downloadTask.items.count > 0 else {return}
        
        for item in self.downloadTask.items {
            if item.task?.taskIdentifier == downloadTask.taskIdentifier {
                //http_print("request base:", "-download completed-", "location url:", location)
                
                switch item.fileSaveType {
                case .temp:
                    if let urlStr = XJJFile.saveFile(from: location.path, item.fileName) {
                        item.downloadResultblock?(true, urlStr)
                        http_print("request base:", "-download completed-file path:", urlStr)
                    }else {
                        item.downloadResultblock?(false, nil)
                        http_print("request base:", "-download completed-save file failed")
                    }
                case .tmp:
                    if let urlStr = XJJFile.saveFileToTmp(from: location.path, item.fileName) {
                        item.downloadResultblock?(true, urlStr)
                        http_print("request base:", "-download completed-file path:", urlStr)
                    }else {
                        item.downloadResultblock?(false, nil)
                        http_print("request base:", "-download completed-save file failed")
                    }
                case .caches:
                    if let urlStr = XJJFile.saveFileToCaches(from: location.path, item.fileName) {
                        item.downloadResultblock?(true, urlStr)
                        http_print("request base:", "-download completed-file path:", urlStr)
                    }else {
                        item.downloadResultblock?(false, nil)
                        http_print("request base:", "-download completed-save file failed")
                    }
                }
                
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard self.downloadTask.items.count > 0 else {return}
        //http_print("request base:", "-download-", "write bytes:", bytesWritten, "total write bytes:", totalBytesWritten, "total bytes:", totalBytesExpectedToWrite)
    }
}

//MARK: - cache
extension XJJHTTPRequest: NSCacheDelegate {
    func clearCache() {
        self.cache.removeAllObjects()
    }
    
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let data = obj as? Data {
            http_print("request base:", "-cache-will evict data", data.count)
        }else {
            http_print("request base:", "-cache-will evict object", obj)
        }
    }
}

//MARK: - stream
extension XJJHTTPRequest: URLSessionStreamDelegate {
    
    func stream(_ item: XJJHTTPStreamWorkerTask,
                resultBlock: ((_ currentData: Data?, _ cumulativeData: Data?, _ error: Error?) -> Void)?,
                completionBlock: ((_ data: Data?, _ error: Error?) -> Void)?) {
        self.streamTask.type = item.type
        
        switch item.type {
        case .read:
            self.stream(read: item, resultBlock: resultBlock, completionBlock: completionBlock)
        case .write:
            self.stream(write: item)
        }
    }
    
    private func stream(read item: XJJHTTPStreamWorkerTask,
                        resultBlock: ((_ currentData: Data?, _ cumulativeData: Data?, _ error: Error?) -> Void)?,
                        completionBlock: ((_ data: Data?, _ error: Error?) -> Void)?) {
        guard let urlString = item.urlStr else { http_print(" stream - host name is empty!"); return}
        self.streamTask.task = session.streamTask(withHostName: urlString, port: item.port)
        self.streamTask.task?.startSecureConnection()
        self.streamTask.readData = Data()
        self.streamTask.task?.readData(ofMinLength: item.minLength, maxLength: item.maxLength, timeout: item.timeOut, completionHandler: {[weak self] (data, isCompleted, error) in
            guard let sself = self else {return}
            http_print("stream - data: ", data?.count ?? "no data", " - isCompleted: ", isCompleted, " - error: ", error ?? "no error")
            if let _data = data {
                sself.streamTask.readData?.append(_data)
            }
            if isCompleted {
                completionBlock?(sself.streamTask.readData, error)
            }else {
                resultBlock?(data, sself.streamTask.readData, error)
            }
        })
    }
    
    private func stream(write item: XJJHTTPStreamWorkerTask) {
        
    }
    
    // 告诉委托，已检测到流更好的主机路由
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
        
    }
    // 通知代理流任务已完成，因为流任务调用了captureStreams方法
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        
    }
    // 告诉委托基础套接字的读取端已关闭 -- closeRead
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        
    }
    // 告诉委托基础套接字的写入端已关闭 -- closeWrite
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        
    }
}
