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
    case test = "我爱你520"
}

enum XJJPageText: String { // 页面文字格式 文字格式key = 文字格式说明
    case text = "正文"
}

enum XJJPageIcon: String { // 页面图片  图片key = 图片名称
    case icon = "icon"
}

struct XJJPageModel { // 单个页面模型
    var nav_image: UIImage? // 导航背景图
    var nav_color: UIColor? // 导航背景颜色
    var nav_title: XJJText? // 导航标题
    var nav_text: XJJText? // 导航文字
    var nav_return: XJJPageImageModel? // 导航返回按钮
}

struct XJJPageImageModel { // 图片模型
    var text: XJJText? // 图片文字
    var image: UIImage? // 图片
}

//MARK: - 主题模型
/*
 1. 导航和底部工具栏都有通用格式
 2. 导航首先查找 page_item 中对应页面的内容，如果没有则使用通用格式
 3. 按钮都为 [XJJPageIcon: XJJPageImageModel] 格式，根据 XJJPageIcon 查找对应按钮信息
 4. 资源整合中，文字格式为 [XJJPageText: XJJText]，根据 XJJPageText 查找对应文字信息
 */
class XJJTheme {
    var style: XJJThemeStyle = .normal // 类型
    // 导航
    var nav_image: UIImage? // 导航背景图
    var nav_color: UIColor? // 导航背景颜色
    var nav_title: XJJText? // 导航标题
    var nav_text: XJJText? // 通用导航标题文字格式
    var nav_return: XJJPageImageModel? // 导航返回按钮
    
    // 底部工具栏
    var bar_image: UIImage? // 底部工具栏背景图
    var bar_color: UIColor? // 底部工具栏背景颜色
    var bar_icon: [XJJPageIcon: XJJPageImageModel] = [:] // 底部工具栏按钮
    
    // 资源整合
    var page_text: [XJJPageText: XJJText] = [:] // 默认文字格式集合，使用时通过key获取对应的文字格式
    var page_icon: [XJJPageIcon: XJJPageImageModel] = [:] // 图片集合
    
    // 页面
    var page_item: [XJJPage: XJJPageModel?] = [:] // 页面合集
    
    init() {}
}

final class XJJThemeConfig {
    static let config = XJJThemeConfig()
    
    var theme: XJJTheme = XJJTheme()
    
    init() {
        self.theme.nav_title = XJJText(rangeType: [XJJText.TRange(index: 0, count: 1, color: UIColor.red, font: UIFont(name: "JSuHunTi", size: 20)!), XJJText.TRange(index: 1, count: 1, color: UIColor.blue, font: UIFont(name: "JSuHunTi", size: 20)!)])
        self.theme.nav_text = XJJText(type: UIColor.darkText, font: UIFont.systemFont(ofSize: 14))
        self.theme.nav_image = nil
        self.theme.nav_color = nil
        self.theme.nav_return = XJJPageImageModel(text: nil, image: UIImage(named: "icon_return"))
        
        self.theme.bar_color = nil
        self.theme.bar_image = nil
        self.theme.bar_icon = [
            :
        ]
        
        self.theme.page_text =  [
            XJJPageText.text: XJJText(type: nil, font: nil)
        ]
        self.theme.page_icon = [
            :
        ]
        self.theme.page_item = [
            XJJPage.first: XJJPageModel(nav_image: nil,
                                        nav_color: nil,
                                        nav_title: XJJText(range: XJJPage.first.rawValue, attrArr: [XJJText.TRange(index: 0, count: 1, color: UIColor.red, font: UIFont(name: "HYQinChuanFeiYingW", size: 20)!), XJJText.TRange(index: 1, count: 1, color: UIColor.purple, font: UIFont(name: "HYQinChuanFeiYingW", size: 20)!)]),
                                        nav_text: XJJText(type: UIColor.blue, font: UIFont.systemFont(ofSize: 14)),
                                        nav_return: nil)
        ]
    }
}



