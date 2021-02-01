//
//  XJJNavigationController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/1/28.
//

import UIKit

class XJJNavigationController: UINavigationController {
    
    var customPop: Bool = false // 是否自定义跳转，是 -- 点击返回按钮，不会pop到上个页面，需要自行跳转
    weak var eDelegate:  XJJNavigationDelegate? // 代理没有多余限制，用 block 需要建立 block 集合进行管理
    
    func setAttrTitle(_ text: String, controller: XJJBaseViewController? = nil) {
        if let ntext = XJJThemeConfig.config.theme.nav_text {
            self.textType = ntext.type
            switch ntext.type {
            case .text:
                controller?.navigationItem.title = text
                self.cLabel.attributedText = nil
            case .range:
                controller?.navigationItem.title = ""
                XJJThemeConfig.config.theme.nav_text?.text = text
                self.cLabel.attributedText = XJJThemeConfig.config.theme.nav_text?.rangeAttr
            case .designated:
                controller?.navigationItem.title = ""
                XJJThemeConfig.config.theme.nav_text?.text = text
                self.cLabel.attributedText = XJJThemeConfig.config.theme.nav_text?.designatedAttr
            }
        }
    }
    
    func setupTheme() {
        if let text = XJJThemeConfig.config.theme.nav_text {
            self.textType = text.type
            switch text.type {
            case .text:
                self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : text.color, NSAttributedString.Key.font : text.font]
            default:
                break
            }
        }
        if let image = XJJThemeConfig.config.theme.nav_image {
            self.navigationBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        }
        if let color = XJJThemeConfig.config.theme.nav_color {
            self.navigationBar.barTintColor = color
        }
        self.returnItem = XJJThemeConfig.config.theme.nav_return
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    // 重写初始化方法，根据需要重写
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var returnItem: XJJPageImageModel? // 返回图片
    private var textType: XJJText.TType = .text // 标题文字类型
    
    private var cLabel: UILabel!
    
    private func initUI() {
        self.modalPresentationStyle = .fullScreen
        self.navigationBar.isTranslucent = false
        self.setupTheme()
        
        let w_merge: CGFloat = self.navigationBar.bounds.width * 1 / 5
        self.cLabel = UILabel(frame: CGRect(x: w_merge, y: 0, width: w_merge * 3, height: self.navigationBar.bounds.height))
        self.cLabel.textAlignment = .center
        self.navigationBar.addSubview(cLabel)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let text = returnItem?.text {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: text.text, style: .done, target: self, action: #selector(back))
            viewController.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : text.color, NSAttributedString.Key.font : text.font], for: .normal)
        }else if let image = returnItem?.image {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(back))
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func back(_ item: UIBarButtonItem) {
        if customPop {
            self.eDelegate?.customPop?(self)
        }else {
            self.popViewController(animated: true)
            self.eDelegate?.defaultPop?(self)
        }
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

/// 使用须知：
/// 在使用 ENavigationDelegate 时，需要遵循协议，在进入其他正常界面前，将协议置空
/// ENavigationController 的 customPop 为 true 时， 不是 自动 pop，使用 func customPop(_ nav: ENavigationController)
/// ENavigationController 的 customPop 为 false 时， 自动 pop，使用 func defaultPop(_ nav: ENavigationController)
/// 一般情况下，一个

@objc protocol XJJNavigationDelegate: NSObjectProtocol {
    @objc optional func customPop(_ nav: XJJNavigationController)
    @objc optional func defaultPop(_ nav: XJJNavigationController)
}
