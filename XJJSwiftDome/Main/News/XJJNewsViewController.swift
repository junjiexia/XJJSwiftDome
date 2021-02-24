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
        self.titleData = [
            XJJNewsTitleCellItem(image: UIImage(named: "icon_news")!, selectImage: UIImage(named: "icon_news_light"), widthCount: 0.8, isSelect: true),
            XJJNewsTitleCellItem(text: XJJText("推荐", color: UIColor.orange, font: UIFont(name: "HYQinChuanFeiYingW", size: 14), alignment: .center)),
            XJJNewsTitleCellItem(textAndImage: XJJText(random: "猜你喜欢", factor: XJJText.TRandom(fontSize: (14, 15), fontArr: ["HYQinChuanFeiYingW"])), image: UIImage(named: "icon_timer")!, selectImage: UIImage(named: "icon_timer_light"), widthCount: 1.5)
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
