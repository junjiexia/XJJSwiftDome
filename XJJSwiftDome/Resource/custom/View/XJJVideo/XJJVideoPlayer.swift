//
//  XJJVideoPlayer.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/2.
//

import UIKit
import AVKit

class XJJVideoPlayer: UIView {
    
    var showBorderBlock: ((_ isShow: Bool) -> Void)? // 边框显示
    
    var videoSource: XJJVideoSubItem? {
        didSet {
            guard let source = videoSource else {return}
            self.updatePlayerItem(source)
        }
    }
    
    var isViewAppeared: Bool = false // 是否显示在最前
    
    var timeText: String? {
        didSet {
            guard let text = timeText else {return}
            self.playerMenu.timeText = text
        }
    }
    
    var batteryValue: UIImage.Battery? {
        didSet {
            guard let value = batteryValue else {return}
            self.playerMenu.batteryValue = value
        }
    }
    
    var showStatus: Bool? {
        didSet {
            guard let isShow = showStatus else {return}
            self.playerMenu.showStatus = isShow
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        self.close()
        super.removeFromSuperview()
    }
    
    private func close() {
        if self.player != nil {
            self.player.pause()
            self.player = nil
        }
        if self.playerItem != nil {
            self.playerItem = nil
        }
        if self.playerLayer != nil {
            self.playerLayer.removeFromSuperlayer()
            self.playerLayer = nil
        }
        if self.playerMenu != nil {
            self.playerMenu.removeFromSuperview()
            self.playerMenu = nil
        }
    }
    
    deinit {
        XJJVideo_print("XJJVideoPlayer deinit !!")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupSubviewsLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superTable()?.isScrollEnabled = false
        self.superScroll()?.isScrollEnabled = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superTable()?.isScrollEnabled = true
        self.superScroll()?.isScrollEnabled = true
    }
    
    private var player: AVPlayer!
    private var playerItem: XJJVideoPlayerItem! // 播放项
    private var playerLayer: AVPlayerLayer!
    private var playerMenu: XJJVideoPlayerMenu!
    private weak var landscapeVC: XJJVideoLandscapeViewController? // 横屏控制器
    
    private var autoPlay: Bool = true // 是否缓冲到最小时长时，自动播放
    private var isPlaying: Bool = false // 是否正在播放
    private var isReaded: Bool = false // 是否准备好播放
    private var minPlayTime: CMTime = CMTime(value: CMTimeValue(5.0), timescale: 1) // 最小缓冲时长
    private var org_frame: CGRect = CGRect.zero // 竖屏原始frame
    private var org_superView: UIView? // 竖屏原始视图
    private var isInAnimation: Bool = false // 是否在动画
    private var isFullScreen: Bool = false // 是否全屏
    
    private func initUI() {
        self.backgroundColor = UIColor.black
    
        self.initPlayer()
        self.initPlayerMenu()
    }
    
    private func initPlayer() {
        self.player = AVPlayer()
        
        self.playerLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(playerLayer)
    }
    
    private func initPlayerMenu() {
        self.playerMenu = XJJVideoPlayerMenu()
        self.addSubview(playerMenu)
        
        self.playerMenu.backBlock = {[weak self] in
            guard let sself = self else {return}
            if sself.isFullScreen {
                sself.changeToPortrait()
            }
        }
        
        self.playerMenu.settingBlock = {[weak self] in
            guard let sself = self else {return}
            sself.showSettingView()
        }
        
        self.playerMenu.showListBlock = {[weak self] in
            guard let sself = self else {return}
            sself.showListView()
        }
        
        self.playerMenu.lockBlock = {[weak self] isLock in
            guard let sself = self else {return}
            sself.lockView(isLock)
        }
        
        self.playerMenu.fullScreenBlock = {[weak self] fullScreen in
            guard let sself = self else {return}
            sself.fullScreen(fullScreen)
        }
        
        self.playerMenu.showBorderBlock = {[weak self] isShow in
            guard let sself = self else {return}
            sself.showBorderBlock?(isShow)
        }
    }
    
    private func updatePlayerItem(_ videoSource: XJJVideoSubItem) {
        self.playerItem = XJJVideoPlayerItem(videoSource: videoSource, options: nil, assetKeys: nil)
        
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
            self.autoPlay = false
            
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
        guard !isPlaying else {return}
        
        let rangeArr = values.map { $0 as? CMTimeRange }
        let pointArr = rangeArr.map { CMTimeAdd($0?.start ?? CMTime(value: 0, timescale: 0), $0?.duration ?? CMTime(value: 0, timescale: 0))}
        
        let cTime = CMTimeAdd(player.currentTime(), minPlayTime)
        
        if let startTime = pointArr.max(), CMTimeCompare(startTime, cTime) >= 0 {
            self.isReaded = true
            if autoPlay {
                self.play()
            }
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
        guard isViewAppeared else {return}
        if isReaded {
            self.player.play()
            self.isPlaying = true
            self.autoPlay = true
        }
    }
    
    private func pause() {
        guard isViewAppeared else {return}
        self.player.pause()
        self.isPlaying = false
    }
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([playerMenu])
        
        self.playerMenu.autoLayoutTop(0, .equal)
        self.playerMenu.autoLayoutLeft(0, .equal)
        self.playerMenu.autoLayoutRight(0, .equal)
        self.playerMenu.autoLayoutBottom(0, .equal)
        
        self.playerLayer.frame = self.bounds
    }
}

//MARK: - 横屏/竖屏
extension XJJVideoPlayer {
    private func fullScreen(_ isFullScreen: Bool) {
        if isFullScreen {
            self.changeToLandscape()
        }else {
            self.changeToPortrait()
        }
    }
    
    // 横屏
    private func changeToLandscape() {
        self.isInAnimation = true
        self.org_frame = self.frame
        self.org_superView = self.superview
        self.showLandscape()
        self.isFullScreen = true
    }
    
    private func showLandscape() {
        let _landscape = XJJVideoLandscapeViewController()
        self.viewController()?.navigationController?.pushViewController(_landscape, animated: false)
        
        let rectInWindow = self.convert(self.frame, to: XJJTools.keywindow)
        self.removeFromSuperview()
        self.frame = rectInWindow
        _landscape.playerView = self
        _landscape.view.addSubview(self)
                
        self.isInAnimation = false
        self.landscapeVC = _landscape
    }

    // 竖屏
    private func changeToPortrait() {
        self.isInAnimation = true
        self.dissmissLandscape()
        self.isFullScreen = false
    }
    
    private func dissmissLandscape() {
        self.removeFromSuperview()
        self.landscapeVC?.navigationController?.popViewController(animated: false)
        self.frame = self.org_frame
        self.org_superView?.addSubview(self)
        
        self.isInAnimation = false
    }
}

//MARK: - 设置、列表、锁
extension XJJVideoPlayer {
    // 设置
    private func showSettingView() {
        self.playerMenu.hiddenBorder()
    }
    // 列表
    private func showListView() {
        self.playerMenu.hiddenBorder()
    }
    // 锁
    private func lockView(_ isLock: Bool) {
        self.playerMenu.hiddenBorder()
    }
}
