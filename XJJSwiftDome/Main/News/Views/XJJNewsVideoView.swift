//
//  XJJNewsVideoView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/1.
//

/*

 */

import UIKit
import AVKit

class XJJNewsVideoView: UIView {

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
    private var playerLayer: AVPlayerLayer!
    
    private func initUI() {
        self.initPlayer()
    }
    
    private func initPlayer() {
        if let url = XJJVideo().list?.url(forKey: "CCTV1") {
            self.player = AVPlayer(url: url)
            self.player.rate = 1.0 // 播放速度
            
            self.playerLayer = AVPlayerLayer(player: player)
            self.playerLayer.videoGravity = .resizeAspect
            self.layer.addSublayer(playerLayer)

            self.player.play()
        }
        
    }
    
    private func setupSubviewsLayout() {
        self.playerLayer.frame = self.bounds
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
