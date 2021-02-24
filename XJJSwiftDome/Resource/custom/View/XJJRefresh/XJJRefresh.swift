//
//  XJJRefresh.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/22.
//

import Foundation
import UIKit

class XJJRefresh {
    enum State {
        case getNew // 刷新
        case getMore // 加载
        case ready // 准备就绪
    }
    
    static var controlHeight: CGFloat = 50
    static var loadMoreHeight: CGFloat = 60
    static var refreshState: State = .ready
    
    class func defaultRefresh() -> XJJRefreshControl {
        let refreshControl = XJJRefreshControl(frame: CGRect(x: 0, y: -controlHeight, width: UIScreen.main.bounds.width, height: controlHeight))
        
        return refreshControl
    }
    
    class func defaultLoadMore() -> XJJLoadMoreControl {
        let loadMoreControl = XJJLoadMoreControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: loadMoreHeight))
        
        return loadMoreControl
    }
}

extension UIScrollView {
    func addDefaultRefreshAndLoad() {
        self.setupRefreshUI()
        self.addDefaultRefresh()
        self.addDefaultLoadMore()
    }
    
    func addDefaultRefresh() {
        let refreshControl = XJJRefresh.defaultRefresh()
        refreshControl.tag = 2000
        self.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh(_ control: XJJRefreshControl) {
        //control.endRefresh()
    }
    
    func addDefaultLoadMore() {
        let loadMoreControl = XJJRefresh.defaultLoadMore()
        loadMoreControl.tag = 2001
        self.addSubview(loadMoreControl)
        
        loadMoreControl.addTarget(self, action: #selector(loadMore), for: .valueChanged)
    }
    
    @objc func loadMore(_ control: XJJLoadMoreControl) {
        //control.endLoad()
    }
    
    func setupRefreshUI() {
        self.showsHorizontalScrollIndicator = false
        self.canCancelContentTouches = true
        self.delaysContentTouches = false
        self.isPagingEnabled = false
        self.bounces = true
    }
    
}
