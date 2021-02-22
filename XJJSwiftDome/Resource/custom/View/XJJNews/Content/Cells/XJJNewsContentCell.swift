//
//  XJJNewsContentCell.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/22.
//

import UIKit

class XJJNewsContentCell: UIView {
    
    var item: XJJNewsContentCellItem? {
        didSet {
            guard let it = item else {return}
            self.updateUI(it)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var type: XJJNewsContentCellItem.CType = .empty
    
    private func initUI() {
        
    }
    
    private func updateUI(_ item: XJJNewsContentCellItem) {
        self.type = item.type
        
        switch item.type {
        case .empty:
            self.backgroundColor = UIColor.randomColor
        case .custom:
            break
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
