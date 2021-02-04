//
//  XJJBaseViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/1/28.
//

import UIKit

class XJJBaseViewController: UIViewController {
    
    var page: XJJPage? {
        didSet {
            guard let p = page else {return}
            self.setupPage(p)
        }
    }
    
    func addLeftTextItem(_ text: String) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: text, style: .done, target: self, action: #selector(leftItemAction))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: navText?.color ?? UIColor.darkText, NSAttributedString.Key.font: navText?.font ?? UIFont.systemFont(ofSize: 14)], for: .normal)
    }
    
    @objc func leftItemAction(_ item: UIBarButtonItem) {
        
    }
    
    func addRightTextItem(_ text: String) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: text, style: .done, target: self, action: #selector(rightItemAction))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: navText?.color ?? UIColor.darkText, NSAttributedString.Key.font: navText?.font ?? UIFont.systemFont(ofSize: 14)], for: .normal)
    }
    
    @objc func rightItemAction(_ item: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }
        
    private var pageItem: XJJPageModel? // 当前页面主题模型
    private var navText: XJJText? // 当前页面导航其他文字格式
    private var titleView: XJJNavigationTitleView! // 导航标题
    
    private func initUI() {
        self.view.backgroundColor = UIColor.white
        
        self.titleView = XJJNavigationTitleView()
        self.navigationItem.titleView = self.titleView
    }
    
    private func setupPage(_ page: XJJPage) {
        if let item = XJJThemeConfig.config.theme.page_item[page] {
            self.pageItem = item
            self.navText = item?.nav_text ?? XJJThemeConfig.config.theme.nav_text
        }else {
            self.navText = XJJThemeConfig.config.theme.nav_text
        }
        self.setAttrTitle(page.rawValue, pageItem: pageItem)
    }
    
    func setAttrTitle(_ text: String, pageItem: XJJPageModel? = nil) {
        if let navT = pageItem?.nav_title { // 特定文字格式
            self.titleView.text = navT
        }else {
            XJJThemeConfig.config.theme.nav_title?.text = text
            self.titleView.text = XJJThemeConfig.config.theme.nav_title
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
