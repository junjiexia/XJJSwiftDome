//
//  XJJNewsTableView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/24.
//

import UIKit

class XJJNewsTableView: UITableView {
    
    var data: XJJNewsTableItem? {
        didSet {
            self.setupData(data: data)
        }
    }
        
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.initData()
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableData: [XJJNewsTableSubItem] = []
    private let limit: Int = 10
    
    private func initData() {
        self.delegate = self
        self.dataSource = self
    }
    
    private func initUI() {
        self.setupStyle(backgroundColor: XJJThemeConfig.share.theme.page_color[.backgroud])
        self.addDefaultRefreshAndLoad(pageLimit: limit)
    }
    
    //MARK: -  下拉刷新
    override func refresh(_ control: XJJRefreshControl) {
        self.setupData(data: data)
        control.endRefresh()
    }
    
    private func setupData(data: XJJNewsTableItem?) {
        guard let _d = self.data else {return}
        self.tableData.removeAll()
        
        if _d.data.count > limit {
            for i in 0..<limit {
                self.tableData.append(_d.data[i])
            }
        }else {
            self.tableData = _d.data
        }
        
        self.reloadData()
    }
        
    //MARK: -  上拉加载
    override func loadMore(_ control: XJJLoadMoreControl) {
        self.updateData(control)
    }
    
    private func updateData(_ control: XJJLoadMoreControl) {
        guard let _d = self.data else {return}
        
        let diff = _d.data.count - tableData.count
        
        if diff >= limit {
            var arr: [XJJNewsTableSubItem] = []
            for i in 0..<limit {
                let index = self.tableData.count + i
                arr.append(_d.data[index])
            }
            
            self.tableData.append(contentsOf: arr)
            self.reloadData()
            control.endLoad(haveNew: true)
        }else if diff < limit, diff > 0 {
            var arr: [XJJNewsTableSubItem] = []
            for i in 0..<diff {
                let index = self.tableData.count + i
                arr.append(_d.data[index])
            }
            
            self.tableData.append(contentsOf: arr)
            self.reloadData()
            control.endLoad(haveNew: true)
        }else {
            control.endLoad(haveNew: false)
        }
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
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableData.count > indexPath.row {
            let item = self.tableData[indexPath.row]
            
            switch item.type {
            case .one:
                var tCell = tableView.dequeueReusableCell(withIdentifier: XJJNewsTableOneCell.identifier) as? XJJNewsTableOneCell
                if tCell == nil {
                    tCell = XJJNewsTableOneCell(style: .default, reuseIdentifier: XJJNewsTableOneCell.identifier)
                    tCell?.selectionStyle = .none
                }
                
                tCell?.titleText = item.titleText
                tCell?.originText = item.originText
                tCell?.tipText = item.tipText
                tCell?.images = item.imageArr
                
                return tCell!
            }
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "XJJNewsTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "XJJNewsTableViewCell")
            cell?.selectionStyle = .none
        }
        
        cell?.textLabel?.setText(XJJThemeConfig.share.theme.page_text[.randomText]?.newText("第\(indexPath.row)行"))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tableData.count > indexPath.row {
            let item = self.tableData[indexPath.row]
            switch item.type {
            case .one:
                return item.cellHeight
            }
        }
        
        return 50
    }
    
}
