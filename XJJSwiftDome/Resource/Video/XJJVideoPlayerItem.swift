//
//  XJJVideoPlayerItem.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/12.
//

import Foundation
import AVKit

class XJJVideoPlayerItem: NSObject {
    var loadedTimeBlock: ((_ loadedTimeRanges: [NSValue]) -> Void)?
    var statusBlock: ((_ status: AVPlayerItem.Status) -> Void)?
    
    var item: AVPlayerItem?
    var xAsset: XJJVideoAsset!
    
    init(urlString: String, options: [String : Any]? = nil, assetKeys: [String]? = nil) {
        super.init()
        self.xAsset = XJJVideoAsset(urlString: urlString, options: options)
        
        if let asset = xAsset.asset {
            self.item = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
            if #available(iOS 9.0, *) {
                self.item?.canUseNetworkResourcesForLiveStreamingWhilePaused = true
            }
            
            self.item?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
            self.item?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: nil)
        }
    }
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
            // 缓冲进度
            
        }else if keyPath == #keyPath(AVPlayerItem.status) {
            // 播放状态
            
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        self.item?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        self.item?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
    }
}
