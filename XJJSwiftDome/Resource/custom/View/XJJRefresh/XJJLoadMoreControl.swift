//
//  XJJLoadMoreControl.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/23.
//

/* 加载控制器
 */

import Foundation
import UIKit

class XJJLoadMoreControl: UIControl {
    var loadMoreBlock: ((_ l_state: LState, _ old_state: LState?) -> Void)?
    
    var contentView: UIView? {
        didSet {
            guard let view = contentView else {return}
            self.addContent(view)
        }
    }
    
    var loadState: LState? {
        get {
            return self.lState ?? .normal
        }
    }
    
    func endLoad() {
        self.lState = .normal
    }
    
    enum LState: String {
        case normal = "正常状态"
        case runing = "加载状态"
        case loading = "加载中"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.scrollView?.removeObserver(self, forKeyPath: XJJRefresh.contentOffsetKey)
        self.scrollView?.removeObserver(self, forKeyPath: XJJRefresh.contentSizeKey)
        self.scrollView = nil
    }
    
    private var content: UIView!
    private weak var scrollView: UIScrollView?
    
    private var lState: LState? {
        didSet {
            guard let l_state = lState else {return}
            self.eventAction(l_state, old_state: oldValue)
        }
    }
    
    private func initUI() {
        self.content = XJJLoadMoreControlView(frame: self.bounds)
        self.content.tag = XJJRefresh.loadMoreTag
        self.addSubview(content)
    }
    
    private func addContent(_ view: UIView) {
        if self.content != nil {
            self.content.removeFromSuperview()
            self.content = nil
        }
        
        self.content = view
        self.content.frame = self.bounds
        self.content.tag = XJJRefresh.loadMoreTag
        self.addSubview(content)
    }
    
    private func eventAction(_ l_state: LState, old_state: LState?) {
        XJJRefresh.refreshState = l_state == .loading ? .getMore : .ready
        self.scrollView?.isScrollEnabled = XJJRefresh.refreshState == .ready
        
        if let _view = self.content as? XJJLoadMoreControlView {
            _view.updateState(l_state: l_state, old_state: old_state, scroll: self.scrollView) {[weak self] in
                guard let sself = self else {return}
                sself.sendActions(for: .valueChanged)
            }
        }else {
            self.loadMoreBlock?(l_state, old_state)
        }
    }
    
}

extension XJJLoadMoreControl {
    override func willMove(toSuperview newSuperview: UIView?) {
        guard let super_view = newSuperview as? UIScrollView else {return}
        self.scrollView = super_view
        
        self.scrollView?.addObserver(self, forKeyPath: XJJRefresh.contentOffsetKey, options: [.new, .old], context: nil)
        self.scrollView?.addObserver(self, forKeyPath: XJJRefresh.contentSizeKey, options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case XJJRefresh.contentOffsetKey:
            guard XJJRefresh.refreshState == .ready else {return}
            //print("object:", object ?? "未知")
            let new_offset = change?[.newKey] as? CGPoint ?? CGPoint.zero
            //let old_offset = change?[.oldKey] as? CGPoint ?? CGPoint.zero
            if let scroll = object as? UIScrollView {
                self.checkDataForObserve(offset: new_offset, scroll: scroll)
            }else if let table = object as? UITableView {
                self.checkDataForObserve(offset: new_offset, scroll: table)
            }
        case XJJRefresh.contentSizeKey:
            let size = change?[.newKey] as? CGSize ?? CGSize.zero
            if let scroll = object as? UIScrollView {
                self.frame = CGRect(x: 0, y: size.height, width: scroll.bounds.width, height: XJJRefresh.loadMoreHeight)
            }else if let table = object as? UITableView {
                self.frame = CGRect(x: 0, y: size.height, width: table.bounds.width, height: XJJRefresh.loadMoreHeight)
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func checkDataForObserve(offset: CGPoint, scroll: UIScrollView) {
        let offsetMaxY: CGFloat = scroll.contentInset.bottom + XJJRefresh.loadMoreHeight
        
        if scroll.isDragging { // 正在拖拽
            //print("offset:", offset, "max:", offsetMaxY)
            if offset.y <= offsetMaxY, self.loadState == .runing {
                self.lState = .normal
            }else if offset.y > offsetMaxY, self.loadState == .normal {
                self.lState = .runing
            }
        }else { // 拖拽完成
            if self.loadState == .runing {
                self.lState = .loading
            }
        }
    }
}
