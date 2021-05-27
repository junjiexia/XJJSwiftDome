//
//  UIView+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/4.
//

import Foundation
import UIKit

extension UIView {
    public class func setupNeedLayout(_ views: [UIView]) {
        guard views.count > 0 else {return}
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    @discardableResult public func autoLayoutTop(_ top: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) -> NSLayoutConstraint {
        var layoutConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: related, toItem: superview, attribute: .top, multiplier: 1, constant: top)
        
        if let otherView = other {
            layoutConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: related, toItem: otherView, attribute: .top, multiplier: 1, constant: top)
        }
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutLeft(_ left: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) -> NSLayoutConstraint {
        var layoutConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: related, toItem: superview, attribute: .left, multiplier: 1, constant: left)
        
        if let otherView = other {
            layoutConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: related, toItem: otherView, attribute: .left, multiplier: 1, constant: left)
        }
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutRight(_ right: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) -> NSLayoutConstraint {
        var layoutConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: related, toItem: superview, attribute: .right, multiplier: 1, constant: right)
        
        if let otherView = other {
            layoutConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: related, toItem: otherView, attribute: .right, multiplier: 1, constant: right)
        }
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutBottom(_ bottom: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) -> NSLayoutConstraint {
        var layoutConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: related, toItem: superview, attribute: .bottom, multiplier: 1, constant: bottom)
        
        if let otherView = other {
            layoutConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: related, toItem: otherView, attribute: .bottom, multiplier: 1, constant: bottom)
        }
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutCenter(_ centerX: CGFloat, _ centerY: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) -> [NSLayoutConstraint] {
        var layoutConstraintX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: related, toItem: superview, attribute: .centerX, multiplier: 1, constant: centerX)
        var layoutConstraintY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: related, toItem: superview, attribute: .centerY, multiplier: 1, constant: centerY)
        
        if let otherView = other {
            layoutConstraintX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: related, toItem: otherView, attribute: .centerX, multiplier: 1, constant: centerX)
            layoutConstraintY = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: related, toItem: otherView, attribute: .centerY, multiplier: 1, constant: centerY)
        }
        self.superview?.addConstraint(layoutConstraintX)
        self.superview?.addConstraint(layoutConstraintY)
        
        return [layoutConstraintX, layoutConstraintY]
    }
    
    @discardableResult public func autoLayoutCenterX(_ centerX: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) -> NSLayoutConstraint {
        var layoutConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: related, toItem: superview, attribute: .centerX, multiplier: 1, constant: centerX)
        
        if let otherView = other {
            layoutConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: related, toItem: otherView, attribute: .centerX, multiplier: 1, constant: centerX)
        }
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutCenterY(_ centerY: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView? = nil) -> NSLayoutConstraint {
        var layoutConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: related, toItem: superview, attribute: .centerY, multiplier: 1, constant: centerY)
        
        if let otherView = other {
            layoutConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: related, toItem: otherView, attribute: .centerY, multiplier: 1, constant: centerY)
        }
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutWidth(_ width: CGFloat, _ related: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let layoutConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: related, toItem: nil, attribute: .width, multiplier: 1, constant: width)
        
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutHeight(_ height: CGFloat, _ related: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let layoutConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: related, toItem: nil, attribute: .height, multiplier: 1, constant: height)
        
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutTopRelative(_ top: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView) -> NSLayoutConstraint {
        let layoutConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: related, toItem: other, attribute: .bottom, multiplier: 1, constant: top)
        
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutLeftRelative(_ left: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView) -> NSLayoutConstraint {
        let layoutConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: related, toItem: other, attribute: .right, multiplier: 1, constant: left)
        
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutRightRelative(_ right: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView) -> NSLayoutConstraint {
        let layoutConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: related, toItem: other, attribute: .left, multiplier: 1, constant: right)
        
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
    
    @discardableResult public func autoLayoutBottomRelative(_ bottom: CGFloat, _ related: NSLayoutConstraint.Relation, _ other: UIView) -> NSLayoutConstraint {
        let layoutConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: related, toItem: other, attribute: .top, multiplier: 1, constant: bottom)
        
        self.superview?.addConstraint(layoutConstraint)
        
        return layoutConstraint
    }
}

extension UIView {
    /// 删除所有子视图
    public func removeAllSubview() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    /// 是否包含 view （遍历页面所有 view ）
    public func containsView(_ view: UIView) -> Bool {
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
    public func resignAllFirstResponder() {
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
    public func viewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self) {
                    return responder as? UIViewController
                }
            }
        }
        
        return nil
    }
    
    public func superScroll() -> UIScrollView? {
        for view in sequence(first: self.superview, next: {$0?.superview}) {
            if let responder = view?.next {
                if responder.isKind(of: UIScrollView.self) {
                    return responder as? UIScrollView
                }
            }
        }
        
        return nil
    }
    
    public func superTable() -> UITableView? {
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
    public func asView<T>(_ cs: T.Type) -> T? {
        return self as? T
    }
}
