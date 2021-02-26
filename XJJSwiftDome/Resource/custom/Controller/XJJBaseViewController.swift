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
        self.initUI() // 在这里设置 frame 时，需要考虑手机安全区域问题，iPhone X 以上 需要减去导航和底部多出来的高度
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 使用 viewWillLayoutSubviews 或 viewDidLayoutSubviews 方法时，界面慎用自动布局，会造成 viewWillLayoutSubviews 和 viewDidLayoutSubviews 多次调用
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setupSubviewsLayout() // 在这里设置 frame 时，不用考虑手机安全区域的问题
    }
    
    func setupSubviewsLayout() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print((self.page?.rawValue ?? "未知") + "页面销毁")
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
        self.view.backgroundColor = XJJThemeConfig.share.theme.page_color[.backgroud]
        
        if let item = XJJThemeConfig.share.theme.page_item[page] {
            self.pageItem = item
            self.navText = item?.nav_text ?? XJJThemeConfig.share.theme.nav_text
        }else {
            self.navText = XJJThemeConfig.share.theme.nav_text
        }
        self.setAttrTitle(page.rawValue)
    }
    
    private func setAttrTitle(_ text: String) {
        if let navT = self.pageItem?.nav_title { // 特定文字格式
            self.titleView.text = navT
        }else {
            XJJThemeConfig.share.theme.nav_title?.text = text
            self.titleView.text = XJJThemeConfig.share.theme.nav_title
        }
    }
    
    private func setNavigationBackground() {
        guard let nItem = self.pageItem else {return}
        self.navigationController?.navigationBar.barTintColor = nItem.nav_color
        self.navigationController?.navigationBar.setBackgroundImage(nItem.nav_image, for: .any, barMetrics: .default)
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
