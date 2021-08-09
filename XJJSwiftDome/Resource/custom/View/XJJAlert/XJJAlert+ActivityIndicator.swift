//
//  XJJAlert+ActivityIndicator.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/5.
//

import Foundation
import UIKit

extension XJJAlert {
    
    private static var waitView: XJJAlertBackgroundView?
    private static var aiView: XJJActivityIndicatorView?
    
    private static func activityIndicatorSize(text: XJJText? = nil) -> CGSize {
        var size: CGSize = CGSize(width: XJJAlert.activityIndicatorWidth + XJJAlert.borderH * 2, height: XJJAlert.activityIndicatorWidth + XJJAlert.borderV * 2)
        
        if let _text = text {
            let textMaxWidth: CGFloat = XJJAlert.ContentWidth - XJJAlert.borderH * 2 // 文字最大宽度
            if _text.size.width > textMaxWidth {
                let textHeight: CGFloat = _text.textHeight(textMaxWidth)
                size.width = XJJAlert.ContentWidth
                size.height += textHeight + XJJAlert.mergeV
            }else {
                size.width = max(_text.size.width + XJJAlert.borderH * 2, size.width)
                size.height += _text.size.height + XJJAlert.mergeV
            }
        }
                
        return size
    }
    
    static func waitStart(text: XJJText? = nil,
                          cancelEnable: Bool? = false,
                          dismissTime: TimeInterval? = 20,
                          cancelBlock: (() -> Void)? = nil) {
        waitView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        waitView?.cancelEnable = cancelEnable!
        
        let size = activityIndicatorSize(text: text)
        aiView = XJJActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.width - size.width) / 2, y: (UIScreen.main.bounds.height - size.height) / 2, width: size.width, height: size.height))
        aiView?.aiText = text
        aiView?.startAnimating()
        
        waitView?.content = aiView
        
        XJJTools.keywindow?.addSubview(waitView!)
        
        if cancelEnable == false {
            // 如果一开始不能手动取消，则在 20 秒后设置为可以手动取消
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissTime!) {
                waitView?.cancelEnable = true
            }
        }
        
        waitView?.tapBlock = {
            cancelBlock?()
        }
    }
    
    static func waitStop() {
        if aiView != nil {
            aiView?.stopAnimating()
            aiView?.removeFromSuperview()
            aiView = nil
        }
        if waitView != nil {
            waitView?.removeFromSuperview()
            waitView = nil
        }
    }
    
}
