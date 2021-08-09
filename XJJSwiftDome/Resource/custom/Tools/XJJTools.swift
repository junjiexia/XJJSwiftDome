//
//  XJJTools.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/5/26.
//

import Foundation
import UIKit

class XJJTools {
    class func call(phone: String) {
        let phoneStr = "telprompt://" + phone
        if UIApplication.shared.canOpenURL(URL(string: phoneStr)!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: phoneStr)!, options: [:], completionHandler: nil)
            }else {
                UIApplication.shared.openURL(URL(string: phoneStr)!)
            }
         }
    }
}

//MARK: - find UI
extension XJJTools {
    static var statusBarFrame: CGRect? {
        if #available(iOS 13.0, *) {
            return keywindow?.windowScene?.statusBarManager?.statusBarFrame
        }else {
            return UIApplication.shared.statusBarFrame
        }
    }
    
    // 默认 主 scene 中， 主 window 是第一个，UITextEffectsWindow 为第二个
    // 在主 scene 上还有 键盘的 scene
    static var keywindow: UIWindow? {
        var window:UIWindow? = nil
        if #available(iOS 13.0, *) {
            for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                if windowScene.activationState == .foregroundActive {
                    window = windowScene.windows.first
                    break
                }
            }
            if window == nil {
                window = UIApplication.shared.windows.first
            }
        }else{
            window = UIApplication.shared.keyWindow
        }
        
        return window
    }
    
    static var currentViewCotroller: UIViewController? {
        
        var result: UIViewController? = nil
        
        guard let _window = keywindow else {
            return result
        }
        
        var window = _window
        
        if window.windowLevel != UIWindow.Level.normal {
            guard let _tmpWin =  UIApplication.shared.windows
                .filter({ $0.windowLevel == UIWindow.Level.normal })
                .first else {
                    return result
            }
            window = _tmpWin
        }
        
        var nextResponder: UIResponder? = nil
        let appRootVC = window.rootViewController
        
        // 如果是present上来的appRootVC.presentedViewController 不为nil
        if let presentedVC = appRootVC?.presentedViewController {
            nextResponder = presentedVC
        } else {
            let frontView = window.subviews[0]
            nextResponder = frontView.next
        }
        
        if let tabbar = nextResponder as? UITabBarController {
            if let nav = tabbar.viewControllers?[tabbar.selectedIndex] as? UINavigationController {
                result = nav.children.last
            }
        } else if let nav = nextResponder as? UINavigationController {
            result = nav.children.last
        } else {
            result = nextResponder as? UIViewController
        }
        
        return result
    }
}
