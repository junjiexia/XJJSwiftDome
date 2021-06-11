//
//  XJJVideoLandscapeViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/6/2.
//

import UIKit

class XJJVideoLandscapeViewController: UIViewController {
    
    var playerView: XJJVideoPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.addNotification()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        //强制横屏
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        //强制竖屏
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        super.viewWillDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation = UIDevice.current.orientation
        
        coordinator.animate { context in
            switch orientation {
            case .landscapeLeft, .landscapeRight:
                self.playerView?.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                self.playerView?.bounds = self.view.bounds
            default:
                break
            }
        } completion: { context in
            switch orientation {
            case .landscapeLeft, .landscapeRight:
                self.playerView?.frame = self.view.bounds
            default:
                break
            }
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // 隐藏状态栏 false
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // 需要自动旋转 true
    override var shouldAutorotate: Bool {
        return true
    }
    
    // 支持屏幕显示方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    deinit {
        self.removeNotification()
        XJJVideo_print("- landscape VC - deinit!!!")
    }
    
    private func initUI() {
        self.view.backgroundColor = UIColor.black
    }
    
    private func addNotification() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func deviceOrientationChanged(_ noti: Notification) {
        
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    
    
}
