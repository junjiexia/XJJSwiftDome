//
//  XJJNewsTableView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/24.
//

import UIKit

class XJJNewsTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.initData()
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initData() {
        self.setupStyle(backgroundColor: XJJThemeConfig.share.theme.page_color[.backgroud])
        self.setupLine(lineColor: XJJThemeConfig.share.theme.page_color[.tableLine])
        self.delegate = self
        self.dataSource = self
    }
    
    private func initUI() {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension XJJNewsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "XJJNewsTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "XJJNewsTableViewCell")
            cell?.selectionStyle = .none
        }
        
        cell?.textLabel?.setText(XJJThemeConfig.share.theme.page_text[.randomText]?.newText("第\(indexPath.row)行"))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
