//
//  XJJNewsTableOneCell.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/24.
//

import UIKit

class XJJNewsTableOneCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var titleLabel: UILabel! // 标题
    private var originLabel: UILabel! // 来源
    private var tipLabel: UILabel! // 小提示
    private var imageSet: [UIImageView] = [] // 图片集合
    private var cancelBtn: UIButton! // 消除按钮
    
    private func initUI() {
        
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel)
        
        self.titleLabel.textColor = UIColor.darkText
    }
    
}
