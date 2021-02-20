//
//  XJJMyViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/5.
//

import UIKit

class XJJMyViewController: XJJBaseViewController {

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
        XJJCheck.checkFont("JSuHunTi", perfectMatch: false)
        
        let factor = XJJText.TRandom(fontSize: (15, 15), fontArr: ["HYQinChuanFeiYingW"])
        self.tableData = [
            TableInfo(text: XJJText(wholeRandom: "退出主页", factor: factor), id: "退出主页")
        ]
    }
        
    private func initUI() {
        self.page = .my
        self.addRightTextItem("测试")
        
        self.initTable()
    }
    
    override func rightItemAction(_ item: UIBarButtonItem) {
        let vc = TestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension XJJMyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
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
        switch item.id {
        case "退出主页":
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
}
