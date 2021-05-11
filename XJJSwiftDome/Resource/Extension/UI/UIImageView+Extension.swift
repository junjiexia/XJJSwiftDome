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
        * lockImageOpenBlock 为 UIImageView 共有，使用时需要判断 imageView
     */
    public static var lockImageOpenBlock: ((_ imageView: UIImageView, _ open: Bool) -> Void)?
    
    public func setupLockImage(size: CGSize? = nil) {
        self.image = UIImage.drawLockOfClose(size: size ?? self.bounds.size)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lockImageTapAction)))
    }
    
    @objc private func lockImageTapAction(_ tap: UITapGestureRecognizer) {
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

extension UIImageView {
    /*
        * 播放 & 暂停 - 动图
        * 需要 UIImage+Extension 中，关于播放、暂停的方法支持
        * 征用了 isHighlighted 属性
            * 若需要对 isHighlighted 属性赋值，不要使用关于 play & pause 的任何方法（这个 extension 中的属性及方法），可以仿写代码实现
        * playAndPauseBlock 为 UIImageView 共有，使用时需要判断 imageView
     */
    public static var playAndPauseBlock: ((_ imageView: UIImageView, _ play: Bool) -> Void)?
    
    public func setupPlayAndPause(size: CGSize? = nil) {
        self.image = UIImage.drawPlay(size: size ?? self.bounds.size)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playAndPauseTapAction)))
    }
    
    @objc private func playAndPauseTapAction(_ tap: UITapGestureRecognizer) {
        guard !isAnimating else {return}
        self.isHighlighted = !self.isHighlighted
        self.playAndPauseAnimation()
        UIImageView.playAndPauseBlock?(self, isHighlighted)
    }
    
    private func playAndPauseAnimation() {
        let play1 = UIImage.drawPlay(size: self.image?.size)
        let play2 = UIImage.drawPlay(size: self.image?.size, scale: 0.9)
        let pause1 = UIImage.drawPause(size: self.image?.size)
        let pause2 = UIImage.drawPause(size: self.image?.size, scale: 0.9)
        
        if isHighlighted {
            self.animationImages = [play1!, play2!, pause1!]
        }else {
            self.animationImages = [pause1!, pause2!, play1!]
        }
        
        self.animationDuration = 0.5
        self.animationRepeatCount = 1
        self.startAnimating()
        
        self.image = isHighlighted ? pause1 : play1
    }
}

