//
//  XJJNewsTitleCellItem.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/20.
//

import Foundation
import UIKit

class XJJNewsTitleCellItem {
    
    enum NType { // 类型
        case none // 无类型
        case text // 文字
        case image // 图片
        case textAndImage(NOrientation) // 文字加图片
    }
    
    enum NOrientation { // 文字相对于图片的方位
        case left // 文字在图片左边
        case right // 文字在图片右边
        case up // 文字在图片上边
        case down // 文字在图片下边
        case center // 文字在图片中间，图片作为背景图
    }
    
    var type: NType = .none // 单元格类型
    
    var id: Int = -1 // 标识ID
    var text: XJJText? // 文字
    var selectText: XJJText? // 选中时的文字
    var image: UIImage? // 图片
    var selectImage: UIImage? // 选中时的图片
    var width_count: CGFloat = 1 // 单元格相对于标准单元格，宽度倍数
    var isSelected: Bool = false // 是否被选中
    
    // type == .textAndImage
    var h_merge: CGFloat = 5 // 文字和图片水平间距
    var v_merge: CGFloat = 3 // 文字和图片垂直间距
    var h_border: CGFloat = 10 // 文字或图片与单元格边缘，水平边距
    var v_border: CGFloat = 5 // 文字或图片与单元格边缘，垂直边距
    
    init() {}
    
    // 文字初始化
    init(text tx: XJJText, selectText: XJJText? = nil, widthCount: CGFloat? = nil, isSelect: Bool? = nil) {
        self.type = .text
        self.text = tx
        self.selectText = selectText
        self.width_count = widthCount ?? 1
        self.isSelected = isSelect ?? false
    }

    // 图片初始化
    init(image img: UIImage, selectImage: UIImage? = nil, widthCount: CGFloat? = nil, isSelect: Bool? = nil) {
        self.type = .image
        self.image = img
        self.selectImage = selectImage
        self.width_count = widthCount ?? 1
        self.isSelected = isSelect ?? false
    }
    
    // 图片加文字
    init(textAndImage text: XJJText, image: UIImage, selectText: XJJText? = nil, selectImage: UIImage? = nil, widthCount: CGFloat? = nil, isSelect: Bool? = nil, orientation: NOrientation? = nil, mergeH: CGFloat? = nil, mergeV: CGFloat? = nil, borderH: CGFloat? = nil, borderV: CGFloat? = nil) {
        self.type = .textAndImage(orientation ?? .left)
        self.text = text
        self.image = image
        self.selectText = selectText
        self.selectImage = selectImage
        self.width_count = widthCount ?? 1
        self.isSelected = isSelect ?? false
        self.h_merge = mergeH ?? 5
        self.v_merge = mergeV ?? 3
        self.h_border = borderH ?? 10
        self.v_border = borderV ?? 5
    }
}
