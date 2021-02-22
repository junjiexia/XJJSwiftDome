//
//  XJJNewsView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/20.
//

import UIKit

class XJJNewsView: UIView {
        
    var titleHeight: CGFloat = 50
    
    // 更新内容
    func updateContent() {
        
    }
    
    // 设置属性，以创建视图
    func setup(titles: [XJJNewsTitleCellItem], contents: [XJJNewsContentCell]) {
        self.setupTitle(data: titles)
        self.setupContent(data: contents)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupSubviewsLayout()
    }
    
    private var titleView: XJJNewsTitleView!
    private var contentView: XJJNewsContentView!
    
    private var titleCount: Int = 0 // 数量
    private var currentIndex: Int = 0 // 当前index
    private var isTitleTap: Bool = false  // 是否是点击title
    
    private func initUI() {
        self.initTitle()
        self.initContent()
    }
    
    private func initTitle() {
        self.titleView = XJJNewsTitleView()
        self.addSubview(titleView)
        
        self.titleView.delegate = self
        
        self.titleView.cellClickBlock = {[weak self] item in
            guard let sself = self else {return}
            if let index = item?.id {
                sself.moveContent(index)
            }
        }
    }
    
    private func initContent() {
        self.contentView = XJJNewsContentView()
        self.addSubview(contentView)
        
        self.contentView.delegate = self
    }
    
    private func setupTitle(data: [XJJNewsTitleCellItem]) {
        self.titleCount = data.count
        self.titleView.dataSource = data
    }
    
    private func setupContent(data: [XJJNewsContentCell]) {
        var arr: [XJJNewsContentCell] = data
        
        if data.count < self.titleCount {
            let count = self.titleCount - data.count
            for _ in 0..<count {
                let cell = XJJNewsContentCell()
                cell.item = XJJNewsContentCellItem()
                arr.append(cell)
            }
        }else {
            for i in 0..<self.titleCount {
                arr.append(data[i])
            }
        }
        
        self.contentView.dataViews = arr
    }
    
    private func moveContent(_ index: Int) {
        guard self.titleCount > 0 else {return}
        self.isTitleTap = true
        self.currentIndex = index
        
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.contentOffset = CGPoint(x: self.contentView.bounds.width * CGFloat(index), y: 0)
        }) { (complete) in
            self.isTitleTap = false
        }
    }
    
    private let merge: CGFloat = 1
    
    private func setupSubviewsLayout() {
        self.titleView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: titleHeight)
        self.contentView.frame = CGRect(x: 0, y: titleHeight + merge, width: self.bounds.width, height: self.bounds.height - titleHeight - merge)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension XJJNewsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let size = scrollView.contentSize
        if scrollView == titleView {
            
        }else {
            guard !isTitleTap else {return}
            let width: CGFloat = size.width / CGFloat(titleCount)
            let index: Int = Int((offset.x / width) + 0.5)
            
            if index != self.currentIndex {
                self.currentIndex = index
                self.titleView.selectIndex = index
            }
        }
    }
}
