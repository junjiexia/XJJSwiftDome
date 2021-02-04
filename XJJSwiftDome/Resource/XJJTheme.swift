//
//  XJJTheme.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/1/27.
//

import Foundation
import UIKit

enum XJJThemeStyle: String { // 主题类型  主题key = 主题名称
    case normal = "默认主题"
    case xin_nian = "新年主题"
}

enum XJJPage: String { // 页面  页面key = 页面名称
    case first = "首页"
}

enum XJJPageText: String { // 页面文字格式 文字格式key = 文字格式说明
    case text = "正文"
}

enum XJJPageIcon: String { // 页面图片  图片key = 图片名称
    case icon = "icon"
}

struct XJJPageImageModel { // 单个控件图片模型
    var text: XJJText? // 图片文字
    var icon: XJJPageIcon? // 图片索引
    var image: UIImage? {
        get {
            return icon != nil ? UIImage(named: icon!.rawValue) : nil
        }
    }
}

class XJJTheme {
    
    var style: XJJThemeStyle = .normal // 类型
    // 导航
    var nav_image: UIImage? // 导航背景图
    var nav_color: UIColor? // 导航背景颜色
    var nav_text: XJJText? // 导航标题文字格式
    var nav_return: XJJPageImageModel? // 导航返回按钮
    
    // 底部工具栏
    var bar_image: UIImage? // 底部工具栏背景图
    var bar_color: UIColor? // 底部工具栏背景颜色
    var bar_item: [XJJPageImageModel] = [] // 底部工具栏按钮
    
    // 页面
    var page_text: [XJJPageText: XJJText] = [:] // 页面默认文字格式组，使用时通过key获取对应的文字格式
    var page_image: [XJJPage: [XJJPageImageModel]] = [:] // 页面合集，页面与该页面的图片对应
    
    init() {}
}

final class XJJThemeConfig {
    static let config = XJJThemeConfig()
    
    var theme: XJJTheme = XJJTheme()
    
    init() {
        self.theme.nav_text = XJJText(rangeType: [XJJText.TRange(index: 0, count: 1, color: UIColor.red, font: UIFont(name: "JSuHunTi", size: 20)!), XJJText.TRange(index: 1, count: 1, color: UIColor.blue, font: UIFont(name: "JSuHunTi", size: 20)!)])
        self.theme.nav_image = nil
        self.theme.nav_color = nil
        self.theme.nav_return = nil
        self.theme.bar_item = []
        self.theme.bar_color = nil
        self.theme.bar_image = nil
        self.theme.page_text =  [
            XJJPageText.text: XJJText(type: nil, font: nil)
        ]
        self.theme.page_image = [
            XJJPage.first: []
        ]
    }
}



