//
//  UIView+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/4.
//

import Foundation
import UIKit

extension UIView {
    class func setupNeedLayout(_ views: [UIView]) {
        guard views.count > 0 else {return}
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func autoLayoutTop(_ top: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: related, toItem: other ?? superV, attribute: .top, multiplier: 1, constant: top))
    }
    
    func autoLayoutLeft(_ left: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: related, toItem: other ?? superV, attribute: .left, multiplier: 1, constant: left))
    }
    
    func autoLayoutRight(_ right: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: related, toItem: other ?? superV, attribute: .right, multiplier: 1, constant: right))
    }
    
    func autoLayoutBottom(_ bottom: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: related, toItem: other ?? superV, attribute: .bottom, multiplier: 1, constant: bottom))
    }
    
    func autoLayoutCenter(_ centerX: CGFloat, _ centerY: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: related, toItem: other ?? superV, attribute: .centerX, multiplier: 1, constant: centerX))
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: related, toItem: other ?? superV, attribute: .centerY, multiplier: 1, constant: centerY))
    }
    
    func autoLayoutCenterX(_ centerX: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: related, toItem: other ?? superV, attribute: .centerX, multiplier: 1, constant: centerX))
    }
    
    func autoLayoutCenterY(_ centerY: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: related, toItem: other ?? superV, attribute: .centerY, multiplier: 1, constant: centerY))
    }
    
    func autoLayoutWidth(_ width: CGFloat, _ related: NSLayoutConstraint.Relation) {
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: related, toItem: nil, attribute: .width, multiplier: 1, constant: width))
    }
    
    func autoLayoutHeight(_ height: CGFloat, _ related: NSLayoutConstraint.Relation) {
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: related, toItem: nil, attribute: .height, multiplier: 1, constant: height))
    }
    
    func autoLayoutTopRelative(_ top: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: related, toItem: other, attribute: .bottom, multiplier: 1, constant: top))
    }
    
    func autoLayoutLeftRelative(_ left: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: related, toItem: other, attribute: .right, multiplier: 1, constant: left))
    }
    
    func autoLayoutRightRelative(_ right: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: related, toItem: other, attribute: .left, multiplier: 1, constant: right))
    }
    
    func autoLayoutBottomRelative(_ bottom: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView) {
        guard let superV = self.superview else {return}
        superV.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: related, toItem: other, attribute: .top, multiplier: 1, constant: bottom))
    }
}

extension UIView {
    /// 删除所有子视图
    func removeAllSubview() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    /// 是否包含 view （遍历页面所有 view ）
    func containsView(_ view: UIView) -> Bool {
        var isContains: Bool = false
        
        if self.subviews.contains(view) {
            isContains = true
        }else {
            for sub in self.subviews {
                isContains = sub.containsView(view)
                if isContains {
                    break
                }
            }
        }
        
        return isContains
    }
    
    // 移除所有子视图的第一响应
    func resignAllFirstResponder() {
        if self.subviews.count > 0 {
            for view in self.subviews {
                if view.isKind(of: UITextView.self) || view.isKind(of: UITextField.self) {
                    view.resignFirstResponder()
                }
                if view.subviews.count > 0 {
                    view.resignAllFirstResponder()
                }else {
                    continue
                }
            }
        }
    }
    
    // 当前视图的控制器
    func viewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        
        return nil
    }
    
    func superScroll() -> UIScrollView? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next {
                if responder.isKind(of: UIScrollView.self) {
                    return responder as? UIScrollView
                }
            }
        }
        
        return nil
    }
    
    func superTable() -> UITableView? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next {
                if responder.isKind(of: UITableView.self) {
                    return responder as? UITableView
                }
            }
        }
        
        return nil
    }
    
}

extension UIView {
    func asView<T>(_ cs: T.Type) -> T? {
        return self as? T
    }
}
