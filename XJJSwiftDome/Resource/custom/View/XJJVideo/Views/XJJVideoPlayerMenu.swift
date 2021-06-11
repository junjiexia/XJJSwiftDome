//
//  XJJVideoPlayerMenu.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/14.
//

import UIKit

class XJJVideoPlayerMenu: UIView {
    var backBlock: (() -> Void)? // 返回按钮事件
    var settingBlock: (() -> Void)? // 设置按钮事件
    var lockBlock: ((_ isLock: Bool) -> Void)? // 锁定按钮事件
    var rewindBlock: (() -> Void)? // 倒回事件
    var forwardBlock: (() -> Void)? // 快进事件
    var showListBlock: (() -> Void)? // 列表按钮事件
    var playBlock: ((_ isPlay: Bool) -> Void)? // 播放按钮事件
    var fullScreenBlock: ((_ isFullScreen: Bool) -> Void)? // 全屏按钮事件

    var controlEnable: Bool = true // 控制权限
    
    func hiddenBorder() {
        self.show(false)
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
    
    private var centerView: XJJVideoPlayerMenuCenterView!
    private var topView: XJJVideoPlayerMenuTopView!
    private var leftView: XJJVideoPlayerMenuLeftView!
    private var rightView: XJJVideoPlayerMenuRightView!
    private var bottomView: XJJVideoPlayerMenuBottomView!
    
    private var tap: UITapGestureRecognizer!
    private var swipe: UISwipeGestureRecognizer!
    
    private var isShow: Bool = true // 是否显示
    private var isAnimation: Bool = false // 是否正在动画
        
    private func initUI() {
        self.initCenter()
        self.initTop()
        self.initLeft()
        self.initRight()
        self.initBottom()
        
        self.addTap()
        self.addSwipe()
    
        self.autoHidden()
    }
    
    private func initCenter() {
        self.centerView = XJJVideoPlayerMenuCenterView()
        self.addSubview(centerView)
        
        self.centerView.isHidden = true
    }
    
    private func initTop() {
        self.topView = XJJVideoPlayerMenuTopView()
        self.addSubview(topView)
        
        self.topView.backBlock = {[weak self] in
            guard let sself = self else {return}
            sself.backBlock?()
        }
        
        self.topView.settingBlock = {[weak self] in
            guard let sself = self else {return}
            sself.settingBlock?()
        }
    }
    
    private func initLeft() {
        self.leftView = XJJVideoPlayerMenuLeftView()
        self.addSubview(leftView)
        
        self.leftView.imageTapBlock = {[weak self] isLock in
            guard let sself = self else {return}
            sself.lockBlock?(isLock)
        }
    }
    
    private func initRight() {
        self.rightView = XJJVideoPlayerMenuRightView()
        self.addSubview(rightView)
        
        self.rightView.imageTapBlock = {[weak self] in
            guard let sself = self else {return}
            sself.showListBlock?()
        }
    }
    
    private func initBottom() {
        self.bottomView = XJJVideoPlayerMenuBottomView()
        self.addSubview(bottomView)
        
        self.bottomView.playBlock = {[weak self] isPlay in
            guard let sself = self else {return}
            sself.playBlock?(isPlay)
        }
        
        self.bottomView.fullScreenBlock = {[weak self] fullScreen in
            guard let sself = self else {return}
            sself.fullScreenBlock?(fullScreen)
        }
    }
    
    private func addTap() {
        self.tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func tapAction(_ tap: UITapGestureRecognizer) {
        guard !isShow else {return}
        self.show(true)
        self.autoHidden()
    }
    
    private func addSwipe() {
        self.swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        self.swipe.direction = UISwipeGestureRecognizer.Direction(rawValue: UISwipeGestureRecognizer.Direction.up.rawValue|UISwipeGestureRecognizer.Direction.down.rawValue|UISwipeGestureRecognizer.Direction.left.rawValue|UISwipeGestureRecognizer.Direction.right.rawValue)
        self.addGestureRecognizer(swipe)
    }
        
    @objc private func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        
        let point = swipe.location(in: self)
        XJJVideo_print("-swipe- point:", point)
        switch swipe.direction {
        case .left:
            self.rewindBlock?()
        case .right:
            self.forwardBlock?()
        case .up:
            break
        case .down:
            break
        default:
            break
        }
    }
    
    private func autoHidden() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.isShow {
                self.show(false)
            }
        }
    }
    
    private func show(_ show: Bool) {
        guard !isAnimation else {return}
        self.isShow = show
        self.isAnimation = true
        if show {self.hiddenViews()}
        UIView.animate(withDuration: 1.0) {
            self.changeTransforms()
        } completion: { (completed) in
            self.changeLayout()
            if !show {self.hiddenViews()}
            self.isAnimation = false
        }
    }
    
    private func changeTransforms() {
        self.topView.transform = topView.transform.translatedBy(x: 0, y: isShow ? topHeight : -topHeight)
        self.leftView.transform = leftView.transform.translatedBy(x: isShow ? leftWidth : -leftWidth, y: 0)
        self.rightView.transform = rightView.transform.translatedBy(x: isShow ? -rightWidth : rightWidth, y: 0)
        self.bottomView.transform = bottomView.transform.translatedBy(x: 0, y: isShow ? -bottomHeight : bottomHeight)
    }
    
    private func changeLayout() {
        self.topConstraint?.constant = isShow ? 0 : -topHeight
        self.leftConstraint?.constant = isShow ? 0 : -leftWidth
        self.rightConstraint?.constant = isShow ? 0 : rightWidth
        self.bottomConstraint?.constant = isShow ? 0 : bottomHeight
    }
        
    private func hiddenViews() {
        self.topView.isHidden = !isShow
        self.leftView.isHidden = !isShow
        self.rightView.isHidden = !isShow
        self.bottomView.isHidden = !isShow
    }
    
    private let topHeight: CGFloat = 30
    private let bottomHeight: CGFloat = 45
    private let leftWidth: CGFloat = 35
    private let rightWidth: CGFloat = 35
    
    private var topConstraint: NSLayoutConstraint?
    private var leftConstraint: NSLayoutConstraint?
    private var rightConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([centerView, topView, leftView, rightView, bottomView])
        
        self.centerView.autoLayoutTop(topHeight, .equal)
        self.centerView.autoLayoutLeft(leftWidth, .equal)
        self.centerView.autoLayoutRight(-rightWidth, .equal)
        self.centerView.autoLayoutBottom(-bottomHeight, .equal)
        
        self.topConstraint = self.topView.autoLayoutTop(0, .equal)
        self.topView.autoLayoutLeft(0, .equal)
        self.topView.autoLayoutRight(0, .equal)
        self.topView.autoLayoutHeight(topHeight, .equal)
        
        self.leftView.autoLayoutTop(topHeight, .equal)
        self.leftConstraint = self.leftView.autoLayoutLeft(0, .equal)
        self.leftView.autoLayoutBottom(-bottomHeight, .equal)
        self.leftView.autoLayoutWidth(leftWidth, .equal)
        
        self.rightView.autoLayoutTop(topHeight, .equal)
        self.rightConstraint = self.rightView.autoLayoutRight(0, .equal)
        self.rightView.autoLayoutBottom(-bottomHeight, .equal)
        self.rightView.autoLayoutWidth(rightWidth, .equal)
        
        self.bottomConstraint = self.bottomView.autoLayoutBottom(0, .equal)
        self.bottomView.autoLayoutLeft(0, .equal)
        self.bottomView.autoLayoutRight(0, .equal)
        self.bottomView.autoLayoutHeight(bottomHeight, .equal)
    }
    
}
