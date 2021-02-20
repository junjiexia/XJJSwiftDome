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
        // Do any additional setup after loading the view.
    }
        
    private var table: UITableView!
    private var tableData: [TableInfo] = []
    
    private func initData() {
        let factor = XJJText.TRandom(fontSize: (14, 15), fontArr: ["HYQinChuanFeiYingW", "JSuHunTi"])
        self.tableData = [TableInfo(text: XJJText(random: "打开主页", factor: factor), id: "主页")]
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
        default:
            break
        }
    }
}

