//
//  XJJVideoPlayerMenuBottomView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/14.
//

import UIKit

class XJJVideoPlayerMenuBottomView: UIView {
    
    var playBlock: ((_ isPlay: Bool) -> Void)?
    var fullScreenBlock: ((_ isFullScreen: Bool) -> Void)?

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
    
    private var playView: UIImageView!
    private var progressBar: XJJVideoProgressBar!
    private var fullScreenBtn: UIButton!
    
    private var imageSize: CGSize = CGSize(width: 30, height: 30)
        
    private func initUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        self.initPlay()
        self.initProgress()
        self.initFullScreen()
    }
    
    private func initPlay() {
        self.playView = UIImageView()
        self.addSubview(playView)
        
        self.playView.setupPlayAndPause(size: imageSize)
        UIImageView.playAndPauseBlock = {[weak self] imageView, isPlay in
            guard let sself = self else {return}
            if imageView == sself.playView {
                sself.playBlock?(isPlay)
            }
        }
    }

    private func initProgress() {
        self.progressBar = XJJVideoProgressBar()
        self.addSubview(progressBar)
    }
    
    private func initFullScreen() {
        self.fullScreenBtn = UIButton(type: .custom)
        self.addSubview(fullScreenBtn)
        
        self.fullScreenBtn.setImage(XJJImages.fullScreen, for: .normal)
        self.fullScreenBtn.setImage(XJJImages.cancelFullScreen, for: .selected)
        self.fullScreenBtn.addTarget(self, action: #selector(fullScreenAction), for: .touchUpInside)
    }
    
    @objc private func fullScreenAction(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        self.fullScreenBlock?(btn.isSelected)
    }
    
    private let borderH: CGFloat = 16
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([playView, progressBar, fullScreenBtn])
        
        self.playView.autoLayoutCenterY(0, .equal)
        self.playView.autoLayoutLeft(borderH, .equal)
        self.playView.autoLayoutWidth(imageSize.width, .equal)
        self.playView.autoLayoutHeight(imageSize.height, .equal)
        
        self.progressBar.autoLayoutCenterY(0, .equal)
        self.progressBar.autoLayoutLeftRelative(10, .equal, playView)
        self.progressBar.autoLayoutHeight(self.bounds.height, .equal)
        
        self.fullScreenBtn.autoLayoutCenterY(0, .equal)
        self.fullScreenBtn.autoLayoutLeftRelative(10, .equal, progressBar)
        self.fullScreenBtn.autoLayoutRight(-borderH, .equal)
        self.fullScreenBtn.autoLayoutWidth(imageSize.width, .equal)
        self.fullScreenBtn.autoLayoutHeight(imageSize.height, .equal)
    }
    
}
