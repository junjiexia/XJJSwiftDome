//
//  XJJRefreshControl.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/22.
//

import Foundation
import UIKit

class XJJRefreshControl: UIControl {
    
    var refreshBlock: ((_ r_state: RState, _ old_state: RState?) -> Void)?
    
    var contentView: UIView? {
        didSet {
            guard let view = contentView else {return}
            self.addContent(view)
        }
    }
    
    var refreshState: RState {
        get {
            return self.rState ?? .normal
        }
    }
    
    func endRefresh() {
        self.rState = .normal
    }
        
    enum RState: String {
        case normal = "普通状态"
        case runing = "下拉状态"
        case refreshing = "正在刷新"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        self.scrollView = nil
    }
    
    private var content: UIView!
    private weak var scrollView: UIScrollView?
    
    private var rState: RState? {
        didSet {
            guard let r_state = rState else {return}
            self.eventAction(r_state, old_state: oldValue)
        }
    }
    
    private func initUI() {
        self.content = XJJRefreshControlView(frame: self.bounds)
        self.addSubview(content)
    }
    
    private func addContent(_ view: UIView) {
        if self.content != nil {
            self.content.removeFromSuperview()
            self.content = nil
        }
        
        self.content = view
        self.content?.frame = self.bounds
        self.addSubview(content)
    }
    
    private func eventAction(_ r_state: RState, old_state: RState?) {
        XJJRefresh.refreshState = r_state == .refreshing ? .getNew : .ready
        self.scrollView?.isScrollEnabled = XJJRefresh.refreshState == .ready
        
        if let _view = self.content as? XJJRefreshControlView {
            _view.updateState(r_state: r_state, old_state: old_state, scroll: self.scrollView) {[weak self] in
                guard let sself = self else {return}
                sself.sendActions(for: .valueChanged)
            }
        }else {
            self.refreshBlock?(r_state, old_state)
        }
    }
    
}

extension XJJRefreshControl {
    override func willMove(toSuperview newSuperview: UIView?) {
        guard let super_view = newSuperview as? UIScrollView else {return}
        self.scrollView = super_view
        
        self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "contentOffset":
            //print("object:", object ?? "未知")
            guard XJJRefresh.refreshState == .ready else {return}
            if let scroll = object as? UIScrollView {
                let new_offset = change?[.newKey] as? CGPoint ?? CGPoint.zero
                //let old_offset = change?[.oldKey] as? CGPoint ?? CGPoint.zero
                self.checkDataForObserve(offset: new_offset, scroll: scroll)
            }
        default:
            break
        }
    }
    
    private func checkDataForObserve(offset: CGPoint, scroll: UIScrollView) {
        let offsetMaxY: CGFloat = -(scroll.contentInset.top + XJJRefresh.controlHeight)
        
        //print("offset:", offset, "max:", offsetMaxY)
        if scroll.isDragging { // 正在拖拽
            if offset.y >= offsetMaxY, self.refreshState == .runing {
                self.rState = .normal
            }else if offset.y < offsetMaxY, self.refreshState == .normal {
                self.rState = .runing
            }
        }else { // 拖拽完成
            if self.refreshState == .runing {
                self.rState = .refreshing
            }
        }
    }
}
