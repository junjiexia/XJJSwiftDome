//
//  UIImageView+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/17.
//

import Foundation
import UIKit

extension UIImageView {
    /*
        * 开锁 & 上锁 - 动图
        * 需要 UIImage+Extension 中，关于锁的方法支持
        * 征用了 isHighlighted 属性
            * 若需要对 isHighlighted 属性赋值，不要使用关于 lockImage 的任何方法（这个 extension 中的属性及方法），可以仿写代码实现
     */
    public static var lockImageOpenBlock: ((_ imageView: UIImageView, _ open: Bool) -> Void)?
    
    public func setupLockImage() {
        self.image = UIImage.drawLockOfClose(size: self.bounds.size)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lockImageTapAction)))
    }
    
    @objc func lockImageTapAction(_ tap: UITapGestureRecognizer) {
        guard !isAnimating else {return}
        self.isHighlighted = !self.isHighlighted
        self.lockAnimation()
        UIImageView.lockImageOpenBlock?(self, isHighlighted)
    }
    
    private func lockAnimation() {
        let close = UIImage.drawLockOfClose(size: self.image?.size)
        let open1 = UIImage.drawLockOfOpen(size: self.image?.size, openRight: false)
        let open2 = UIImage.drawLockOfOpen(size: self.image?.size, openRight: true)
        
        if isHighlighted {
            self.animationImages = [close!, open1!, open2!]
        }else {
            self.animationImages = [open2!, open1!, close!]
        }
        
        self.animationDuration = 1
        self.animationRepeatCount = 1
        self.startAnimating()
        
        self.image = isHighlighted ? open2 : close
    }
}

