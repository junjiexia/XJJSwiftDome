//
//  XJJLoadMoreControlView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/23.
//

import UIKit

class XJJLoadMoreControlView: UIView {
    
    func updateState(l_state: XJJLoadMoreControl.LState, old_state: XJJLoadMoreControl.LState?, scroll: UIScrollView?, loadMoreBlock: (() -> Void)?) {
        switch l_state {
        case .normal:
            if old_state == .loading {
                self.updatePage += 1
                self.updateText(self.textSet.3)
                self.aiView.stopAnimating()
                UIView.animate(withDuration: 0.25, animations: {
                    scroll?.contentInset.bottom -= XJJRefresh.loadMoreHeight
                }, completion: { (_) in
                    self.updateText(self.textSet.4 + "\(self.updatePage)")
                    //self.isHidden = true
                })
            }else {
                self.updateText(self.textSet.0)
            }
        case .runing:
            self.isHidden = false
            self.updateText(self.textSet.1)
        case .loading:
            self.updateText(self.textSet.2)
            self.aiView.startAnimating()
            UIView.animate(withDuration: 0.25, animations: {
                scroll?.contentInset.bottom += XJJRefresh.loadMoreHeight
            }, completion: { (_) in
                loadMoreBlock?()
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
    
    private var textLabel: UILabel!
    private var aiView: UIActivityIndicatorView!
    
    private var textSet: (String, String, String, String, String) = ("上拉加载数据", "继续上拉加载数据", "正在加载", "加载完成", "已加载页数：") // 显示字串（正常，上拉，加载中，加载完成，已加载页数）
    private var updatePage: Int = 0
    
    private func initUI() {
        self.initActivityIndicatorView()
        self.initTextLabel()
    }
    
    private func initActivityIndicatorView() {
        self.aiView = UIActivityIndicatorView(style: .medium)
        self.addSubview(aiView)
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
        
        UIView.setupNeedLayout([aiView, textLabel])
        
        let isCompleted: Bool = !self.aiView.isAnimating
        
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
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
