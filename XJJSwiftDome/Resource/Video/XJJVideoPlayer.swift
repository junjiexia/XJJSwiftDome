//
//  XJJVideoPlayer.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/2.
//

import UIKit
import AVKit

class XJJVideoPlayer: UIView {
    
    var urlList: [String]? {
        didSet {
            guard let list = urlList else {return}
            self.updatePlayerItem(list)
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
        self.setSubviewsLayout()
    }
    
    private var player: AVPlayer!
    private var items: [XJJVideoPlayerItem] = []
    private var playerLayer: AVPlayerLayer!
    
    private func initUI() {
        self.backgroundColor = UIColor.black
    
        self.initPlayer()
    }
    
    private func initPlayer() {
        self.player = AVPlayer()
        
        self.playerLayer = AVPlayerLayer(player: player)
        self.layer.addSublayer(playerLayer)
    }
    
    private func updatePlayerItem(_ list: [String]) {
        guard list.count > 0 else {return}
        
        for urlStr in list {
            let playerItem = XJJVideoPlayerItem(urlString: urlStr, options: nil, assetKeys: nil)
            self.items.append(playerItem)
        }
        
        self.play(0)
    }
    
    private func play(_ index: Int) {
        guard index < self.items.count else {return}
        
        if let item = items[index].item {
            self.player = AVPlayer(playerItem: item)
            self.player.automaticallyWaitsToMinimizeStalling = false // 保证 AVAssetResourceLoader 正常使用
            
            self.player.play()
        }
    }
    
    private func setSubviewsLayout() {
        self.playerLayer.frame = self.bounds
    }
    
}
