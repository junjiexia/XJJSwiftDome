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
    
    var isViewAppeared: Bool? {
        didSet {
            guard let isAppear = isViewAppeared else {return}
            self.player.isViewAppeared = isAppear
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initData()
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupSubviewsLayout()
    }
    
    private var player: XJJVideoPlayer!
        
    private func initData() {
        
    }
    
    private func initUI() {
        self.initPlayer()
    }
    
    private func initPlayer() {
        self.player = XJJVideoPlayer()
        self.addSubview(player)
        
        self.player.videoSource = XJJVideo().list?.http_source(forKey: "TEST1")
    }
    
    private let playerHeight: CGFloat = 300
    
    private func setupSubviewsLayout() {
        self.player.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 300)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
