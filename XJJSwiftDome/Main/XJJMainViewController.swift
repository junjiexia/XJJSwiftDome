//
//  XJJMainViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/5.
//

import UIKit

class XJJMainViewController: XJJTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private var first: XJJNewsViewController = XJJNewsViewController()
    private var second: XJJTimerViewController = XJJTimerViewController()
    private var third: XJJMyViewController = XJJMyViewController()
    
    override func setupTheme() {
        self.setupChildViewController(first,
                                      image: XJJThemeConfig.share.theme.bar_icon[.tabbar_icon1_0]?.image,
                                      selectedImage: XJJThemeConfig.share.theme.bar_icon[.tabbar_icon1_1]?.image,
                                      title: "新闻")
        self.setupChildViewController(second,
                                      image: XJJThemeConfig.share.theme.bar_icon[.tabbar_icon2_0]?.image,
                                      selectedImage: XJJThemeConfig.share.theme.bar_icon[.tabbar_icon2_1]?.image,
                                      title: "定时器")
        self.setupChildViewController(third,
                                      image: XJJThemeConfig.share.theme.bar_icon[.tabbar_icon3_0]?.image,
                                      selectedImage: XJJThemeConfig.share.theme.bar_icon[.tabbar_icon3_1]?.image,
                                      title: "我的")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
