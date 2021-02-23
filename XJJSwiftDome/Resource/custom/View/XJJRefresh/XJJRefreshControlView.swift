//
//  XJJRefreshControlView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/23.
//

import UIKit

class XJJRefreshControlView: UIView {
    
    func updateState(r_state: XJJRefreshControl.RState, old_state: XJJRefreshControl.RState?, scroll: UIScrollView?, refreshBlock: (() -> Void)?) {
        switch r_state {
        case .normal:
            if old_state == .refreshing {
                self.updateDate = Date().dateString("yyyy-MM-dd HH:mm:ss")
                self.updateText(self.textSet.3 + self.updateDate)
                UIView.animate(withDuration: 0.25, animations: {
                    scroll?.contentInset.top -= XJJRefresh.controlHeight
                    self.aiView.stopAnimating()
                }, completion: { (_) in
                    self.imageView.isHidden = false
                    self.updateText(self.textSet.4 + self.updateDate)
                })
            }else {
                self.updateText(self.textSet.0)
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.imageView.transform = CGAffineTransform.identity
            })
        case .runing:
            self.updateText(self.textSet.1)
            UIView.animate(withDuration: 0.25, animations: {
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(-3 * Double.pi))
            })
        case .refreshing:
            self.updateText(self.textSet.2)
            UIView.animate(withDuration: 0.25, animations: {
                scroll?.contentInset.top += XJJRefresh.controlHeight
                self.aiView.startAnimating()
                self.imageView.isHidden = true
            }, completion: { (_) in
                refreshBlock?()
            })
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
    
    private var imageView: UIImageView!
    private var textLabel: UILabel!
    private var aiView: UIActivityIndicatorView!
    
    private var textSet: (String, String, String, String, String) = ("下拉刷新数据", "继续下拉刷新数据", "正在刷新", "刷新完成，", "上次更新时间：") // 显示字串（正常，下拉，刷新中，刷新完成，上次更新时间）
    private var updateDate: String = ""
    
    private func initUI() {
        self.initActivityIndicatorView()
        self.initImageView()
        self.initTextLabel()
    }
    
    private func initActivityIndicatorView() {
        self.aiView = UIActivityIndicatorView(style: .medium)
        self.addSubview(aiView)
    }
    
    private func initImageView() {
        self.imageView = UIImageView(image: UIImage(named: "shuaxin"))
        self.addSubview(imageView)
        
        self.imageView.tintColor = self.backgroundColor?.invertColor
        self.imageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    private func initTextLabel() {
        self.textLabel = UILabel()
        self.addSubview(textLabel)
        
        self.textLabel.text = self.textSet.0
        self.textLabel.textColor = self.backgroundColor?.invertColor
        self.textLabel.font = UIFont.systemFont(ofSize: 15)
        self.textLabel.textAlignment = .center
    }
    
    private func updateText(_ text: String) {
        self.textLabel.text = text
        self.setNeedsLayout()
    }
    
    private let aiSize: CGSize = CGSize(width: 40, height: 40)
    private let merge: CGFloat = 5
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([aiView, imageView, textLabel])
        
        let isCompleted: Bool = !self.aiView.isAnimating && self.imageView.isHidden
        
        self.aiView.autoLayoutCenterY(0, .equal)
        self.aiView.autoLayoutWidth(aiSize.width, .equal)
        self.aiView.autoLayoutHeight(aiSize.height, .equal)
        
        if let text = self.textLabel.text, let font = self.textLabel.font {
            let width: CGFloat = text.getWidth(font, self.bounds.height, self.bounds.width / 3 * 2)
            var contentWidth: CGFloat = aiSize.width + width + merge
            var aiX: CGFloat = (self.bounds.width - contentWidth) / 2
            
            if isCompleted {
                contentWidth = width
                aiX = (self.bounds.width - contentWidth) / 2 - merge - aiSize.width
            }
            
            self.aiView.autoLayoutLeft(aiX, .equal)
            
            self.textLabel.autoLayoutLeftRelative(merge, .equal, aiView)
            self.textLabel.autoLayoutCenterY(0, .equal)
            self.textLabel.autoLayoutWidth(width, .equal)
            self.textLabel.autoLayoutHeight(self.bounds.height, .equal)
        }else {
            self.aiView.autoLayoutCenterX(0, .equal)
        }
        
        self.imageView.autoLayoutCenterY(0, .equal)
        self.imageView.autoLayoutRight(0, .equal, aiView)
        if let size = self.imageView.image?.size {
            self.imageView.autoLayoutWidth(size.width, .equal)
            self.imageView.autoLayoutHeight(size.height, .equal)
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
