//
//  XJJAlertTableView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/6.
//

import UIKit

class XJJAlertTableView: UIView {
    
    var ogzData: [XJJAlertTree] = []
    
    func reloadData() {
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var titleLabel: UILabel!
    private var tableView: UITableView!
    private var actionBtn: UIButton!
    
    private var tableData: [XJJAlertTree] = [] // 单层数据
    
    private func initUI() {
        self.setupUI()
        self.initTitle()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel)
    }
    
    private func initTable() {
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.addSubview(tableView)
        
        self.tableView.setupStyle()
        self.tableView.setupLine()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func updateData(_ id: Int, isOpen: Bool? = nil, isSelect: Bool? = nil) {
        self.update(ogzData, id, id, isOpen: isOpen, isSelect: isSelect)
        self.setupTableData()
    }
    
    private func update(_ arr: [XJJAlertTree], _ id: Int, _ selectId: Int, isOpen: Bool? = nil, isSelect: Bool? = nil) {
        var select_id: Int = 0
        
        for item in arr {
            if item.id == id {
                item.isOpen = isOpen
                item.isSelect = isSelect
                                
                select_id = item.id
                
                self.checkSelectforParent(ogzData, item.parentId, item.deep)
            }
            
            if item.parentId == selectId {
                item.isSelect = isSelect
                
                select_id = item.id
            }
            
            if item.children.count > 0 {
                self.update(item.children, id, select_id, isOpen: isOpen, isSelect: isSelect)
            }
        }
    }
    
    private func checkSelectforParent(_ arr: [XJJAlertTree], _ parentId: Int, _ deep: Int) {
        guard let parentItem = self.findParentItem(arr, parentId) else {return}
        
        var isParentSelect: Bool = true
        
        for item in parentItem.children {
            if item.isSelect == false {
                isParentSelect = false
            }
        }
        
        let isNeedChange: Bool = (parentItem.isSelect == true && !isParentSelect) || (parentItem.isSelect == false && isParentSelect)
        
        if isNeedChange {
            self.updateParentSelect(ogzData, parentItem.id, isParentSelect)
            if deep > 0 {
                self.checkSelectforParent(ogzData, parentItem.parentId, deep - 1)
            }
        }
    }
    
    private func updateParentSelect(_ arr: [XJJAlertTree], _ id: Int, _ isSelect: Bool) {
        for item in arr {
            if item.id == id {
                item.isSelect = isSelect
                break
            }else {
                self.updateParentSelect(item.children, id, isSelect)
            }
        }
    }
    
    private func findParentItem(_ arr: [XJJAlertTree], _ parentId: Int) -> XJJAlertTree? {
        var parentItem: XJJAlertTree? = nil
        
        for item in arr {
            if item.id == parentId {
                parentItem = item
                break
            }else {
                parentItem = self.findParentItem(item.children, parentId)
            }
        }
        
        return parentItem
    }
    
    private func setupTableData() {
        self.tableData.removeAll()
        self.setupTableDataItem(self.ogzData)
        self.tableView.reloadData()
    }
    
    private func setupTableDataItem(_ arr: [XJJAlertTree]) {
        for item in arr {
            self.tableData.append(item)
            if item.isOpen == true {
                self.setupTableDataItem(item.children)
            }
        }
    }
}

extension XJJAlertTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: XJJAlertTableCell.identifier) as? XJJAlertTableCell
        
        if cell == nil {
            cell = XJJAlertTableCell(style: .default, reuseIdentifier: XJJAlertTableCell.identifier)
            cell?.selectionStyle = .none
        }
        
        let item = tableData[indexPath.row]
        cell?.item = item
        
        cell?.openClickBlock = {[weak self] isOpen in
            guard let sself = self else {return}
            sself.tableData[indexPath.row].isOpen = isOpen
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

fileprivate class XJJAlertTableCell: UITableViewCell {
    var openClickBlock: ((_ isOpen: Bool) -> Void)?
    var selectClickBlock: ((_ isSelect: Bool) -> Void)?
    
    var item: XJJAlertTree? {
        didSet {
            guard let _item = item else {return}
            self.setupUI(_item)
        }
    }
    
    static let identifier: String = "XJJAlertTableCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var openBtn: UIButton!
    private var titleLabel: XJJRHLabel!
    private var rightBtn: UIButton!
    private var lineView: UIView!
    
    private var deep: Int = 0 // 深度
    private var imageSize: CGSize = CGSize(width: 30, height: 30)
    
    private func initUI() {
        self.backgroundColor = UIColor.white
        
        self.initOpen()
        self.initTitle()
        self.initRigthBtn()
        self.initLine()
    }
    
    private func initOpen() {
        self.openBtn = UIButton(type: .custom)
        self.contentView.addSubview(openBtn)
        
        self.openBtn.setImage(XJJImages.close, for: .normal)
        self.openBtn.setImage(XJJImages.open, for: .selected)
        self.openBtn.addTarget(self, action: #selector(openAction), for: .touchUpInside)
    }
    
    @objc private func openAction(_ btn: UIButton) {
        self.openClickBlock?(btn.isSelected)
    }
    
    private func initTitle() {
        self.titleLabel = XJJRHLabel()
        self.contentView.addSubview(titleLabel)
    }
    
    private func initRigthBtn() {
        self.rightBtn = UIButton(type: .custom)
        self.contentView.addSubview(rightBtn)
        
        self.rightBtn.setImage(XJJImages.noCheck, for: .normal)
        self.rightBtn.setImage(XJJImages.check, for: .selected)
        self.rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
    }
    
    @objc private func rightBtnAction(_ btn: UIButton) {
        self.selectClickBlock?(btn.isSelected)
    }
    
    private func initLine() {
        self.lineView = UIView()
        self.contentView.addSubview(lineView)
        
        self.lineView.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
        self.lineView.backgroundColor = XJJThemeConfig.share.theme.page_color[.tableLine]
    }
    
    private func setupUI(_ value: XJJAlertTree) {
        self.deep = value.deep
        self.openBtn.frame = CGRect(x: XJJAlert.borderH + XJJAlert.treeIndent * CGFloat(deep), y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        
        if let open = value.isOpen {
            self.openBtn.isSelected = open
            self.openBtn.isHidden = false
        }else {
            self.openBtn.isHidden = true
        }
        
        self.titleLabel.text = value.text
        if let select = value.isSelect {
            self.rightBtn.isSelected = select
            self.rightBtn.frame = CGRect(x: bounds.width - XJJAlert.borderH - imageSize.width, y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
            self.titleLabel.frame = CGRect(x: openBtn.frame.maxX + XJJAlert.mergeH, y: 0, width: rightBtn.frame.minX - XJJAlert.mergeH * 2 - openBtn.frame.maxX, height: bounds.height)
        }else {
            self.titleLabel.frame = CGRect(x: openBtn.frame.maxX + XJJAlert.mergeH, y: 0, width: bounds.width - openBtn.frame.maxX - XJJAlert.mergeH - XJJAlert.borderH, height: bounds.height)
        }
    }
}
