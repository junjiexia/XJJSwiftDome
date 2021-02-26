//
//  XJJTabBarController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/5.
//

import UIKit

class XJJTabBarController: UITabBarController {
    
    func setupChildViewController(_ viewController: UIViewController, image: UIImage?, selectedImage: UIImage?, title: String) {
        
        let navVC = XJJNavigationController(rootViewController: viewController)
        
        // 让图片显示图片原始颜色  “UIImage” 后+ “.imageWithRenderingMode(.AlwaysOriginal)”
        navVC.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        
        let text = XJJThemeConfig.share.theme.bar_text
        let text_h = XJJThemeConfig.share.theme.bar_text_h
        navVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : text.color, NSAttributedString.Key.font: text.font], for: .normal)
        navVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : text_h.color, NSAttributedString.Key.font: text_h.font], for: .highlighted)
        
        self.addChild(navVC)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    private func initUI() {
        self.setupTheme()
    }
    
    func setupTheme() {
        self.tabBar.barTintColor = XJJThemeConfig.share.theme.bar_color
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
