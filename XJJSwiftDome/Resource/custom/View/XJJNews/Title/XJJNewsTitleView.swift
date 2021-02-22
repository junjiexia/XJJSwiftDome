//
//  XJJNewsTitleView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/20.
//

import UIKit

class XJJNewsTitleView: UIScrollView {
    
    var cellClickBlock: ((_ item: XJJNewsTitleCellItem?) -> Void)?
    
    var dataSource: [XJJNewsTitleCellItem]? {
        didSet {
            guard let source = dataSource else {return}
            self.createCell(source)
        }
    }
    
    var titleWidth: CGFloat = 80
    
    var selectIndex: Int? {
        didSet {
            guard let index = selectIndex else {return}
            self.moveItem(to: index)
        }
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
    
    private var cellArr: [XJJNewsTitleCell] = []
    private var isMoveLeft: Bool? // 是否是向左移动
    private var currentIndex: Int = 0 // 当前index
    
    private func initUI() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.canCancelContentTouches = true
        self.delaysContentTouches = false
    }

    private func createCell(_ source: [XJJNewsTitleCellItem]) {
        self.cellArr.forEach { $0.removeFromSuperview() }
        self.cellArr.removeAll()
        
        if source.count > 0 {
            for i in 0..<source.count {
                let cell = XJJNewsTitleCell()
                let item = source[i]
                item.id = i
                cell.item = item
                self.addSubview(cell)
                self.cellArr.append(cell)
                
                cell.cellTapBlock = {[weak self] item in
                    guard let sself = self else {return}
                    sself.moveItem(to: i)
                    sself.cellClickBlock?(item)
                }
            }
        }
    }
    
    private func moveItem(to index: Int) {
        if index == currentIndex {
            return
        }else {
            self.isMoveLeft = index < currentIndex
            self.currentIndex = index
            self.cellArr.forEach { if $0.item?.id == index { $0.selectItem(isSelect: true)} else { $0.selectItem(isSelect: false) } }
        }
        
        guard let isLeft = self.isMoveLeft else {return}
        
        let _width: CGFloat = self.titleWidth
        let xArr: [CGFloat] = self.cellArr.map { ($0.item?.width_count ?? 0) * _width }
        let xSet = xArr.edgeValue(and: index)
        let minX: CGFloat = xSet.0
        let maxX: CGFloat = xSet.1
        let max_offset: CGFloat = maxX - self.bounds.width
        
        if isLeft {
            if self.contentOffset.x > minX, self.contentOffset.x <= maxX {
                UIView.animate(withDuration: 0.5, animations: {
                    self.contentOffset = CGPoint(x: minX, y: 0)
                }) { (complete) in
                    
                }
            }
        }else {
            if max_offset > 0 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.contentOffset = CGPoint(x: max_offset, y: 0)
                }) { (complete) in
                    
                }
            }
        }
        
        self.isMoveLeft = nil
    }
        
    private func setupSubviewsLayout() {
        if self.cellArr.count > 0 {
            var _width: CGFloat = 0
            
            for i in 0..<cellArr.count {
                let num = cellArr[i].item?.width_count ?? 1
                cellArr[i].frame = CGRect(x: _width, y: 0, width: titleWidth * num, height: self.bounds.height)
                _width += titleWidth * num
            }
            
            self.contentSize = CGSize(width: _width, height: self.bounds.height)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
