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
    
    var pageImageSet: [XJJPageImageModel] {
        get {
            return page != nil ? (XJJThemeConfig.config.theme.page_image[page!] ?? []) : []
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupPage(_ page: XJJPage) {
        if let navVC = self.navigationController as? XJJNavigationController {
            navVC.setAttrTitle(page.rawValue, controller: self)
        }
    }
    
    private func initUI() {
        self.view.backgroundColor = UIColor.white
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
