//
//  XJJVideoPlayerItem.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/12.
//

import Foundation
import AVKit

class XJJVideoPlayerItem: NSObject {
    var assetPrepareBlock: (() -> Void)?
    var loadedTimeBlock: ((_ loadedTimeRanges: [NSValue]) -> Void)?
    var statusBlock: ((_ status: AVPlayerItem.Status) -> Void)?
    
    var index: Int = 0 // 序列
    var item: AVPlayerItem?
    var xAsset: XJJVideoAsset! // 资源
    var urlStr: String = ""
    
    init(videoSource: XJJVideoSubItem, options: [String : Any]? = nil, assetKeys: [String]? = nil) {
        super.init()
        self.urlStr = videoSource.urlString ?? ""
        self.xAsset = XJJVideoAsset(videoSource: videoSource, options: options)
        
        self.xAsset.assetPrepareBlock = {[weak self] in
            guard let sself = self else {return}
            sself.assetPrepare(assetKeys: assetKeys)
        }
    }
    
    private func assetPrepare(assetKeys: [String]? = nil) {
        if self.item != nil {
            self.removeObservers()
        }
                
        if let asset = xAsset.asset {
            self.item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
//            if #available(iOS 9.0, *) {
//                self.item?.canUseNetworkResourcesForLiveStreamingWhilePaused = true
//            }
                        
            self.addObservers()
            self.assetPrepareBlock?()
        }else {
            XJJVideo_print("player item asset 获取失败！")
        }
    }
    
    //MARK: - Notification
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: self.item)
    }
    
    @objc func playerItemDidReachEnd(_ noti: Notification) {
        
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.item)
    }
    
    //MARK: - KVO
    private func addObservers() {
        self.item?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
        self.item?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: nil)
    }
    
    private func removeObservers() {
        self.item?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        self.item?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
            // 缓冲进度
            if let value = change?[.newKey] as? [NSValue] {
                self.loadedTimeBlock?(value)
                XJJVideo_print("player item 缓冲进度: ", value)
            }
        }else if keyPath == #keyPath(AVPlayerItem.status) {
            // 播放状态
            if let value = change?[.newKey] as? AVPlayerItem.Status {
                self.statusBlock?(value)
                XJJVideo_print("player item 播放状态: ", value)
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        self.removeObservers()
    }
}
