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
        self.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        self.initBack()
        self.initTitle()
        self.initSetting()
    }
    
    private func initBack() {
        self.backBtn = UIButton(type: .custom)
        self.addSubview(backBtn)
        
        self.backBtn.setImage(XJJThemeConfig.share.returnImage, for: .normal)
        self.backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    @objc func backAction(_ btn: UIButton) {
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
        
        self.settingBtn.setImage(XJJThemeConfig.share.settingImage, for: .normal)
        self.settingBtn.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
    }
    
    @objc func settingAction(_ btn: UIButton) {
        self.settingBlock?()
    }
    
    private let border_h: CGFloat = 16
    private let border_v: CGFloat = 5
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([backBtn, titleLabel, settingBtn])
        
        self.backBtn.autoLayoutCenterY(0, .equal)
        self.backBtn.autoLayoutLeft(border_h, .equal)
        if let size = self.backBtn.imageView?.image?.size {
            self.backBtn.autoLayoutWidth(size.width, .equal)
            self.backBtn.autoLayoutHeight(size.height, .equal)
        }
        
        self.titleLabel.autoLayoutCenterY(0, .equal)
        self.titleLabel.autoLayoutLeftRelative(5, .equal, backBtn)
        self.titleLabel.autoLayoutHeight(self.bounds.height, .equal)
        
        self.settingBtn.autoLayoutCenterY(0, .equal)
        self.settingBtn.autoLayoutLeftRelative(5, .equal, titleLabel)
        self.settingBtn.autoLayoutRight(-border_h, .equal)
        if let size = self.settingBtn.imageView?.image?.size {
            self.settingBtn.autoLayoutWidth(size.width, .equal)
            self.settingBtn.autoLayoutHeight(size.height, .equal)
        }
    }

}