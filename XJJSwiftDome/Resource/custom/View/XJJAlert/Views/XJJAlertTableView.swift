//
//  XJJAlertTableView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/6.
//

import UIKit

class XJJAlertTableView: UIView {
    
    var selectBlock: ((_ item: XJJAlertTree) -> Void)?
    var multipleSelectBlock: ((_ items: [XJJAlertTree]) -> Void)?
    
    var multipleEnable: Bool = false
    var currentData: [XJJAlertTree] = []
    
    var titleText: XJJText? {
        didSet {
            guard let text = titleText else {return}
            self.setupTitle(text)
        }
    }
    
    var messageText: XJJText? {
        didSet {
            guard let text = messageText else {return}
            self.setupMessage(text)
        }
    }
    
    var lineColor: UIColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var titleLabel: UILabel!
    private var titleLine: UIView! // 标题下部隔断线
    private var tableView: UITableView!
    private var sureBtn: UIButton! // 确定
    private var selectAllBtn: UIButton! // 全选
    private var messageLabel: UILabel! // 消息
    private var messageLine: UIView! // 消息下部隔断线
    
    private var isTree: Bool = false // 是否是树结构
    private var ogzData: [XJJAlertTree] = [] // 原始数据
    private var tableData: [XJJAlertTree] = [] // 单层展示数据
    private var selectData: [XJJAlertTree] = [] // 多选的数据
    private var viewY: CGFloat = 0 // view 布局高度
    
    private func initUI() {
        self.setupUI()
        self.initTitle()
        self.initActions()
        self.initMessage()
        self.initTable()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel)
        
        self.titleLabel.numberOfLines = 0
        
        self.titleLine = UIView()
        self.addSubview(titleLine)
        
        self.titleLine.backgroundColor = lineColor
    }
    
    private func initActions() {
        self.selectAllBtn = UIButton(type: .custom)
        self.addSubview(selectAllBtn)
        
        self.selectAllBtn.setText(XJJText("全选", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 14)))
        self.selectAllBtn.setText(select: XJJText("取消全选", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 14)))
        self.selectAllBtn.addTarget(self, action: #selector(selectAllAction), for: .touchUpInside)
        
        self.sureBtn = UIButton(type: .custom)
        self.addSubview(sureBtn)
    
        self.sureBtn.setText(XJJText("确定", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 14)))
        self.sureBtn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
    }
    
    @objc private func selectAllAction(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected {
            self.setupSelectAll(ogzData)
        }else {
            self.setupDeselectAll(ogzData)
        }
        self.setupTableData()
    }
    
    @objc private func sureAction(_ btn: UIButton) {
        self.selectData.removeAll()
        self.setupSelectArr(ogzData)
        self.multipleSelectBlock?(selectData)
    }
    
    private func setupTitle(_ text: XJJText) {
        self.titleLabel.setText(text)
        
        var actionWidth: CGFloat = XJJAlert.borderH
        
        if multipleEnable {
            self.sureBtn.frame = CGRect(x: bounds.width - XJJAlert.borderH - XJJAlert.oneTextWidth * 2, y: XJJAlert.borderV, width: XJJAlert.oneTextWidth * 2, height: text.size.height)
            self.selectAllBtn.frame = CGRect(x: sureBtn.frame.minX - XJJAlert.mergeH - XJJAlert.oneTextWidth * 4, y: XJJAlert.borderV, width: XJJAlert.oneTextWidth * 4, height: text.size.height)
            actionWidth = XJJAlert.borderH + sureBtn.bounds.width + selectAllBtn.bounds.width + XJJAlert.mergeH * 2
        }
        
        self.titleLabel.frame = CGRect(x: XJJAlert.borderH, y: XJJAlert.borderV, width: bounds.width - XJJAlert.borderH - actionWidth, height: text.size.height)
        self.titleLine.frame = CGRect(x: 0, y: titleLabel.frame.maxY + XJJAlert.mergeV, width: bounds.width, height: XJJAlert.lineWidth)
        self.viewY = titleLine.frame.maxY
    }
    
    private func initMessage() {
        self.messageLabel = UILabel()
        self.addSubview(messageLabel)
        
        self.messageLabel.numberOfLines = 0
        
        self.messageLine = UIView()
        self.addSubview(messageLine)
        
        self.messageLine.backgroundColor = lineColor
    }
    
    private func setupMessage(_ text: XJJText) {
        self.messageLabel.setText(text)

        let width: CGFloat = bounds.width - XJJAlert.borderH * 2
        self.messageLabel.frame = CGRect(x: XJJAlert.borderH, y: viewY + XJJAlert.mergeV, width: width, height: text.textHeight(width))
        self.messageLine.frame = CGRect(x: 0, y: messageLabel.frame.maxY + XJJAlert.mergeV, width: bounds.width, height: XJJAlert.lineWidth)
        self.viewY = messageLine.frame.maxY
    }
    
    private func initTable() {
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.addSubview(tableView)
        
        self.tableView.setupStyle()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupTable(_ count: Int) {
        let height: CGFloat = isTree ? (XJJAlert.treeHeight - viewY) : min(XJJAlert.cellHeight * CGFloat(count), XJJAlert.tableMaxHeight)
        self.tableView.frame = CGRect(x: 0, y: viewY, width: bounds.width, height: height)
    }
}

//MARK: - 初始化数据
extension XJJAlertTableView {
    func reloadData(_ data: [XJJAlertTree], isTreeData: Bool? = false) {
        self.isTree = isTreeData!
        self.ogzData = data
        self.setupTable(data.count)
        if isTree {
            self.setupTableData()
        }else {
            self.tableData = data
            self.tableView.reloadData()
        }
    }
}

//MARK: - 更新数据
extension XJJAlertTableView {
    private func updateData(_ id: Int, isOpen: Bool? = nil, isSelect: Bool? = nil) {
        self.update(ogzData, id, id, isOpen: isOpen, isSelect: isSelect)
        self.setupTableData()
    }
    
    private func update(_ arr: [XJJAlertTree], _ id: Int, _ selectId: Int, isOpen: Bool? = nil, isSelect: Bool? = nil) {
        var select_id: Int = selectId
        var selectItem: XJJAlertTree?
        
        for item in arr {
            if item.id == id {
                if let _isOpen = isOpen { item.isOpen = _isOpen }
                if let _isSelect = isSelect { item.isSelect = _isSelect }
                                
                select_id = item.id
                selectItem = item
            }
            if item.parentId == selectId {
                if let _isSelect = isSelect { item.isSelect = _isSelect }
                
                select_id = item.id
            }
            
            if item.children.count > 0 {
                self.update(item.children, id, select_id, isOpen: isOpen, isSelect: isSelect)
            }
        }
        
        if let item = selectItem {
            self.checkSelectforParent(ogzData, item.parentId, item.deep)
        }
    }
    
    private func checkSelectforParent(_ arr: [XJJAlertTree], _ parentId: Int, _ deep: Int) {
        guard isTree else {return}
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

//MARK: - 选取数据
extension XJJAlertTableView {
    private func setupSelectArr(_ arr: [XJJAlertTree]) {
        for item in arr {
            if item.isSelect == true {
                self.selectData.append(item)
            }else {
                if item.children.count > 0 {
                    self.setupSelectArr(item.children)
                }
            }
        }
    }
    
    private func setupSelectAll(_ arr: [XJJAlertTree]) {
        for item in arr {
            if item.isSelect == false {
                item.isSelect = true
            }
            if item.isOpen == false {
                item.isOpen = true
            }
            if item.children.count > 0 {
                self.setupSelectAll(item.children)
            }
        }
    }
    
    private func setupDeselectAll(_ arr: [XJJAlertTree]) {
        for item in arr {
            if item.isSelect == true {
                item.isSelect = false
            }
            if item.isOpen == true {
                item.isOpen = false
            }
            if item.children.count > 0 {
                self.setupDeselectAll(item.children)
            }
        }
    }
    
    private func moveToSelectCell() {
        guard self.currentData.count > 0 else {return}
        let current = self.currentData[0]
        for i in 0..<self.tableData.count {
            if self.tableData[i].id == current.id {
                self.tableView.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: true)
                break
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
        
        cell?.isTree = isTree
        cell?.multipleEnable = multipleEnable
        
        let item = tableData[indexPath.row]
        cell?.item = item
        
        if !multipleEnable {
            cell?.accessoryType = item.isSelect == true ? .checkmark : .none
        }
        
        cell?.openClickBlock = {[weak self] isOpen in
            guard let sself = self else {return}
            sself.updateData(item.id, isOpen: isOpen)
        }
        
        cell?.selectClickBlock = {[weak self] isSelect in
            guard let sself = self else {return}
            sself.updateData(item.id, isSelect: isSelect)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return XJJAlert.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.multipleEnable {
            
        }else {
            let item = self.tableData[indexPath.row]
            
            if item.isSelect == nil {return}
            self.selectBlock?(item)
        }
    }
}

fileprivate class XJJAlertTableCell: UITableViewCell {
    var openClickBlock: ((_ isOpen: Bool) -> Void)?
    var selectClickBlock: ((_ isSelect: Bool) -> Void)?
    
    var isTree: Bool = false
    var multipleEnable: Bool = false
    
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
        self.openClickBlock?(!btn.isSelected)
    }
    
    private func initTitle() {
        self.titleLabel = XJJRHLabel()
        self.contentView.addSubview(titleLabel)
    }
    
    private func initRigthBtn() {
        self.rightBtn = UIButton(type: .custom)
        self.contentView.addSubview(rightBtn)
        
        self.rightBtn.setImage(XJJImages.noCheckWithBox, for: .normal)
        self.rightBtn.setImage(XJJImages.checkWithBox, for: .selected)
        self.rightBtn.addTarget(self, action: #selector(rightBtnAction), for: .touchUpInside)
    }
    
    @objc private func rightBtnAction(_ btn: UIButton) {
        self.selectClickBlock?(!btn.isSelected)
    }
    
    private func initLine() {
        self.lineView = UIView()
        self.contentView.addSubview(lineView)
        
        self.lineView.backgroundColor = XJJThemeConfig.share.theme.page_color[.tableLine]
    }
    
    private func setupUI(_ value: XJJAlertTree) {
        self.deep = value.deep
        
        var titleX: CGFloat = XJJAlert.borderH
        if isTree {
            self.openBtn.frame = CGRect(x: XJJAlert.borderH + XJJAlert.treeIndent * CGFloat(deep), y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
            titleX = openBtn.frame.maxX + XJJAlert.mergeH
        }
        
        if let open = value.isOpen {
            self.openBtn.isSelected = open
            self.openBtn.isHidden = false
        }else {
            self.openBtn.isHidden = true
        }
        
        if let select = value.isSelect {
            if multipleEnable {
                self.rightBtn.isSelected = select
                self.rightBtn.frame = CGRect(x: XJJAlert.contentWidth - XJJAlert.borderH - imageSize.width, y: (bounds.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
                self.titleLabel.frame = CGRect(x: titleX, y: 0, width: rightBtn.frame.minX - XJJAlert.mergeH - titleX, height: bounds.height)
            }else {
                self.titleLabel.frame = CGRect(x: titleX, y: 0, width: XJJAlert.contentWidth - XJJAlert.borderH - titleX, height: bounds.height)
            }
        }else {
            self.titleLabel.frame = CGRect(x: titleX, y: 0, width: XJJAlert.contentWidth - XJJAlert.borderH - titleX, height: bounds.height)
        }
        
        self.titleLabel.text = value.text
        
        self.lineView.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
    }
}
