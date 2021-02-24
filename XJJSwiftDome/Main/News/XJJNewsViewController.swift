//
//  XJJNewsViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/5.
//

import UIKit

class XJJNewsViewController: XJJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    private var newsView: XJJNewsView!
    private var titleData: [XJJNewsTitleCellItem] = []
    
    private func initData() {
        let text = XJJThemeConfig.config.theme.page_text[XJJPageText.newsTitle]
        self.titleData = [
            XJJNewsTitleCellItem(text: XJJText("推荐", color: text?.color, font: text?.font, alignment: .center), isSelect: true),
            XJJNewsTitleCellItem(text: XJJText("体育", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("教育", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("政治", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("财经", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("旅游", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("美食", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("爱好", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("美化", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("建筑", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("开心一刻", color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText("猜你喜欢", color: text?.color, font: text?.font, alignment: .center))
        ]
    }
    
    private func initUI() {
        self.page = .news
    
        self.initNews()
    }
    
    private func initNews() {
        self.newsView = XJJNewsView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - XJJUIConfig.nav_h - XJJUIConfig.tab_h))
        self.view.addSubview(newsView)
        
        let scrollView = UIScrollView()
        scrollView.addDefaultRefreshAndLoad()
        scrollView.contentSize = CGSize(width: self.newsView.bounds.width, height: self.newsView.bounds.height + 200)
        
        self.newsView.setup(titles: titleData, contents: [scrollView])
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
