//
//  XJJRefresh.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/22.
//

import Foundation
import UIKit

class XJJRefresh {
    enum RState {
        case getNew
        case getMore
        case ready
    }
    
    static var controlHeight: CGFloat = 50
    
    class func defaultRefresh() -> XJJRefreshControl {
        let refreshControl = XJJRefreshControl(frame: CGRect(x: 0, y: -controlHeight, width: UIScreen.main.bounds.width, height: controlHeight))
        
        return refreshControl
    }
}

extension UIScrollView {
    func addDefaultRefresh() {
        self.setupRefreshUI()
        
        let refreshControl = XJJRefresh.defaultRefresh()
        self.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh(_ control: XJJRefreshControl) {
        UIView.animate(withDuration: 5.0) {
            control.endRefresh()
        }
    }
    
    func setupRefreshUI() {
        self.showsHorizontalScrollIndicator = false
        self.canCancelContentTouches = true
        self.delaysContentTouches = false
        self.isPagingEnabled = false
        self.bounces = true
    }
    
}
