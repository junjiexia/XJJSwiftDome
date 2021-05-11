//
//  XJJNewsTableOneCell.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/24.
//

import UIKit

/*
 标题
 三张图片
 来源及提示                          消除按钮
 */

class XJJNewsTableOneCell: UITableViewCell {
    
    var titleText: XJJText? {
        didSet {
            guard let text = titleText else {return}
            self.titleLabel.setText(text)
        }
    }
    
    var originText: XJJText? {
        didSet {
            guard let text = originText else {return}
            self.originLabel.setText(text)
        }
    }
    
    var tipText: XJJText? {
        didSet {
            guard let text = tipText else {return}
            self.tipLabel.setText(text)
        }
    }
    
    var images: [UIImage]? {
        didSet {
            guard let arr = images, arr.count > 0 else {return}
            if arr.count >= imageSet.count {
                self.imageSet.forEach { $0.image = arr[$0.tag - 1] }
            }else {
                for i in 0..<arr.count {
                    self.imageSet[i].image = arr[i]
                }
            }
        }
    }
        
    static let identifier: String = "XJJNewsTableOneCell"
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupSubviewsLayout()
    }
    
    private var titleLabel: UILabel! // 标题
    private var originLabel: UILabel! // 来源
    private var tipLabel: UILabel! // 小提示
    private var imageSet: [UIImageView] = [] // 图片集合
    private var cancelBtn: UIButton! // 消除按钮
    private var bottomLine: UIView! // 底部分界线
    
    private func initUI() {
        self.initTitle()
        self.initOrigin()
        self.initTip()
        self.initImageSet()
        self.initCancel()
        self.initLine()
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.contentView.addSubview(titleLabel)
        
        self.titleLabel.textColor = UIColor.darkText
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = 2
    }
    
    private func initOrigin() {
        self.originLabel = UILabel()
        self.contentView.addSubview(originLabel)
        
        self.originLabel.textColor = UIColor.lightGray
        self.originLabel.font = UIFont.systemFont(ofSize: 12)
        self.originLabel.textAlignment = .left
    }
    
    private func initTip() {
        self.tipLabel = UILabel()
        self.contentView.addSubview(tipLabel)
        
        self.tipLabel.textColor = UIColor.lightGray
        self.tipLabel.font = UIFont.systemFont(ofSize: 12)
        self.tipLabel.textAlignment = .left
    }
    
    private func initImageSet() {
        self.imageSet.forEach { $0.removeFromSuperview() }
        self.imageSet.removeAll()
        
        for i in 0..<3 {
            let imageView = UIImageView(image: XJJThemeConfig.share.theme.page_icon[.empty_image]?.image)
            imageView.tag = i + 1
            self.contentView.addSubview(imageView)
            self.imageSet.append(imageView)
        }
    }
    
    private func initCancel() {
        self.cancelBtn = UIButton(type: .custom)
        self.contentView.addSubview(cancelBtn)
        
        self.cancelBtn.setImage(XJJThemeConfig.share.theme.page_icon[.cross_image]?.image, for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    
    @objc private func cancelAction(_ btn: UIButton) {
        
    }
    
    private func initLine() {
        self.bottomLine = UIView()
        self.contentView.addSubview(bottomLine)
        
        self.bottomLine.backgroundColor = XJJThemeConfig.share.theme.page_color[.tableLine]
    }
    
    private let border_H: CGFloat = 16
    private let border_V: CGFloat = 5
    private let merge_H: CGFloat = 5
    private let merge_V: CGFloat = 5
    private let titleHeight: CGFloat = 50
    private var imageHeight: CGFloat = 80
    private let tipHeight: CGFloat = 30
    
    private func setupSubviewsLayout() {
        self.contentView.removeConstraints(self.contentView.constraints)
        
        UIView.setupNeedLayout([titleLabel, originLabel, tipLabel, cancelBtn, bottomLine])
        
        let contentWidth: CGFloat = self.bounds.width - border_H * 2
        
        self.titleLabel.autoLayoutTop(border_V, .equal)
        self.titleLabel.autoLayoutLeft(border_H, .equal)
        self.titleLabel.autoLayoutRight(-border_H, .equal)
        self.titleLabel.autoLayoutHeight(titleHeight, .equal)
        
        if self.imageSet.count > 0 {
            let count: CGFloat = 3
            let imageWidth: CGFloat = (contentWidth - merge_H * (count - 1)) / count
            self.imageHeight = imageWidth / 4 * 3
            for i in 0..<imageSet.count {
                self.imageSet[i].translatesAutoresizingMaskIntoConstraints = false
                self.imageSet[i].autoLayoutTopRelative(merge_V, .equal, titleLabel)
                self.imageSet[i].autoLayoutLeft(border_H + imageWidth * CGFloat(i), .equal)
                self.imageSet[i].autoLayoutWidth(imageWidth, .equal)
                self.imageSet[i].autoLayoutHeight(imageHeight, .equal)
            }
            
            self.originLabel.autoLayoutTopRelative(merge_V, .equal, imageSet[0])
        }else {
            self.originLabel.autoLayoutTopRelative(merge_V, .equal, titleLabel)
        }
        
        self.originLabel.autoLayoutLeft(border_H, .equal)
        self.originLabel.autoLayoutHeight(tipHeight, .equal)
        if let text = self.originLabel.text, let font = self.originLabel.font {
            let width: CGFloat = text.getWidth(font, tipHeight, contentWidth / 3)
            self.originLabel.autoLayoutWidth(width, .equal)
        }
        
        self.tipLabel.autoLayoutCenterY(0, .equal, originLabel)
        self.tipLabel.autoLayoutLeftRelative(merge_H, .equal, originLabel)
        self.tipLabel.autoLayoutHeight(tipHeight, .equal)
        self.tipLabel.autoLayoutRightRelative(-merge_H, .equal, cancelBtn)
        
        self.cancelBtn.autoLayoutCenterY(0, .equal, originLabel)
        self.cancelBtn.autoLayoutRight(-border_H, .equal)
        if let size = self.cancelBtn.imageView?.image?.size {
            self.cancelBtn.autoLayoutWidth(size.width, .equal)
            self.cancelBtn.autoLayoutHeight(size.height, .equal)
        }
        
        self.bottomLine.autoLayoutBottom(0, .equal)
        self.bottomLine.autoLayoutLeft(border_H, .equal)
        self.bottomLine.autoLayoutRight(-border_H, .equal)
        self.bottomLine.autoLayoutHeight(1, .equal)
    }
    
}
