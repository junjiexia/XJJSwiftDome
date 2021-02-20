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
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    private var first: XJJNewsViewController!
    private var second: XJJTimerViewController!
    private var third: XJJMyViewController!
    
    private func initUI() {
        self.tabBar.barTintColor = XJJThemeConfig.config.theme.bar_color
        
        self.first = XJJNewsViewController()
        self.setupChildViewController(first, image: UIImage(named: "icon_news"), selectedImage: UIImage(named: "icon_news_light"), title: "新闻")
        
        self.second = XJJTimerViewController()
        self.setupChildViewController(second, image: UIImage(named: "icon_timer"), selectedImage: UIImage(named: "icon_timer_light"), title: "定时器")
        
        self.third = XJJMyViewController()
        self.setupChildViewController(third, image: UIImage(named: "icon_my"), selectedImage: UIImage(named: "icon_my_light"), title: "我的")
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
