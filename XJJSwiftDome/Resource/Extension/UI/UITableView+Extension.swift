//
//  UITableView+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/20.
//

import Foundation
import UIKit

extension UITableView {
    
    func setupStyle(backgroundColor: UIColor? = nil) {
        self.backgroundColor = backgroundColor ?? UIColor.lightGray
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.separatorStyle = .none
    }
    
    func setupLine(lineColor: UIColor? = nil) {
        self.separatorInset = .zero
        self.separatorStyle = .singleLine
        self.separatorColor = lineColor ?? UIColor.lightGray
    }
    
    func addTouchTap() {
        if self.backgroundView == nil {
            let touchView = UIView(frame: self.bounds)
            touchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchAction)))
            self.backgroundView = touchView
        }else {
            let touchView = UIView(frame: self.bounds)
            touchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchAction)))
            self.backgroundView?.addSubview(touchView)
        }
    }
    
    @objc func touchAction(_ tap: UITapGestureRecognizer) {
        self.viewController()?.view.resignAllFirstResponder()
    }
}
