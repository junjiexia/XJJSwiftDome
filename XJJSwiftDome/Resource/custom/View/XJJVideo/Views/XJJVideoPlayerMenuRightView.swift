//
//  XJJVideoPlayerMenuRightView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/14.
//

import UIKit

class XJJVideoPlayerMenuRightView: UIView {
    
    var imageTapBlock: (() -> Void)?

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
    
    private var imageSize: CGSize = CGSize(width: 30, height: 30)
        
    private func initUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        self.initImageView()
    }

    private func initImageView() {
        self.imageView = UIImageView()
        self.addSubview(imageView)
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.image = XJJThemeConfig.share.listMenuImage
        self.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewAction)))
    }
    
    @objc private func imageViewAction(_ tap: UITapGestureRecognizer) {
        self.imageTapBlock?()
    }
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([imageView])
        
        self.imageView.autoLayoutCenter(0, 0, .equal)
        self.imageView.autoLayoutWidth(imageSize.width, .equal)
        self.imageView.autoLayoutHeight(imageSize.height, .equal)
    }
    
}
