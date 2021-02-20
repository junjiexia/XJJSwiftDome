//
//  XJJTabBarController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/5.
//

import UIKit

class XJJTabBarController: UITabBarController {
    
    func setupChildViewController(_ viewController: UIViewController, image: UIImage?, selectedImage: UIImage?, title: NSString) {
        
        let navVC = XJJNavigationController(rootViewController: viewController)
        
        // 让图片显示图片原始颜色  “UIImage” 后+ “.imageWithRenderingMode(.AlwaysOriginal)”
        navVC.tabBarItem = UITabBarItem(title: title as String, image: image, selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        
        self.addChild(navVC)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
