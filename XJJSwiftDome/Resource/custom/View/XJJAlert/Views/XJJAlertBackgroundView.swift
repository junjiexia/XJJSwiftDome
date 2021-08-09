//
//  XJJAlertBackgroundView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/7/29.
//

import UIKit

class XJJAlertBackgroundView: UIView {
    
    var tapBlock: (() -> Void)?

    var cancelEnable: Bool = true
    var content: UIView? {
        didSet {
            guard let view = content else {return}
            self.updateContent(view)
        }
    }
    
    func remove() {
        self.removeContent()
        self.removeTap()
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("XJJAlertView deinit !!")
    }
    
    private var tapView: UIView!
    private var contentView: UIView?
    
    private func initUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        self.initTap()
    }
    
    private func initTap() {
        self.tapView = UIView(frame: self.bounds)
        self.addSubview(tapView)
        self.tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    @objc private func tapAction(_ tap: UITapGestureRecognizer) {
        if cancelEnable {
            self.remove()
        }
        self.tapBlock?()
    }
    
    private func removeTap() {
        if self.tapView != nil {
            self.tapView.removeFromSuperview()
            self.tapView = nil
        }
    }
    
    private func updateContent(_ view: UIView) {
        self.removeContent()
        self.contentView = view
        self.addSubview(contentView!)
    }
    
    // 类中的 View 没有作为子视图的都需要手动释放，例：content
    private func removeContent() {
        if self.contentView != nil {
            self.contentView?.removeFromSuperview()
            self.contentView = nil
            self.content = nil
        }
    }
    
}
