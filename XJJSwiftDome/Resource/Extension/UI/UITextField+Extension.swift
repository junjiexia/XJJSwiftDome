//
//  UITextField+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/3.
//

import Foundation
import UIKit

extension UITextField {
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: Notification) {
        guard isFirstResponder else {return}
        var roolView: UIView?
        
        if let super_vc = self.viewController() {
            roolView = super_vc.view
        }else if let window = XJJTools.keywindow {
            roolView = window.subviews.last
        }
        
        guard let _roolView = roolView else {return}
        guard let info = noti.userInfo else {return}
        guard let keyboardRect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        guard let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        
        let fieldRect = self.convert(self.frame, to: _roolView) /// 输入框在控制器 view 上的 rect
        let diff: CGFloat = fieldRect.maxY - keyboardRect.origin.y
        
        if diff > 0 {
            UIView.animate(withDuration: duration) {
                var rect = _roolView.frame
                rect.origin.y = -diff
                _roolView.frame = rect
            }
        }
    }
    
    @objc func keyboardWillHidden(_ noti: Notification) {
        guard isFirstResponder else {return}
        var roolView: UIView?
        let superVC = self.viewController()
        
        if let super_vc = superVC {
            roolView = super_vc.view
        }else if let window = XJJTools.keywindow {
            roolView = window.subviews.last
        }
        
        guard let _roolView = roolView else {return}
        guard let info = noti.userInfo else {return}
        guard let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        var org_y: CGFloat = 0
        
        if let super_vc = superVC {
            if super_vc.navigationController?.navigationBar.isHidden == false {
                org_y = (super_vc.navigationController?.navigationBar.frame.height ?? 0) + (XJJTools.statusBarFrame?.size.height ?? 0)
            }
        }
        
        guard _roolView.frame.origin.y != org_y else {return}
        
        UIView.animate(withDuration: duration) {
            var rect = _roolView.frame
            rect.origin.y = org_y
            _roolView.frame = rect
        }
    }
    
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
