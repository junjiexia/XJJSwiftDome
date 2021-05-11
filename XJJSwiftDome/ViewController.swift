//
//  ViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/1.
//

import UIKit

class ViewController: XJJBaseViewController {
    
    struct TableInfo {
        var text: XJJText = XJJText()
        var id: String = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initUI()
        self.addRightImageItem(XJJImages.pause!)
        // Do any additional setup after loading the view.
    }
    
    override func rightItemAction(_ item: UIBarButtonItem) {
        let vc = TestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    private var table: UITableView!
    private var tableData: [TableInfo] = []
    
    private func initData() {
        self.page = .first
        
        if let text = XJJThemeConfig.share.theme.page_text[.randomText] {
            self.tableData.append(TableInfo(text: text.newText("打开主页"), id: "主页"))
            self.tableData.append(TableInfo(text: text.newText("切换主题"), id: "主题"))
        }
    }
    
    private func initUI() {
        self.initTable()
    }
        
    private func initTable() {
        self.table = UITableView(frame: CGRect.zero, style: .plain)
        self.view.addSubview(table)
        
        self.table.setupStyle()
        self.table.setupLine()
        self.table.delegate = self
        self.table.dataSource = self
    }
    
    private func updateUI() {
        self.tableData.removeAll()
        self.initData()
        self.table.reloadData()
    }
    
    override func setupSubviewsLayout() {
        self.table.frame = self.view.bounds
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
            cell?.selectionStyle = .none
        }
        
        let item = self.tableData[indexPath.row]
        cell?.textLabel?.setText(item.text)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.tableData[indexPath.row]
        self.gotoNext(id: item.id)
    }
    
    private func gotoNext(id: String) {
        switch id {
        case "主页":
            let vc = XJJMainViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case "主题":
            XJJSheet.sheet(on: self, "选择主题", ["默认主题", "新年主题"]) {[weak self] (index, text) in
                guard let sself = self else {return}
                switch text {
                case "默认主题":
                    XJJThemeConfig.share.switchTheme(style: .normal)
                    sself.updateUI()
                case "新年主题":
                    XJJThemeConfig.share.switchTheme(style: .xin_nian)
                    sself.updateUI()
                default:
                    break
                }
            }
        default:
            break
        }
    }
}

