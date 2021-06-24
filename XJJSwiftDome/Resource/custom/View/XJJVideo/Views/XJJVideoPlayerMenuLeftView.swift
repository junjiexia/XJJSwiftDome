//
//  XJJVideoPlayerMenuLeftView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/14.
//

import UIKit

class XJJVideoPlayerMenuLeftView: UIView {
    
    var imageTapBlock: ((_ isOpen: Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imageView: UIImageView!
    
    private var imageSize: CGSize = CGSize(width: 30, height: 30)
        
    private func initUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        self.initImageView()
    }
    
    private func initImageView() {
        self.imageView = UIImageView()
        self.addSubview(imageView)
        
        self.imageView.setupLockImage(size: imageSize)
        
        UIImageView.lockImageOpenBlock = {[weak self] imageView, isOpen in
            guard let sself = self else {return}
            if imageView == sself.imageView {
                sself.imageTapBlock?(isOpen)
            }
        }
    }
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([imageView])
        
        self.imageView.autoLayoutCenter(0, 0, .equal)
        self.imageView.autoLayoutWidth(imageSize.width, .equal)
        self.imageView.autoLayoutHeight(imageSize.height, .equal)
    }

}
