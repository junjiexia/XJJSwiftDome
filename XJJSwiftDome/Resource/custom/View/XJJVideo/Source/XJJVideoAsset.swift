//
//  XJJVideoAsset.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/2.
//

import Foundation
import AVKit

class XJJVideoAsset: NSObject {
    
    var assetPrepareBlock: (() -> Void)?
    
    var asset: AVURLAsset?
    
    private var replace_url = DType.m3u8.rawValue // 拦截 asset 协议用的url
    private var realUrl: String = "" // 真实url
    private var asset_options: [String: Any] = [:] // asset 条件
    private var dType: DType = .none
    private var playType: PlayType = .rb_none
    
    private let qResourceLoader = "ASSET_RESOURCE_LOADER"
    private let kPlayable = "playable"
    private let kDuration = "duration"
    private let kTracks = "tracks"
    
    private let redirectScheme = "rdtp"
    private let httpScheme = "http"
    private let customPlaylistScheme = "cplp"
    private let customKeyScheme = "ckey"
    
    // 单码率模拟类型
//    private let customPlayListFormatPrefix = "#EXTM3U\n#EXT-X-PLAYLIST-TYPE:EVENT\n#EXT-X-TARGETDURATION:10\n#EXT-X-VERSION:3\n#EXT-X-MEDIA-SEQUENCE:0\n"
//    private let customPlayListFormatElementInfo = "#EXTINF:10, no desc\n"
//    private let customPlaylistFormatElementSegment = "%@/fileSequence%d.ts\n"
//    private let customEncryptionKeyInfo = "#EXT-X-KEY:METHOD=AES-128,URI=\"%@/crypt0.key\", IV=0x3ff5be47e1cdbaec0a81051bcc894d63\n"
//    private let customPlayListFormatEnd = "#EXT-X-ENDLIST"
    
    private let redirectErrorCode = 302
    private let badRequestErrorCode = 400
    
    enum DType: String {
        case none = ""
        case m3u8 = "m3u8_scheme://abcd.m3u8"
    }
    
    enum PlayType {
        case live                       // 直播
        case rb_none                    // 录播，直接播放
        case rb_decode                  // 录播
        
        init(vType: XJJVideoSubItem.VType) {
            switch vType {
            case .recorded:
                self = .rb_none
            case .live:
                self = .live
            }
        }
    }
    
    enum AssetError: Error {
        case unowned
        case m3u8(Value)
        
        struct Value {
            var code = 0
            var description = ""
        }
    }
    
    override init() { super.init() }
    
    init(videoSource: XJJVideoSubItem, options: [String : Any]? = nil) {
        super.init()
        guard let urlString = videoSource.urlString else {XJJVideo_print("asset url 为空！"); return}
        // 替换 scheme 用于拦截 asset 协议
        self.realUrl = urlString
        self.playType = PlayType(vType: videoSource.videoType())
        self.setupDType()
        
        if let _options = options {
            self.asset_options = _options
        }
        //self.asset_options[AVURLAssetAllowsCellularAccessKey] = false // 防止其在通过网络连接时检索其媒体
        
        // 创建 asset 资源
        guard let url = URL(string: playType == .rb_none ? realUrl : replace_url) else { XJJVideo_print("asset 拦截 url 转换失败！-_-"); return}
        self.asset = AVURLAsset(url: url, options: asset_options)
        self.asset?.resourceLoader.setDelegate(self, queue: DispatchQueue(label: qResourceLoader))
        
        XJJVideo_print("asset url: ", url, "resource loader: ", self.asset?.resourceLoader ?? "没有找到资源下载器")
    
        self.loadPlayableKey()
    }
    
    private func loadPlayableKey() {
        let keys = [kPlayable, kDuration, kTracks]
        self.asset?.loadValuesAsynchronously(forKeys: keys, completionHandler: {[weak self] in
            DispatchQueue.main.async {
                guard let sself = self else {return}
                sself.prepareToPlayAsset(keys)
            }
        })
    }
    
    private func prepareToPlayAsset(_ requestKeys: [String]) {
        XJJVideo_print("asset prepare request keys: ", requestKeys)
        for key in requestKeys {
            var error: NSError? = nil
            let status = self.asset?.statusOfValue(forKey: key, error: &error)
            
            switch status {
            case .failed:
                XJJVideo_print("asset prepare", key, " - error: ", error ?? "unowned")
                return
            case .loaded:
                if key == kPlayable {
                    XJJVideo_print("asset prepare success, playable: loaded！")
                }else if key == kDuration {
                    XJJVideo_print("asset prepare success, total time: ", asset?.duration ?? "0")
                }else if key == kTracks {
                    XJJVideo_print("asset prepare success, tracks: ", asset?.tracks ?? "")
                }
            default:
                XJJVideo_print("asset prepare", key, " - success, playable: ", status?.rawValue ?? "unowned")
                return
            }
        }
        
        if self.asset?.isPlayable == false {
            XJJVideo_print("asset prepare error: Item cannot be played")
            return
        }
        
        self.assetPrepareBlock?()
    }
    
    private func setupDType() {
        if self.realUrl.hasSuffix(".m3u8") {
            self.dType = .m3u8
            self.replace_url = dType.rawValue
        }
    }
}

//MARK: - AVAssetResourceLoaderDelegate
/*
    * shouldWaitForLoadingOfRequestedResource
        * 这个协议方法只能用来拦截非标准请求（非 http，https等），标准请求不走该方法
        * 返回：告诉系统是否被阻断
            * true - 阻断，系统会等待，需要手动给 loadingRequest 返回
            * false - 不阻断，直接播放
 */
extension XJJVideoAsset: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        //XJJVideo_print("current thread: ", Thread.current, "- AVAssetResourceLoaderDelegate -")
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
/*
    * redirect: 重定向 URL，主要重新设置 scheme（swift 无法直接设置 request（只读） 的 scheme 只能通过这个属性进行重设）
        * 重定向只支持 http 协议
 */
extension XJJVideoAsset {
    
    private func m3u8Request(loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let url = loadingRequest.request.url else {return false}
        let scheme = url.scheme
        let url_str = url.absoluteString
        
        switch playType {
        case .live:
            // 开始，找到被替换的 url，并拦截
            if  url_str == replace_url {
                return self.downloadM3U8(loadingRequest: loadingRequest)
            }
                    
            // 获取 ts 片段
            if scheme == redirectScheme {
                return self.downloadPlayList(loadingRequest: loadingRequest)
            }
            
            // 获取 key
            if scheme == customKeyScheme {
                return self.downloadCKey(loadingRequest: loadingRequest)
            }
        case .rb_decode:
            // 开始，找到被替换的 url，拦截
            if  url_str == replace_url {
                return self.downloadM3U8(loadingRequest: loadingRequest)
            }
        case .rb_none:
            break
        }
        
        return false
    }
    
    private func downloadM3U8(loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        let _realUrl = self.realUrl
        let _badRequestErrorCode = self.badRequestErrorCode
        
        DispatchQueue.main.async {
            if let real_url = URL(string: _realUrl) {
                
                do {
                    let _data = try Data(contentsOf: real_url)
                    XJJVideo_print("- m3u8 - m3u8 文件获取: ", _data.JSONToStr(), "data count: ", _data.count)
                    loadingRequest.dataRequest?.respond(with: _data)
                    loadingRequest.finishLoading()
                }catch {
                    loadingRequest.finishLoading(with: AssetError.m3u8(AssetError.Value(code: _badRequestErrorCode, description: "m3u8 文件获取失败！")))
                }
            }else {
                loadingRequest.finishLoading(with: AssetError.m3u8(AssetError.Value(code: -1, description: "m3u8 文件类型错误！")))
                return
            }
        }
        
        return true
    }
    
    private func downloadPlayList(loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let url = loadingRequest.request.url else {return false}
        let url_str = url.absoluteString
        let redirect_scheme = self.redirectScheme
        let http_scheme = self.httpScheme
        let _redirectErrorCode = self.redirectErrorCode
        
        DispatchQueue.main.async {
            let http_urlStr = url_str.replacingOccurrences(of: redirect_scheme, with: http_scheme)
            XJJVideo_print("- m3u8 - ts 片段 URL string: ", http_urlStr)
            
            if let url = URL(string: http_urlStr) {
                
                loadingRequest.redirect = URLRequest(url: url)
                loadingRequest.response = HTTPURLResponse(url: url, statusCode: _redirectErrorCode, httpVersion: nil, headerFields: nil)
                
                do {
                    let _data = try Data(contentsOf: url)
                    XJJVideo_print("- m3u8 - ts 片段获取: ", _data.JSONToStr(), "data count: ", _data.count)
                    loadingRequest.dataRequest?.respond(with: _data)
                    loadingRequest.finishLoading()
                }catch {
                    loadingRequest.finishLoading(with: AssetError.m3u8(AssetError.Value(code: -2, description: "ts 片段片段获取数据失败！")))
                }
            }else {
                
                XJJVideo_print("- m3u8 - ts 片段 url 获取失败！")
                loadingRequest.finishLoading(with: AssetError.m3u8(AssetError.Value(code: -3, description: "ts 片段 url 获取失败！")))
                return
            }
        }
        
        return true
    }
    
    private func downloadCKey(loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard let url = loadingRequest.request.url else {return false}
        let url_str = url.absoluteString
        let http_scheme = self.httpScheme
        let ckey_scheme = self.customKeyScheme
        let _badRequestErrorCode = self.badRequestErrorCode
        
        DispatchQueue.main.async {
            let http_urlStr = url_str.replacingOccurrences(of: ckey_scheme, with: http_scheme)
            XJJVideo_print("- m3u8 - ckey URL string: ", http_urlStr)
            
            if let url = URL(string: http_urlStr) {
                do {
                    let _data = try Data(contentsOf: url)
                    XJJVideo_print("- m3u8 - ckey 获取: ", _data.JSONToStr(), "data count: ", _data.count)
                    loadingRequest.dataRequest?.respond(with: _data)
                    loadingRequest.finishLoading()
                }catch {
                    loadingRequest.finishLoading(with: AssetError.m3u8(AssetError.Value(code: _badRequestErrorCode, description: "ckey 数据获取失败！")))
                }
            } else {
                XJJVideo_print("- m3u8 - ckey url 获取失败！")
                loadingRequest.finishLoading(with: AssetError.m3u8(AssetError.Value(code: -4, description: "ckey url 获取失败！")))
                return
            }
        }
        
        return true
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
