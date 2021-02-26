//
//  XJJRefresh.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/22.
//

import Foundation
import UIKit

/* 刷新、加载 参数
 */

class XJJRefresh {
    enum State { // 页面更新状态
        case getNew // 刷新中
        case getMore // 加载中
        case ready // 准备就绪
    }
    
    static let contentOffsetKey: String = "contentOffset" // scrollView 的运动偏移 key，用于KVO
    static let contentSizeKey: String = "contentSize" // scrollView 的内容大小 key，用于KVO
    static let refreshTag: Int = 2000 // 刷新控件下的 view 的 tag 值
    static let loadMoreTag: Int = 2001 // 加载控件下的 view 的 tag 值
    
    static var regreshHeight: CGFloat = 50 // 刷新控件高度
    static var loadMoreHeight: CGFloat = 50 // 加载控件高度
    static var refreshState: State = .ready // 刷新、加载状态
    
    // 添加默认刷新控制器
    class func defaultRefresh() -> XJJRefreshControl {
        let refreshControl = XJJRefreshControl(frame: CGRect(x: 0, y: -regreshHeight, width: UIScreen.main.bounds.width, height: regreshHeight))
        
        return refreshControl
    }
    
    // 添加默认加载控制器
    class func defaultLoadMore() -> XJJLoadMoreControl {
        let loadMoreControl = XJJLoadMoreControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: loadMoreHeight))
        
        return loadMoreControl
    }
}

//MARK: - 为 scrollView 添加刷新、加载功能
// 刷新可重写 refresh 方法，获取数据后，使用 control.endRefresh() 结束刷新动画及状态更新
// 加载可重写 loadMore 方法，获取数据后，使用 control.endLoad() 结束加载动画及状态更新
extension UIScrollView {
    // 添加默认刷新、加载控件，并设置scrollView的部分属性
    func addDefaultRefreshAndLoad() {
        self.setupRefreshUI()
        self.addDefaultRefresh()
        self.addDefaultLoadMore()
    }
    
    // 添加默认刷新控件
    func addDefaultRefresh() {
        let refreshControl = XJJRefresh.defaultRefresh()
        refreshControl.tag = XJJRefresh.refreshTag
        self.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    // 默认刷新事件
    @objc func refresh(_ control: XJJRefreshControl) {
        control.endRefresh()
    }
    
    // 添加默认加载控件
    func addDefaultLoadMore() {
        let loadMoreControl = XJJRefresh.defaultLoadMore()
        loadMoreControl.tag = XJJRefresh.loadMoreTag
        self.addSubview(loadMoreControl)
        
        loadMoreControl.addTarget(self, action: #selector(loadMore), for: .valueChanged)
    }
    
    // 默认加载事件
    @objc func loadMore(_ control: XJJLoadMoreControl) {
        control.endLoad()
    }
    
    // 默认 scrollView 属性设置
    func setupRefreshUI() {
        if self.isKind(of: UITableView.self) {
            self.canCancelContentTouches = true
            self.delaysContentTouches = false
        }else {
            self.showsHorizontalScrollIndicator = false
            self.canCancelContentTouches = true
            self.delaysContentTouches = false
            self.isPagingEnabled = false
            self.bounces = true
        }
    }
}

extension UITableView {
    
}
