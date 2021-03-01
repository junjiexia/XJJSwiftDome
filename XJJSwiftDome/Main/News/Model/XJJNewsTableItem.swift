//
//  XJJNewsTableItem.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/26.
//

import Foundation
import UIKit

class XJJNewsTableItem: XJJNewsItem {
    
    var data: [XJJNewsTableSubItem] = [] // 列表数据
    
    init(id: XJJNewsItem.ID, data: [XJJNewsTableSubItem]) {
        super.init()
        self.id = id
        self.data = data
    }
}

class XJJNewsTableSubItem {
    var type: TType = .one // cell类型
    var titleText: XJJText? // 标题
    var imageArr: [UIImage] = [] // 图片数组
    var originText: XJJText? // 来源
    var tipText: XJJText? // 小提示
    
    var cellHeight: CGFloat = 44 // 单元格高度

    enum TType {
        case one
    }
    
    init(one title: XJJText, imageArr: [UIImage], origin: XJJText, tip: XJJText, cellHeight: CGFloat? = nil) {
        self.type = .one
        self.titleText = title
        self.imageArr = imageArr
        self.originText = origin
        self.tipText = tip
        self.cellHeight = cellHeight ?? 44
    }
}
