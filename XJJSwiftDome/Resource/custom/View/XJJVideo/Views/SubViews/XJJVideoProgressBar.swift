//
//  XJJVideoProgressBar.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/19.
//

import UIKit

class XJJVideoProgressBar: UIView {
    
    var progress: CGFloat? {
        didSet {
            guard let _progress = progress else {return}
            self.progressValue = _progress
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
    
    private var progressView: XJJVideoProgressView!
    private var pointView: UIImageView!
    
    private var progressValue: CGFloat = 0
                
    private func initUI() {
        self.initProgress()
        self.initPoint()
    }
    
    private func initProgress() {
        self.progressView = XJJVideoProgressView()
        self.addSubview(progressView)
    }

    private func initPoint() {
        self.pointView = UIImageView()
        self.addSubview(pointView)
        
        self.pointView.image = XJJImages.progressBarButton
    }
    
    private let imageSize: CGSize = CGSize(width: 30, height: 30)
    private let borderH: CGFloat = 10
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([progressView, pointView])
        
        let x: CGFloat = imageSize.width / 2 + borderH
        let length: CGFloat = self.bounds.width - borderH * 2
        
        self.progressView.autoLayoutCenterY(0, .equal)
        self.progressView.autoLayoutLeft(x, .equal)
        self.progressView.autoLayoutRight(-x, .equal)
        self.progressView.autoLayoutHeight(self.bounds.height / 5, .equal)
        
        self.pointView.autoLayoutCenterY(0, .equal)
        self.pointView.autoLayoutLeft(borderH + length * progressValue, .equal)
        self.pointView.autoLayoutWidth(imageSize.width, .equal)
        self.pointView.autoLayoutHeight(imageSize.height, .equal)
    }
}

class XJJVideoProgressView: UIView {
    
    var progress: CGFloat? {
        didSet {
            guard let _progress = progress else {return}
            self.progressValue = _progress
            //self.setNeedsLayout()
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
    
    private var progressLayer: CALayer!
    
    private var progressValue: CGFloat = 0
            
    private func initUI() {
        self.backgroundColor = UIColor.lightGray
        
        self.initProgress()
    }
    
    private func initProgress() {
        self.progressLayer = CALayer()
        self.layer.addSublayer(progressLayer)
        
        self.progressLayer.frame = CGRect.zero
        self.progressLayer.backgroundColor = UIColor.blue.cgColor
        
    }
    
    private func setupSubviewsLayout() {
        self.progressLayer.frame = CGRect(x: self.bounds.width * progressValue, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
}
