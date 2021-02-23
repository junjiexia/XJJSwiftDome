//
//  XJJNewsContentView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/20.
//

import UIKit

class XJJNewsContentView: UIScrollView {
    
    var dataViews: [UIView]? {
        didSet {
            guard let views = dataViews else {return}
            self.updateUI(views)
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
    
    private var cellArr: [UIView] = []
    
    private func initUI() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.canCancelContentTouches = true
        self.delaysContentTouches = false
        self.isPagingEnabled = true
        self.bounces = false
    }
    
    private func updateUI(_ views: [UIView]) {
        self.cellArr.forEach { $0.removeFromSuperview() }
        self.cellArr = views
        
        for i in 0..<self.cellArr.count {
            if let cell = self.cellArr[i] as? XJJNewsContentCell {
                cell.item?.id = i
                self.cellArr[i] = cell
                self.addSubview(self.cellArr[i])
            }else {
                self.addSubview(self.cellArr[i])
            }
        }
    }
    
    private func setupSubviewsLayout() {
        if self.cellArr.count > 0 {
            self.contentSize = CGSize(width: self.bounds.width * CGFloat(self.cellArr.count), height: self.bounds.height)
            for i in 0..<self.cellArr.count {
                self.cellArr[i].frame = CGRect(x: self.bounds.width * CGFloat(i), y: 0, width: self.bounds.width, height: self.bounds.height)
            }
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
