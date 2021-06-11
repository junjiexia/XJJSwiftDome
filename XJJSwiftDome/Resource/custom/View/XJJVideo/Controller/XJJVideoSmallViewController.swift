//
//  XJJVideoSmallViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/6/9.
//

import UIKit

/*
    * 动画过度控制器（竖屏）
 */

class XJJVideoSmallViewController: UIViewController {
    
    var playerView: XJJVideoPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    // 隐藏状态栏 false
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // 需要自动旋转 true
    override var shouldAutorotate: Bool {
        return false
    }
    
    // 支持屏幕显示方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    deinit {
        
    }
    
    private func initUI() {
        
    }
    

}
