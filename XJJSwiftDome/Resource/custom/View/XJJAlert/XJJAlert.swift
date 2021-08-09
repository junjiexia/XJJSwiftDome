//
//  XJJAlert.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/7/29.
//

import Foundation
import UIKit

enum XJJAlertActionStyle {
    case H  // 一行显示所有btn
    case H2 // 一行显示2个btn，可显示多行
    case V  // 竖排显示
}

class XJJAlertItem {
    var index: Int = 0 // 序号
    var actionText: String = "" // 按钮文字
    var textFieldItems: [Text] = [] // 输入框
    var textViewItem: Text? // 文本框
    
    struct Text {
        var title: String = "" // 输入框标题
        var inputText: String = "" // 输入文本
    }
    
    init(_ index: Int, _ actionText: String, textFieldItems: [Text]? = nil) {
        self.index = index
        self.actionText = actionText
        self.textFieldItems = textFieldItems ?? []
    }
}

class XJJAlertTree {
    var id: Int = 0
    var parentId: Int = 0
    var text: XJJText?
    var isOpen: Bool?
    var isSelect: Bool?
    var deep: Int = 0
    var children: [XJJAlertTree] = []
    
    // 列表
    init(list id: Int, text: XJJText, isSelect: Bool? = nil) {
        self.id = id
        self.text = text
        self.isSelect = isSelect
    }
    
    // 树
    init(tree id: Int, text: XJJText, deep: Int, children: [XJJAlertTree]? = nil, isSelect: Bool? = nil) {
        self.id = id
        self.text = text
        self.deep = deep
        self.children = children ?? []
        self.isSelect = isSelect
        if let _children = children, _children.count > 0 {
            self.isOpen = true
        }
    }
}

class XJJAlert {
    static var ContentWidth: CGFloat = UIScreen.main.bounds.width / 4 * 3 // 弹框统一整体宽度
    static var contentX: CGFloat = (UIScreen.main.bounds.width - ContentWidth) / 2 // 弹框统一x
    static let lineWidth: CGFloat = 1.5 // 统一线宽
    static let borderH: CGFloat = 16 // 统一水平边距
    static let borderV: CGFloat = 15 // 统一垂直边距
    static let mergeH: CGFloat = 5 // 统一水平间隔
    static let mergeV: CGFloat = 15 // 统一垂直间隔
    static let textHeight: CGFloat = 25 // 统一文字高度
    static let btnHeight: CGFloat = 40 // 统一按钮高度
    static let textFieldHeight: CGFloat = 35 // 统一输入框高度
    static let textViewHeight: CGFloat = 150 // 统一文本输入框高度
    static let activityIndicatorWidth: CGFloat = 50 // 等待视图的宽度
    static let pickerHeight: CGFloat = 150 // 统一选择器高度
    static let treeIndent: CGFloat = 20 // 树结构展示的缩进
}

//MARK: - 连续无触发弹框 <Continuous no trigger>
extension XJJAlert {
    private static var cnt_alertArr: [UIView] = [] // 弹框视图数组
}
