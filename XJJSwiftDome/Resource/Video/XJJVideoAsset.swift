//
//  XJJVideoAsset.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/2.
//

import Foundation
import AVKit

class XJJVideoAsset: NSObject {
    
    var asset: AVURLAsset?
    var port: Int = 8080
    
    private var replace_url = DType.m3u8.rawValue // 拦截 asset 协议用的url
    private var realUrl: String = "" // 真实url
    private var asset_options: [String: Any] = [:] // asset 条件
    private var dType: DType = .none
    
    enum DType: String {
        case none = ""
        case m3u8 = "m3u8_scheme://abcd.m3u8"
    }
    
    enum XJJVideoAssetError: Error {
        case m3u8FileWrong(String)
    }
    
    override init() { super.init() }
    
    init(urlString: String, options: [String : Any]? = nil) {
        super.init()
        // 替换 scheme 用于拦截 asset 协议
        self.realUrl = urlString
        self.setupDType()
        
        if let _options = options {
            self.asset_options = _options
        }
        self.asset_options[AVURLAssetAllowsCellularAccessKey] = false // 防止其在通过网络连接时检索其媒体
        
        // 创建 asset 资源
        guard let url = URL(string: replace_url) else { XJJVideo_print("asset 拦截 url 转换失败！-_-"); return}
        XJJVideo_print("asset url: ", url)
        self.asset = AVURLAsset(url: url, options: asset_options)
        self.asset?.resourceLoader.setDelegate(self, queue: .main)
    }
    
    private func setupDType() {
        if self.realUrl.hasSuffix(".m3u8") {
            self.dType = .m3u8
            self.replace_url = dType.rawValue
        }
    }
}

//MARK: - AVAssetResourceLoaderDelegate
extension XJJVideoAsset: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        XJJVideo_print("asset resource loader: ", resourceLoader, "loading requst: ", loadingRequest)
        
        switch dType {
        case .m3u8:
            return self.m3u8Request(loadingRequest: loadingRequest)
        default:
            break
        }
        
        return false
    }
            
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
//        XJJVideo_print("asset resource loader: ", resourceLoader, "renewal request: ", renewalRequest)
//        return true
//    }
//
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForResponseTo authenticationChallenge: URLAuthenticationChallenge) -> Bool {
//        XJJVideo_print("asset resource loader: ", resourceLoader, "authentication challenge: ", authenticationChallenge)
//        return true
//    }
//
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel authenticationChallenge: URLAuthenticationChallenge) {
//        XJJVideo_print("asset resource loader: ", resourceLoader, "- didCancel - authentication challenge: ", authenticationChallenge)
//    }
//
//    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
//        // 取消 asset 请求处理
//        XJJVideo_print("asset resource loader: ", resourceLoader, "- didCancel - loading request: ", loadingRequest)
//    }
}

//MARK: - m3u8 request
extension XJJVideoAsset {
    
    private func m3u8Request(loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let url_str = loadingRequest.request.url?.absoluteString else {return false}
        
        // 开始，找到被替换的 url，并拦截
        if  url_str == replace_url {
            guard let fileName = realUrl.components(separatedBy: "/").last else {XJJVideo_print("未知类型"); loadingRequest.finishLoading(with: XJJVideoAssetError.m3u8FileWrong("m3u8 文件类型错误！")); return false}
            XJJHTTP.download(realUrl, fileName) { (isSuccess, filePath, data) in
                var m3u8Data = Data()
                if let _data = data {
                    m3u8Data = _data
                }else if let path = filePath, let _data = XJJFile.getData(filePath: path) {
                    m3u8Data = _data
                }else {
                    XJJVideo_print("- m3u8 - m3u8 文件获取失败！")
                    loadingRequest.finishLoading(with: XJJVideoAssetError.m3u8FileWrong("m3u8 文件获取失败！"))
                    return
                }
                
                loadingRequest.dataRequest?.respond(with: m3u8Data)
                loadingRequest.finishLoading()
            }
            
            return true
        }
                
        // 获取 ts 片段
        if url_str.hasSuffix(".ts") {
            DispatchQueue.main.async {
                let http_urlStr = url_str.replacingOccurrences(of: "rdtp", with: "http")
                
                guard let url = URL(string: http_urlStr) else {XJJVideo_print("ts 片段 url 获取失败！"); loadingRequest.finishLoading(with: XJJVideoAssetError.m3u8FileWrong("ts 片段 url 获取失败！")); return}
            
                loadingRequest.redirect = URLRequest(url: url)
                loadingRequest.response = HTTPURLResponse(url: url, statusCode: 302, httpVersion: nil, headerFields: nil)
                
                do {
                    let _data = try Data(contentsOf: url)
                    loadingRequest.dataRequest?.respond(with: _data)
                    loadingRequest.finishLoading()
                }catch {
                    loadingRequest.finishLoading(with: error)
                }
                
                
            }
            
            return true
        }
        
        // 获取 key
        if !url_str.hasSuffix(".ts") && url_str != replace_url {
            DispatchQueue.main.async {
                let http_urlStr = url_str.replacingOccurrences(of: "ckey", with: "http")
                
                guard let url = URL(string: http_urlStr) else {XJJVideo_print("ckey url 获取失败！"); loadingRequest.finishLoading(with: XJJVideoAssetError.m3u8FileWrong("ckey url 获取失败！")); return}
                
                do {
                    let _data = try Data(contentsOf: url)
                    loadingRequest.dataRequest?.respond(with: _data)
                    loadingRequest.finishLoading()
                }catch {
                    loadingRequest.finishLoading(with: error)
                }
            }
            
            return true
        }
                
        return false
    }
}

extension String {
    
    // 替换 scheme
    /*
     - scheme：替换字符串
     - 返回：被替换的字符串
     */
    mutating func replace(scheme: String) -> String {
        let strArr = self.components(separatedBy: "://")
        self = scheme + "://" + (strArr.last ?? "")
        return strArr.first ?? ""
    }
}
