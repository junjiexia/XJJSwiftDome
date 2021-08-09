//
//  XJJTheme+XinNian.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/24.
//

import Foundation
import UIKit

extension XJJThemeConfig {
    
    func xinNianStyle() {
        let fontName: String = "HYQinChuanFeiYingW"
        
        self.theme.nav_title = XJJText(rangeType: [XJJText.TRange(index: 0, count: 1, color: UIColor.red, font: UIFont(name: fontName, size: 20)!), XJJText.TRange(index: 1, count: 1, color: UIColor.blue, font: UIFont(name: fontName, size: 20)!)])
        self.theme.nav_text = XJJText(type: UIColor.darkText, font: UIFont(name: fontName, size: 14))
        self.theme.nav_image = nil
        self.theme.nav_color = nil
        self.theme.nav_return = XJJPageIconModel(text: nil, image: UIImage(named: "icon_return"))
        
        self.theme.bar_color = nil
        self.theme.bar_image = nil
        self.theme.bar_text = XJJText(type: UIColor.lightGray, font: UIFont(name: fontName, size: 13))
        self.theme.bar_text_h = XJJText(type: UIColor.blue, font: UIFont(name: fontName, size: 13))
        self.theme.bar_icon = [
            XJJPageIcon.tabbar_icon1_0: XJJPageIconModel(text: nil, image: UIImage(named: "icon_news")),
            XJJPageIcon.tabbar_icon1_1: XJJPageIconModel(text: nil, image: UIImage(named: "icon_news_light")),
            XJJPageIcon.tabbar_icon2_0: XJJPageIconModel(text: nil, image: UIImage(named: "icon_timer")),
            XJJPageIcon.tabbar_icon2_1: XJJPageIconModel(text: nil, image: UIImage(named: "icon_timer_light")),
            XJJPageIcon.tabbar_icon3_0: XJJPageIconModel(text: nil, image: UIImage(named: "icon_my")),
            XJJPageIcon.tabbar_icon3_1: XJJPageIconModel(text: nil, image: UIImage(named: "icon_my_light"))
        ]
        
        self.theme.page_text =  [
            XJJPageText.title: XJJText(type: UIColor.blue, font: UIFont(name: fontName, size: 20)),
            XJJPageText.text: XJJText(type: UIColor.darkText, font: UIFont(name: fontName, size: 15)),
            XJJPageText.randomText: XJJText(randomType: XJJText.TRandom(fontSize: (14, 15), fontArr: [fontName])),
            XJJPageText.newsMenuTitle: XJJText(type: UIColor.blue, font: UIFont(name: fontName, size: 15))
        ]
        
        self.theme.page_icon = [
            XJJPageIcon.empty_image: XJJPageIconModel(text: nil, image: UIImage(named: "empty_Image")),
            XJJPageIcon.cross_image: XJJPageIconModel(text: nil, image: UIImage(named: "cross_image"))
        ]
        
        self.theme.page_color = [
            XJJPageColor.theme: #colorLiteral(red: 0.2274509804, green: 0.4549019608, blue: 0.6901960784, alpha: 1),
            XJJPageColor.backgroud: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
            XJJPageColor.tableLine: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),
            XJJPageColor.tip: #colorLiteral(red: 0.798948832, green: 0.815658381, blue: 1, alpha: 1),
            XJJPageColor.newsMenuBackgroud: #colorLiteral(red: 1, green: 0.8367277184, blue: 0.8067481887, alpha: 1)
        ]
        
        let randomColor = UIColor.randomColor
        self.theme.page_item = [
            XJJPage.first: XJJPageModel(nav_image: nil,
                                        nav_color: randomColor,
                                        nav_title: XJJText(XJJPage.first.rawValue, color: randomColor.invertColor, font: UIFont(name: fontName, size: 20)),
                                        nav_text: XJJText(type: randomColor.invertColor, font: UIFont(name: fontName, size: 14)),
                                        nav_return: nil),
            XJJPage.news: XJJPageModel(nav_image: UIImage(named: "navigation_background"),
                                        nav_color: nil,
                                        nav_title: XJJText(range: XJJPage.news.rawValue, attrArr: [XJJText.TRange(index: 0, count: 1, color: UIColor.red, font: UIFont(name: fontName, size: 20)!), XJJText.TRange(index: 1, count: 1, color: UIColor.orange, font: UIFont(name: fontName, size: 20)!)]),
                                        nav_text: XJJText(type: UIColor.white, font: UIFont(name: fontName, size: 14)),
                                        nav_return: nil),
            XJJPage.timer: XJJPageModel(nav_image: nil,
                                        nav_color: UIColor.orange,
                                        nav_title: XJJText(XJJPage.timer.rawValue, color: UIColor.orange.invertColor, font: UIFont(name: fontName, size: 20)),
                                        nav_text: XJJText(type: UIColor.orange.invertColor, font: UIFont(name: fontName, size: 14)),
                                        nav_return: nil),
            XJJPage.my: XJJPageModel(nav_image: UIImage(named: "navigation_background"),
                                        nav_color: nil,
                                        nav_title: XJJText(range: XJJPage.my.rawValue, attrArr: [XJJText.TRange(index: 0, count: 1, color: UIColor.red, font: UIFont(name: fontName, size: 20)!), XJJText.TRange(index: 1, count: 1, color: UIColor.orange, font: UIFont(name: fontName, size: 20)!)]),
                                        nav_text: XJJText(type: UIColor.white, font: UIFont(name: fontName, size: 14)),
                                        nav_return: nil),
            XJJPage.test: XJJPageModel(nav_image: nil,
                                       nav_color: UIColor.yellow,
                                       nav_title: XJJText(designated: XJJPage.test.rawValue, attrArr: [XJJText.TDesignated(designated: "0123456789", color: UIColor.purple, font: UIFont(name: fontName, size: 20)!), XJJText.TDesignated(designated: "我你他她", color: UIColor.green, font: UIFont(name: "HYQinChuanFeiYingW", size: 20)!), XJJText.TDesignated(designated: "爱", color: UIColor.red, font: UIFont.systemFont(ofSize: 14))]),
                                       nav_text: nil,
                                       nav_return: nil),
            XJJPage.alertList: XJJPageModel(nav_image: nil,
                                        nav_color: randomColor,
                                        nav_title: XJJText(XJJPage.alertList.rawValue, color: randomColor.invertColor, font: UIFont(name: fontName, size: 20)),
                                        nav_text: XJJText(type: randomColor.invertColor, font: UIFont(name: fontName, size: 14)),
                                        nav_return: nil)
        ]
    }
    
}
