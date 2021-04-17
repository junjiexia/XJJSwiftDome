//
//  XJJVideoPlayer.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/2.
//

import UIKit
import AVKit

class XJJVideoPlayer: UIView {
    
    var urlString: String? {
        didSet {
            guard let urlStr = urlString else {return}
            self.updatePlayerItem(urlStr)
        }
    }
    
    var liveUrlString: String? {
        didSet {
            guard let urlStr = liveUrlString else {return}
            self.updatePlayerItem(urlStr, playType: .live)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupSubviewsLayout()
    }
    
    private var player: AVPlayer!
    private var playerItem: XJJVideoPlayerItem! // 播放项
    private var playerLayer: AVPlayerLayer!
    
    private var autoPlay: Bool = true // 是否缓冲到最小时长时，自动播放
    private var isPlaying: Bool = false // 是否正在播放
    private var minPlayTime: CMTime = CMTime(value: CMTimeValue(5.0), timescale: 1) // 最小缓冲时长
    
    private func initUI() {
        self.backgroundColor = UIColor.black
    
        self.initPlayer()
    }
    
    private func initPlayer() {
        self.player = AVPlayer()
        
        self.playerLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(playerLayer)
    }
    
    private func updatePlayerItem(_ urlStr: String, playType: XJJVideoAsset.PlayType? = .rb_none) {
        self.playerItem = XJJVideoPlayerItem(urlString: urlStr, options: nil, assetKeys: nil, playType: playType)
        
        self.playerItem.assetPrepareBlock = {[weak self] in
            guard let sself = self else {return}
            sself.assetPrepare()
        }
    }
    
    private func assetPrepare() {
        self.playPrepare()
    }
    
    private func playPrepare() {
        if let item = playerItem.item {
            self.player = AVPlayer(playerItem: item)
            //self.player.automaticallyWaitsToMinimizeStalling = false // 保证 AVAssetResourceLoader 正常使用
            self.playerLayer.player = player
            
            playerItem.loadedTimeBlock = {[weak self] values in
                guard let sself = self else {return}
                sself.loadedTime(values: values)
            }
            
            playerItem.statusBlock = {[weak self] status in
                guard let sself = self else {return}
                sself.status(status: status)
            }
        }
    }
    
    private func loadedTime(values: [NSValue]) {
        guard autoPlay else {return}
        guard !isPlaying else {return}
        
        let rangeArr = values.map { $0 as? CMTimeRange }
        let pointArr = rangeArr.map { CMTimeAdd($0?.start ?? CMTime(value: 0, timescale: 0), $0?.duration ?? CMTime(value: 0, timescale: 0))}
        
        let cTime = CMTimeAdd(player.currentTime(), minPlayTime)
        
        if let startTime = pointArr.max(), CMTimeCompare(startTime, cTime) >= 0 {
            self.play()
        }
    }
    
    private func status(status: AVPlayerItem.Status) {
        switch status {
        case .readyToPlay:
            break
        default:
            self.isPlaying = false
            XJJVideo_print("视频（音频）还没有准备好！", self.playerItem.urlStr)
        }
    }
    
    private func play() {
        self.player.play()
        self.isPlaying = true
    }
    
    private func pause() {
        self.player.pause()
        self.isPlaying = false
        self.autoPlay = false
    }
    
    private func setupSubviewsLayout() {
        self.playerLayer.frame = self.bounds
    }
    
}
