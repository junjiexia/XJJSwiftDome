//
//  XJJVideoPlayerMenuTopView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/14.
//

import UIKit

class XJJVideoPlayerMenuTopView: UIView {
    
    var backBlock: (() -> Void)?
    
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
        
    }

}
