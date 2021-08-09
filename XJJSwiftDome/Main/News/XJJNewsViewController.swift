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
    private var contentViews: [UIView] = []
    
    private var dataSource: XJJNewsModel = XJJNewsModel()
    
    private func initData() {
        let text = XJJThemeConfig.share.theme.page_text[.newsMenuTitle]
        self.titleData = [
            XJJNewsTitleCellItem(text: XJJText(XJJNewsItem.ID.first.rawValue, color: text?.color, font: text?.font, alignment: .center), isSelect: true),
            XJJNewsTitleCellItem(text: XJJText(XJJNewsItem.ID.second.rawValue, color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText(XJJNewsItem.ID.third.rawValue, color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText(XJJNewsItem.ID.fourth.rawValue, color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText(XJJNewsItem.ID.fifth.rawValue, color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText(XJJNewsItem.ID.sixth.rawValue, color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText(XJJNewsItem.ID.seventh.rawValue, color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText(XJJNewsItem.ID.eighth.rawValue, color: text?.color, font: text?.font, alignment: .center)),
            XJJNewsTitleCellItem(text: XJJText(XJJNewsItem.ID.ninth.rawValue, color: text?.color, font: text?.font, alignment: .center))
        ]
        
        self.dataSource.getDataSource()
    }
    
    private func initUI() {
        self.page = .news
    
        self.initNews()
        self.updateData()
    }
    
    private func initNews() {
        self.newsView = XJJNewsView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - XJJUIConfig.nav_h - XJJUIConfig.tab_h))
        self.view.addSubview(newsView)
        
        let recommendTable = XJJNewsTableView(frame: CGRect.zero, style: .plain)
        recommendTable.tag = 1
        
        let sportsVideo = XJJNewsVideoView()
        sportsVideo.tag = 2
        
        self.contentViews = [recommendTable, sportsVideo]
        
        self.newsView.titleBackgroundColor = XJJThemeConfig.share.theme.page_color[.newsMenuBackgroud]
        self.newsView.setup(titles: titleData, contents: contentViews)
        self.newsView.pageMovedBlock = { index in
            sportsVideo.isViewAppeared = index == 1
        }
    }
    
    private func updateData() {
        guard self.contentViews.count > 0 else {return}
        
        for view in contentViews {
            switch view.tag {
            case 1:
                view.asView(XJJNewsTableView.self)?.data = dataSource.dataSource[.first]?.asTable()
            default:
                break
            }
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
