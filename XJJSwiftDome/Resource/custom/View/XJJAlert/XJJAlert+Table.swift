//
//  XJJAlert+Table.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/10.
//

import Foundation
import UIKit

extension XJJAlert {
    private static func tableHeight(cellCount: Int, title: XJJText? = nil, message: XJJText? = nil) -> CGFloat {
        var height: CGFloat = 0
        
        if let text = title {
            height += text.size.height + mergeV * 2 + lineWidth
        }
        if let text = message {
            height += text.textHeight(contentWidth - borderH * 2) + mergeV * 2 + lineWidth
        }
        height += min(cellHeight * CGFloat(cellCount), tableMaxHeight)
        
        return height
    }
    
    static func table(title: XJJText,
                      tableData: [XJJAlertTree],
                      message: XJJText? = nil,
                      cancelEnable: Bool? = true,
                      selectBlock: ((_ item: XJJAlertTree) -> Void)?,
                      cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let height = tableHeight(cellCount: tableData.count, title: title, message: message)
        let y = (UIScreen.main.bounds.height - height) / 2
        let tableView = XJJAlertTableView(frame: CGRect(x: contentX, y: y, width: contentWidth, height: height))
        
        tableView.titleText = title
        tableView.messageText = message
        tableView.reloadData(tableData, isTreeData: false)
        
        alertView.content = tableView
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
        }
        
        tableView.selectBlock = { item in
            selectBlock?(item)
            alertView.remove()
        }
    }
    
    static func multipleTable(title: XJJText,
                              tableData: [XJJAlertTree],
                              message: XJJText? = nil,
                              cancelEnable: Bool? = true,
                              multipleSelectBlock: ((_ items: [XJJAlertTree]) -> Void)?,
                              cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let height = tableHeight(cellCount: tableData.count, title: title, message: message)
        let y = (UIScreen.main.bounds.height - height) / 2
        let tableView = XJJAlertTableView(frame: CGRect(x: contentX, y: y, width: contentWidth, height: height))
        
        tableView.multipleEnable = true
        tableView.titleText = title
        tableView.messageText = message
        tableView.reloadData(tableData, isTreeData: false)
        
        alertView.content = tableView
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
        }
        
        tableView.multipleSelectBlock = { items in
            multipleSelectBlock?(items)
            alertView.remove()
        }
    }
    
    static func tree(title: XJJText,
                     tableData: [XJJAlertTree],
                     message: XJJText? = nil,
                     cancelEnable: Bool? = true,
                     selectBlock: ((_ item: XJJAlertTree) -> Void)?,
                     cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let y = (UIScreen.main.bounds.height - treeHeight) / 2
        let tableView = XJJAlertTableView(frame: CGRect(x: contentX, y: y, width: contentWidth, height: treeHeight))
        
        tableView.titleText = title
        tableView.messageText = message
        tableView.reloadData(tableData, isTreeData: true)
        
        alertView.content = tableView
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
        }
        
        tableView.selectBlock = { item in
            selectBlock?(item)
            alertView.remove()
        }
    }
    
    static func multipleTree(title: XJJText,
                             tableData: [XJJAlertTree],
                             message: XJJText? = nil,
                             cancelEnable: Bool? = true,
                             multipleSelectBlock: ((_ items: [XJJAlertTree]) -> Void)?,
                             cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let y = (UIScreen.main.bounds.height - treeHeight) / 2
        let tableView = XJJAlertTableView(frame: CGRect(x: contentX, y: y, width: contentWidth, height: treeHeight))
        
        tableView.multipleEnable = true
        tableView.titleText = title
        tableView.messageText = message
        tableView.reloadData(tableData, isTreeData: true)
        
        alertView.content = tableView
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
        }
        
        tableView.multipleSelectBlock = { items in
            multipleSelectBlock?(items)
            alertView.remove()
        }
    }
}
