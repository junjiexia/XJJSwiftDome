//
//  XJJHTTPManager.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/2.
//

import Foundation
import Reachability

typealias XJJHTTPHeader = [String: String]
typealias XJJHTTPParams = [String: Any]

enum EHTTPMethod {
    case post
    case get
    case upload
    case download
}

final class XJJHTTPManager {
    
    static let share = XJJHTTPManager()
    
    var reachability: Reachability?
    var networkEnable: Bool = true
    
    init() {
        self.reachability = try? Reachability()
        
        self.reachability?.whenReachable = {[weak self] reachability in
            guard let sself = self else {return}
            switch reachability.connection {
            case .wifi, .cellular:
                sself.networkEnable = true
            case .none:
                sself.networkEnable = false
            case .unavailable:
                sself.networkEnable = false
            }
        }

        self.reachability?.whenUnreachable = {[weak self] _ in
            guard let sself = self else {return}
            sself.networkEnable = false
            print("Not reachable")
        }

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func post<T: Codable>(_ urlStr: String, contentType: XJJHTTPDataType.TType? = .JSON, params: XJJHTTPParams, header: XJJHTTPHeader, body: Data? = nil, callback: ((_ isSuccess: Bool,_ result: T?, _ d: String?, _ errorCode: Int?) -> Void)?) {
        let head = self.setupHeader(header)
        
        XJJHTTPRequest.share.request(urlStr, contentType: contentType!, method: "POST", params: params, header: head, body: body, callback: callback)
    }
    
    func get<T: Codable>(_ urlStr: String, contentType: XJJHTTPDataType.TType? = .JSON, params: XJJHTTPParams, header: XJJHTTPHeader, body: Data? = nil, callback: ((_ isSuccess: Bool,_ result: T?, _ d: String?, _ errorCode: Int?) -> Void)?) {
        let head = self.setupHeader(header)
        
        XJJHTTPRequest.share.request(urlStr, contentType: contentType!, method: "GET", params: params, header: head, body: body, callback: callback)
    }
    // 没有默认 header 和 param 的 post 方法
    func none_post<T: Codable>(_ urlStr: String, contentType: XJJHTTPDataType.TType? = .JSON, params: XJJHTTPParams, header: XJJHTTPHeader, body: Data? = nil, callback: ((_ isSuccess: Bool,_ result: T?, _ d: String?, _ errorCode: Int?) -> Void)?) {
        
        XJJHTTPRequest.share.request(urlStr, contentType: contentType!, method: "POST", params: params, header: header, body: body, callback: callback)
    }
    // 没有默认 header 和 param 的 get 方法
    func none_get<T: Codable>(_ urlStr: String, contentType: XJJHTTPDataType.TType? = .JSON, params: XJJHTTPParams, header: XJJHTTPHeader, body: Data? = nil, callback: ((_ isSuccess: Bool,_ result: T?, _ d: String?, _ errorCode: Int?) -> Void)?) {
        
        XJJHTTPRequest.share.request(urlStr, contentType: contentType!, method: "GET", params: params, header: header, body: body, callback: callback)
    }
    // 1、没有默认 header 和 param 的 post 方法
    // 2、没有默认返回格式，直接按照 T 类型返回
    func emptyFormat_post<T: Codable>(_ urlStr: String, contentType: XJJHTTPDataType.TType? = .JSON, params: XJJHTTPParams, header: XJJHTTPHeader, body: Data? = nil, callback: ((_ isSuccess: Bool,_ result: T?, _ d: String?, _ errorCode: Int?) -> Void)?) {
        
        XJJHTTPRequest.share.request(urlStr, contentType: contentType!, method: "POST", params: params, header: header, body: body, emptyFormat: true, callback: callback)
    }
    // 1、没有默认 header 和 param 的 get 方法
    // 2、没有默认返回格式，直接按照 T 类型返回
    func emptyFormat_get<T: Codable>(_ urlStr: String, contentType: XJJHTTPDataType.TType? = .JSON, params: XJJHTTPParams, header: XJJHTTPHeader, body: Data? = nil, callback: ((_ isSuccess: Bool,_ result: T?, _ d: String?, _ errorCode: Int?) -> Void)?) {
        
        XJJHTTPRequest.share.request(urlStr, contentType: contentType!, method: "GET", params: params, header: header, body: body, emptyFormat: true, callback: callback)
    }
    // 下载
    func download(_ urlStr: String, _ fileName: String, saveFileType: XJJHTTPFileSaveType? = nil, needCache: Bool? = true, _ callback: ((_ isSuccess: Bool, _ filePath: String?, _ data: Data?) -> Void)?) {
        XJJHTTPRequest.share.download(urlStr, fileName, saveFileType: saveFileType, needCache: needCache, callback)
    }
    // 批量下载
    func batchDownload(_ arr: [XJJHTTPDownloadWorkerItem], _ callback: ((_ isSuccess: Bool, _ filePath: String?, _ data: Data?, _ index: Int) -> Void)?) {
        XJJHTTPRequest.share.batchDownload(arr, callback)
    }
    // 上传
    func upload(_ uploadItem: XJJHTTPUploadWorkerItem, _ progressBlock: ((_ progress: Float) -> Void)?, _ finishedBlock: ((_ isSuccess: Bool, _ result: String) -> Void)?) {
        XJJHTTPRequest.share.upload(uploadItem, progressBlock, finishedBlock)
    }
    // 批量上传
    func batchUpload(_ arr: [XJJHTTPUploadWorkerItem], _ progressBlock: ((_ progress: Float, _ index: Int) -> Void)?, _ finishedBlock: ((_ isSuccess: Bool, _ index: Int, _ result: String) -> Void)?) {
        XJJHTTPRequest.share.batchUpload(arr, progressBlock, finishedBlock)
    }
    
    private func setupHeader(_ headers: XJJHTTPHeader) -> XJJHTTPHeader {
        var dic = defaultHeader
        
        if headers.count > 0 {
            for item in headers {
                dic.updateValue(item.value, forKey: item.key)
            }
        }
         
        return dic
    }
    
    private func setupParams(_ params: XJJHTTPParams) -> XJJHTTPParams {
        var dic = defaultParams
        
        if params.count > 0 {
            for item in params {
                dic.updateValue(item.value, forKey: item.key)
            }
        }

        return dic
    }
    
    // 设置默认通用参数
    private var defaultParams: XJJHTTPParams {
        get {
            var dic = XJJHTTPParams()
            
            dic["id"] = "admin"
            
            return dic
        }
    }
    
    // 设置默认通用请求头
    private var defaultHeader: XJJHTTPHeader {
        get {
            var head = XJJHTTPHeader()
            
            head["token"] = "token"
            
            return head
        }
    }
    
}
