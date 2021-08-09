//
//  XJJNavigationTitleView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/4.
//

import UIKit

enum XJJNavigationTitleType { // 标题视图类型
    case label
    case image
}

class XJJNavigationTitleView: UIView {
    
    var type: XJJNavigationTitleType = .label
    
    var text: XJJText? {
        didSet {
            guard let t = text else {return}
            self.setupLabel(t)
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
        self.setSubviewLayout()
    }
    
    private var titleLabel: UILabel?
    private var imageView: UIImageView?
        
    private func initUI() {
        switch type {
        case .label:
            self.initLabel()
        case .image:
            self.initImageView()
        }
    }
    
    private func initLabel() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel!)
    }
    
    private func initImageView() {
        self.imageView = UIImageView()
        self.addSubview(imageView!)
    }
    
    private func setupLabel(_ text: XJJText) {
        self.titleLabel?.setText(text)
        self.setNeedsLayout()
    }
    
    private func setSubviewLayout() {
        self.removeConstraints(self.constraints)
        
        switch type {
        case .label:
            let height: CGFloat = 40
            self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
            self.titleLabel?.autoLayoutCenter(0, 0, .equal)
            self.titleLabel?.autoLayoutHeight(height, .equal)
            if let text = self.titleLabel?.text, let font = self.titleLabel?.font {
                let width: CGFloat = text.getWidth(font, height, UIScreen.main.bounds.width * 4 / 5)
                self.titleLabel?.autoLayoutWidth(width, .equal)
            }
        case .image:
            self.imageView?.translatesAutoresizingMaskIntoConstraints = false
            self.imageView?.autoLayoutCenter(0, 0, .equal)
            if let size = self.imageView?.image?.size {
                self.imageView?.autoLayoutWidth(size.width, .equal)
                self.imageView?.autoLayoutHeight(size.height, .equal)
            }
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
