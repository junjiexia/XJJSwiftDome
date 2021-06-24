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
        
        // setTitleTextAttributes 设置为 .highlighted 会有警告，改为 .selected
        navVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : text.color, NSAttributedString.Key.font: text.font], for: .normal)
        navVC.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : text_h.color, NSAttributedString.Key.font: text_h.font], for: .selected)
        
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
    
    override var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return self.selectedViewController
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.selectedViewController
    }

    // 需要自动旋转 true
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? true
    }
    
    // 支持屏幕显示方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

}
