//
//  XJJNewsTitleCell.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/20.
//

import UIKit

class XJJNewsTitleCell: UIView {
    
    var cellTapBlock: ((_ item: XJJNewsTitleCellItem?) -> Void)?
    
    var item: XJJNewsTitleCellItem? {
        didSet {
            guard let it = item else {return}
            self.updateUI(it)
        }
    }
    
    func selectItem(isSelect: Bool) {
        self.setupSelect(isSelect)
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
    
    private var textLabel: UILabel!
    private var imageView: UIImageView!
    private var lineView: UIView!
    private var lineColorLayer: CAGradientLayer?
    
    private var type: XJJNewsTitleCellItem.NType = .none
    private var isSelected: Bool?
    
    private func initUI() {
        self.initTap()
    }
    
    private func initTap() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapClick)))
    }
    
    @objc private func tapClick(_ tap: UITapGestureRecognizer) {
        self.cellTapBlock?(item)
    }
    
    private func updateUI(_ item: XJJNewsTitleCellItem) {
        self.type = item.type
        self.setupUI(item)
        self.setupSelect(item.isSelected)
    }
    
    private func setupUI(_ item: XJJNewsTitleCellItem) {
        switch type {
        case .text:
            self.initText(item)
        case .image:
            self.initImage(item)
        case .textAndImage(let orientation):
            self.initTextAndImage(item, orientation: orientation)
        case .none:
            break
        }
    }
    
    private func initText(_ item: XJJNewsTitleCellItem) {
        self.textLabel = UILabel()
        self.addSubview(textLabel)
        
        self.lineView = UIView()
        self.addSubview(lineView)
        
        self.textLabel.setText(item.text)
        self.setupLine(item.text)
    }
    
    private func setupLine(_ text: XJJText?) {
        guard let layer = text?.gradientLayer else {return}
        if let colors = layer.colors, colors.count > 1 {
            self.lineColorLayer = layer
            self.lineColorLayer?.startPoint = CGPoint(x: 0, y: 0.5)
            self.lineColorLayer?.endPoint = CGPoint(x: 1, y: 0.5)
            self.lineView.layer.addSublayer(lineColorLayer!)
        }else {
            self.lineView.backgroundColor = text?.color
        }
    }
    
    private func initImage(_ item: XJJNewsTitleCellItem) {
        self.imageView = UIImageView()
        self.addSubview(imageView)
        
        if let image = item.image {
            self.imageView.image = image
        }
        if let image = item.selectImage {
            self.imageView.highlightedImage = image
        }
    }
    
    private func initTextAndImage(_ item: XJJNewsTitleCellItem, orientation: XJJNewsTitleCellItem.NOrientation) {
        self.initImage(item)
        self.initText(item)
    }
        
    private func setupSelect(_ isSelect: Bool) {
        guard self.isSelected != isSelect else {return}
        self.isSelected = isSelect
        
        if self.textLabel != nil, let selectText = self.item?.selectText {
            self.textLabel.setText(isSelect ? selectText : self.item?.text)
        }
        if self.imageView != nil, self.imageView.highlightedImage != nil {
            self.imageView.isHighlighted = isSelect
        }
        if self.lineView != nil {
            self.lineView.isHidden = !isSelect
        }
    }
    
    private func setupSubviewsLayout() {
        switch type {
        case .text:
            self.textLabel.frame = self.bounds
            self.setupLineViewLayout(item?.text?.size.width ?? self.bounds.width)
        case .image:
            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            self.imageView.autoLayoutCenter(0, 0, .equal)
            self.imageView.autoLayoutWidth(item?.image?.size.width ?? self.bounds.width, .equal)
            self.imageView.autoLayoutHeight(item?.image?.size.height ?? self.bounds.height, .equal)
        case .textAndImage(let orientation):
            self.removeConstraints(self.constraints)
            
            var lineWidth: CGFloat = 0
            UIView.setupNeedLayout([textLabel, imageView])
            
            switch orientation {
            case .left:
                self.textLabel.autoLayoutCenterY(0, .equal)
                self.textLabel.autoLayoutHeight(item?.text?.size.height ?? self.bounds.height, .equal)
                self.textLabel.autoLayoutLeft(item?.h_border ?? 10, .equal)
                self.textLabel.autoLayoutRightRelative(-(item?.h_merge ?? 5), .equal, imageView)
                
                self.imageView.autoLayoutCenterY(0, .equal)
                self.imageView.autoLayoutHeight(item?.image?.size.height ?? self.bounds.height, .equal)
                self.imageView.autoLayoutRight(-(item?.h_border ?? 10), .lessThanOrEqual)
                
                let textWidth = item?.text?.size.width ?? self.bounds.width / 2
                let imageWidth = item?.image?.size.width ?? self.bounds.width / 2
                lineWidth = textWidth + imageWidth
            case .right:
                self.imageView.autoLayoutCenterY(0, .equal)
                self.imageView.autoLayoutHeight(item?.image?.size.height ?? self.bounds.height, .equal)
                self.imageView.autoLayoutLeft(item?.h_border ?? 10, .equal)
                self.imageView.autoLayoutRightRelative(-(item?.h_merge ?? 5), .equal, textLabel)
                
                self.textLabel.autoLayoutCenterY(0, .equal)
                self.textLabel.autoLayoutHeight(item?.text?.size.height ?? self.bounds.height, .equal)
                self.textLabel.autoLayoutRight(-(item?.h_border ?? 10), .lessThanOrEqual)
                
                let textWidth = item?.text?.size.width ?? self.bounds.width / 2
                let imageWidth = item?.image?.size.width ?? self.bounds.width / 2
                lineWidth = textWidth + imageWidth
            case .up:
                self.textLabel.autoLayoutCenterX(0, .equal)
                self.textLabel.autoLayoutWidth(item?.text?.size.width ?? self.bounds.width, .equal)
                self.textLabel.autoLayoutTop(item?.v_border ?? 5, .equal)
                self.textLabel.autoLayoutBottomRelative(-(item?.v_merge ?? 3), .equal, imageView)
                
                self.imageView.autoLayoutCenterX(0, .equal)
                self.imageView.autoLayoutWidth(item?.image?.size.width ?? self.bounds.width, .equal)
                self.imageView.autoLayoutBottom(-(item?.v_border ?? 5), .lessThanOrEqual)
                
                lineWidth = item?.text?.size.width ?? self.bounds.width / 2
            case .down:
                self.imageView.autoLayoutCenterX(0, .equal)
                self.imageView.autoLayoutWidth(item?.image?.size.width ?? self.bounds.width, .equal)
                self.imageView.autoLayoutTop(item?.v_border ?? 5, .equal)
                self.imageView.autoLayoutBottomRelative(-(item?.v_merge ?? 3), .equal, textLabel)
                
                self.textLabel.autoLayoutCenterX(0, .equal)
                self.textLabel.autoLayoutWidth(item?.text?.size.width ?? self.bounds.width, .equal)
                self.textLabel.autoLayoutBottom(-(item?.v_border ?? 5), .lessThanOrEqual)
                
                lineWidth = item?.text?.size.width ?? self.bounds.width / 2
            case .center:
                self.imageView.autoLayoutCenter(0, 0, .equal)
                self.imageView.autoLayoutWidth(self.bounds.width, .equal)
                self.imageView.autoLayoutHeight(self.bounds.height, .equal)
                
                self.textLabel.autoLayoutCenter(0, 0, .equal)
                self.textLabel.autoLayoutWidth(self.bounds.width, .equal)
                self.textLabel.autoLayoutHeight(self.bounds.height, .equal)
                
                lineWidth = item?.text?.size.width ?? self.bounds.width
            }
            
            self.setupLineViewLayout(lineWidth)
        case .none:
            break
        }
    }
    
    private func setupLineViewLayout(_ lineWidth: CGFloat) {
        let lineHeight: CGFloat = 2
        var lineX: CGFloat = 0
        let border: CGFloat = 5
        
        switch item?.text?.alignment {
        case .left:
            lineX = border
        case .right:
            lineX = self.bounds.width - lineWidth - border
        case .center:
            lineX = self.bounds.width / 2 - lineWidth / 2
        default:
            break
        }
        
        self.lineView.frame = CGRect(x: lineX, y: self.bounds.height - lineHeight, width: lineWidth, height: lineHeight)
        self.lineColorLayer?.frame = self.lineView.bounds
    }

}
