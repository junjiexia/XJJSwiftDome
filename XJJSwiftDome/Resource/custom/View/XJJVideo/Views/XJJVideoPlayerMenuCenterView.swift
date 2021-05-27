//
//  XJJVideoPlayerMenuCenterView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/5/15.
//

import UIKit

class XJJVideoPlayerMenuCenterView: UIView {
    
    var image: UIImage? {
        didSet {
            guard let img = image else {return}
            self.imageView.image = img
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
    
    private func initUI() {
        self.initImageView()
    }
    
    private func initImageView() {
        self.imageView = UIImageView()
        self.addSubview(imageView)
        
        self.imageView.isUserInteractionEnabled = true
    }
    
    private func setupSubviewsLayout() {
        self.removeConstraints(self.constraints)
        
        UIView.setupNeedLayout([imageView])
        
        let size = imageView.image?.size ?? CGSize.zero
    
        self.imageView.autoLayoutCenter(0, 0, .equal)
        self.imageView.autoLayoutWidth(size.width, .equal)
        self.imageView.autoLayoutHeight(size.height, .equal)
    }
    
}
