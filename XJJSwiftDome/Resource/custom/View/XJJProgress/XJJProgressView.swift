//
//  XJJProgressView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/12.
//

import UIKit

class XJJProgressView: UIView {
    
    var progressValue: Float? { // 0 ~ 1.0   <0未开始
        didSet {
            guard let value = progressValue else {return}
            if value < 0 {
                self.progressView.progress = 0
                self.stateLabel.text = "0%"
            }else if value >= 1.0 {
                self.progressView.progress = 1.0
                self.stateLabel.text = "100%"
            }else {
                self.progressView.progress = value
                self.stateLabel.text = String(format: "%.0f%%", value * 100)
            }
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
    
    private var progressView: UIProgressView!
    private var stateLabel: UILabel!
    
    private func initUI() {
        self.initProgress()
        self.initState()
    }
    
    private func initProgress() {
        self.progressView = UIProgressView(progressViewStyle: .default)
        self.addSubview(progressView)
        
        self.progressView.progressTintColor = UIColor.blue
        self.progressView.trackTintColor = UIColor.lightGray
    }
    
    private func initState() {
        self.stateLabel = UILabel()
        self.addSubview(stateLabel)
        
        self.stateLabel.text = ""
        self.stateLabel.textColor = UIColor.darkText
        self.stateLabel.textAlignment = .left
        self.stateLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([progressView, stateLabel])
        
        self.progressView.autoLayoutCenterY(0, .equal)
        self.progressView.autoLayoutLeft(16, .equal)
        self.progressView.autoLayoutHeight(3, .equal)
        
        self.stateLabel.autoLayoutCenterY(0, .equal)
        self.stateLabel.autoLayoutRight(-16, .equal)
        self.stateLabel.autoLayoutLeftRelative(5, .equal, progressView)
        self.stateLabel.autoLayoutWidth(50, .equal)
        self.stateLabel.autoLayoutHeight(self.bounds.height, .equal)
    }
    
}
