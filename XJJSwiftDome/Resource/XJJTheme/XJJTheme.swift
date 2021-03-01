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
    case first = "合集"
    case news = "新闻"
    case timer = "定时器"
    case my = "我的"
    case test = "我爱你520"
}

enum XJJPageText: String { // 页面文字格式 文字格式key = 文字格式说明
    case text = "正文"
    case randomText = "正文随机颜色、字体"
    case newsMenuTitle = "新闻标题"
}

enum XJJPageIcon: String { // 页面图片  图片key = 图片说明
    case empty_image = "默认空白图片"
    case cross_image = "取消图片"
    case tabbar_icon1_0 = "底部菜单第一项-普通状态"
    case tabbar_icon1_1 = "底部菜单第一项-高亮状态"
    case tabbar_icon2_0 = "底部菜单第二项-普通状态"
    case tabbar_icon2_1 = "底部菜单第二项-高亮状态"
    case tabbar_icon3_0 = "底部菜单第三项-普通状态"
    case tabbar_icon3_1 = "底部菜单第三项-高亮状态"
}

enum XJJPageColor: String { // 页面颜色  颜色key = 颜色用途说明
    case theme = "主题颜色"
    case backgroud = "背景色"
    case tableLine = "列表底部横线"
    case tip = "小提示"
    case newsMenuBackgroud = "新闻页面菜单栏背景色"
}

struct XJJPageModel { // 单个页面模型
    var nav_image: UIImage? // 导航背景图
    var nav_color: UIColor? // 导航背景颜色
    var nav_title: XJJText? // 导航标题
    var nav_text: XJJText? // 导航文字
    var nav_return: XJJPageIconModel? // 导航返回按钮
}

struct XJJPageIconModel { // 图片模型
    var text: XJJText? // 图片文字
    var image: UIImage? // 图片
    var highlightedText: XJJText? // 高亮文字
    var highlightedImage: UIImage? // 高亮图片
}

//MARK: - 主题模型
/*
 1. 导航和底部工具栏都有通用格式
 2. 导航首先查找 page_item 中对应页面的内容，如果没有则使用通用格式
 3. 按钮都为 [XJJPageIcon: XJJPageIconModel] 格式，根据 XJJPageIcon 查找对应按钮信息
 4. 资源整合中，文字格式为 [XJJPageText: XJJText]，根据 XJJPageText 查找对应文字信息
 */
final class XJJTheme {
    var style: XJJThemeStyle = .normal // 类型
    // 导航
    var nav_image: UIImage? // 导航背景图
    var nav_color: UIColor? // 导航背景颜色
    var nav_title: XJJText? // 导航标题
    var nav_text: XJJText? // 通用导航标题文字格式
    var nav_return: XJJPageIconModel? // 导航返回按钮
    
    // 底部工具栏
    var bar_image: UIImage? // 底部工具栏背景图
    var bar_color: UIColor? // 底部工具栏背景颜色
    var bar_text: XJJText = XJJText(type: UIColor.lightGray, font: UIFont.systemFont(ofSize: 12)) // 通用底部工具栏文字格式
    var bar_text_h: XJJText = XJJText(type: UIColor.blue, font: UIFont.systemFont(ofSize: 12)) // 通用底部工具栏高亮文字格式
    var bar_icon: [XJJPageIcon: XJJPageIconModel] = [:] // 底部工具栏按钮
    
    // 资源整合
    var page_text: [XJJPageText: XJJText] = [:] // 默认文字格式集合，使用时通过key获取对应的文字格式
    var page_icon: [XJJPageIcon: XJJPageIconModel] = [:] // 图片集合
    var page_color: [XJJPageColor: UIColor] = [:] // 颜色集合
    
    // 页面
    var page_item: [XJJPage: XJJPageModel?] = [:] // 页面合集
    
    init() {}
}

final class XJJThemeConfig {
    static let share: XJJThemeConfig = XJJThemeConfig()
    
    var theme: XJJTheme = XJJTheme()
    
    var needSaveThemeStyle: Bool = true
    
    private let themeStyleKey: String = "XJJThemeStyle"
    
    init() {
        if let themeStyleText = XJJFile.string(forKey: themeStyleKey) {
            if let themeStyle = XJJThemeStyle(rawValue: themeStyleText) {
                self.theme.style = themeStyle
            }
        }
        
        setupTheme()
    }
    
    func setupTheme() {
        switch theme.style {
        case .normal:
            normalStyle()
        case .xin_nian:
            xinNianStyle()
        }
    }
        
    func switchTheme(style: XJJThemeStyle) {
        XJJFile.save(stringValue: style.rawValue, forKey: themeStyleKey)
        switch style {
        case .normal:
            normalStyle()
        case .xin_nian:
            xinNianStyle()
        }
    }
}
