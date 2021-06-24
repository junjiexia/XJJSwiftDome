//
//  XJJVideoPlayerMenuTopView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/14.
//

import UIKit

class XJJVideoPlayerMenuTopView: UIView {
    
    var backBlock: (() -> Void)?
    var settingBlock: (() -> Void)?
    
    var timeText: String? {
        didSet {
            guard let text = timeText else {return}
            self.statusView.timeText = text
        }
    }
    
    var batteryValue: UIImage.Battery? {
        didSet {
            guard let value = batteryValue else {return}
            self.statusView.setBattery(value: value)
        }
    }
    
    var showStatus: Bool? {
        didSet {
            guard let isShow = showStatus else {return}
            self.isShowStatus = isShow
            self.setNeedsLayout()
        }
    }
    
    var titleText: XJJText? {
        didSet {
            guard let text = titleText else {return}
            self.titleView.titleText = text
        }
    }
    
    var hiddenBack: Bool? {
        didSet {
            guard let hidden = hiddenBack else {return}
            self.titleView.hiddenBack = hidden
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
    
    private var statusView: XJJVideoPlayerStatusView! // 状态栏
    private var titleView: XJJVideoPlayerTopView! // 标题栏
    
    private var isShowStatus: Bool = false // 是否显示状态栏
        
    private func initUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        self.initStatus()
        self.initTitle()
    }
    
    private func initStatus() {
        self.statusView = XJJVideoPlayerStatusView()
        self.addSubview(statusView)
    }
    
    private func initTitle() {
        self.titleView = XJJVideoPlayerTopView()
        self.addSubview(titleView)
        
        self.titleView.backBlock = {[weak self] in
            guard let sself = self else {return}
            sself.backBlock?()
        }
        
        self.titleView.settingBlock = {[weak self] in
            guard let sself = self else {return}
            sself.settingBlock?()
        }
    }
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([statusView, titleView])
        
        if isShowStatus {
            self.statusView.autoLayoutTop(0, .equal)
            self.statusView.autoLayoutLeft(0, .equal)
            self.statusView.autoLayoutRight(0, .equal)
            self.statusView.autoLayoutHeight(20, .equal)
            
            self.titleView.autoLayoutTopRelative(0, .equal, statusView)
        }else {
            self.titleView.autoLayoutTop(0, .equal)
        }
        
        self.titleView.autoLayoutLeft(0, .equal)
        self.titleView.autoLayoutRight(0, .equal)
        self.titleView.autoLayoutHeight(30, .equal)
    }
}

fileprivate class XJJVideoPlayerStatusView: UIView {
    
    var timeText: String? {
        didSet {
            guard let text = timeText else {return}
            self.timeLabel.text = text
        }
    }
    
    func setBattery(value: UIImage.Battery) {
        self.batteryLabel.text = String(format: "%.f%%", CGFloat(value.value) / 100)
        XJJImages.getImage(battery: value, size: batteryImageSize, isFull: true) { image in
            self.batteryImageView.image = image
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
    
    private var timeLabel: UILabel!
    private var batteryLabel: UILabel!
    private var batteryImageView: UIImageView!
    
    private func initUI() {
        self.initTime()
        self.initBattery()
    }
    
    private func initTime() {
        self.timeLabel = UILabel()
        self.addSubview(timeLabel)
        
        self.timeLabel.textColor = UIColor.white
        self.timeLabel.textAlignment = .center
        self.timeLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func initBattery() {
        self.batteryLabel = UILabel()
        self.addSubview(batteryLabel)
        
        self.batteryLabel.textColor = UIColor.white
        self.batteryLabel.textAlignment = .right
        self.batteryLabel.font = UIFont.systemFont(ofSize: 13)
        
        self.batteryImageView = UIImageView(image: XJJImages.batteryFull)
        self.addSubview(batteryImageView)
    }
    
    private let batteryImageSize: CGSize = CGSize(width: 25, height: 20)
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([timeLabel, batteryLabel, batteryImageView])
        
        self.timeLabel.autoLayoutCenter(0, 0, .equal)
        self.timeLabel.autoLayoutWidth(100, .equal)
        self.timeLabel.autoLayoutHeight(20, .equal)
        
        self.batteryImageView.autoLayoutCenterY(0, .equal)
        self.batteryImageView.autoLayoutRight(-16, .equal)
        self.batteryImageView.autoLayoutWidth(batteryImageSize.width, .equal)
        self.batteryImageView.autoLayoutHeight(batteryImageSize.height, .equal)
        
        self.batteryLabel.autoLayoutCenterY(0, .equal)
        self.batteryLabel.autoLayoutRightRelative(-5, .equal, batteryImageView)
        self.batteryLabel.autoLayoutWidth(100, .equal)
        self.batteryLabel.autoLayoutHeight(20, .equal)
    }
}

fileprivate class XJJVideoPlayerTopView: UIView {
    
    var backBlock: (() -> Void)?
    var settingBlock: (() -> Void)?
    
    var titleText: XJJText? {
        didSet {
            guard let text = titleText else {return}
            self.titleLabel.setText(text)
        }
    }
    
    var hiddenBack: Bool? {
        didSet {
            guard let hidden = hiddenBack else {return}
            self.backBtn.isHidden = hidden
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
    
    private var backBtn: UIButton! // 返回按钮
    private var titleLabel: UILabel! // 标题
    private var settingBtn: UIButton! // 设置按钮
        
    private func initUI() {
        self.backgroundColor = UIColor(white: 1, alpha: 0.4)
        
        self.initBack()
        self.initTitle()
        self.initSetting()
    }
    
    private func initBack() {
        self.backBtn = UIButton(type: .custom)
        self.addSubview(backBtn)
        
        self.backBtn.setImage(XJJImages.returnImage, for: .normal)
        self.backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    @objc private func backAction(_ btn: UIButton) {
        self.backBlock?()
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel)
        
        self.titleLabel.textColor = UIColor(white: 1, alpha: 0.9)
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.systemFont(ofSize: 13)
    }
    
    private func initSetting() {
        self.settingBtn = UIButton(type: .custom)
        self.addSubview(settingBtn)
        
        self.settingBtn.setImage(XJJImages.settingImage, for: .normal)
        self.settingBtn.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
    }
    
    @objc private func settingAction(_ btn: UIButton) {
        self.settingBlock?()
    }
    
    private let border_h: CGFloat = 16
    private let border_v: CGFloat = 5
    private var imageSize: CGSize = CGSize(width: 30, height: 30)
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([backBtn, titleLabel, settingBtn])
        
        self.backBtn.autoLayoutCenterY(0, .equal)
        self.backBtn.autoLayoutLeft(border_h, .equal)
        self.backBtn.autoLayoutWidth(imageSize.width, .equal)
        self.backBtn.autoLayoutHeight(imageSize.height, .equal)
        
        self.titleLabel.autoLayoutCenterY(0, .equal)
        self.titleLabel.autoLayoutLeftRelative(5, .equal, backBtn)
        self.titleLabel.autoLayoutHeight(self.bounds.height, .equal)
        
        self.settingBtn.autoLayoutCenterY(0, .equal)
        self.settingBtn.autoLayoutLeftRelative(5, .equal, titleLabel)
        self.settingBtn.autoLayoutRight(-border_h, .equal)
        self.settingBtn.autoLayoutWidth(imageSize.width, .equal)
        self.settingBtn.autoLayoutHeight(imageSize.height, .equal)
    }
}
