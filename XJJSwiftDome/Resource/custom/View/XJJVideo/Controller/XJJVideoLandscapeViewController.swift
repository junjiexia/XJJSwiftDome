//
//  XJJVideoLandscapeViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/6/2.
//

import UIKit

/*
    * 横屏时，导航栏自动影藏
    * info.plist 中添加 View controller-based status bar appearance -- 控制App状态栏显隐接受全局（UIApplication设置）配置（NO）或者 各控制器各自配置（YES）
    *
 */

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
        self.playerView?.showStatus = true
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        //强制竖屏
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        self.playerView?.showStatus = false
        
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
    
    private var statusBarHidden: Bool  = false
    
    // 状态栏
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
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
        
        self.playerView?.showBorderBlock = {[weak self] isShow in
            guard let sself = self else {return}
            sself.statusBarHidden = !isShow
            sself.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private func addNotification() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(deviceBatteryChanged), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceBatteryChanged), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    @objc private func deviceBatteryChanged(_ noti: Notification) {
        let level = UIDevice.current.batteryLevel
        let state = UIDevice.current.batteryState
        let isLowPowerState = ProcessInfo.processInfo.isLowPowerModeEnabled
        self.playerView?.batteryValue = UIImage.Battery(value: level, state: state, isLowPowerState: isLowPowerState)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryStateDidChangeNotification, object: nil)
        UIDevice.current.isBatteryMonitoringEnabled = false
    }
    
    
    
}
