//
//  XJJAlert+Prompt.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/7/29.
//

import Foundation
import UIKit

//MARK: - 中心弹框
extension XJJAlert {
    private static func promptSize(title: XJJText? = nil, message: XJJText? = nil, headerImageSize: CGSize? = nil, textFieldCount: Int? = nil, textViewItem: XJJTextViewItem? = nil, actionCount: Int? = nil, actionStyle: XJJAlertActionStyle? = .H) -> CGSize {
        var size: CGSize = CGSize.zero
        let diffWidth: CGFloat = 15
        
        size.height = promptHeight(title: title, message: message, headerImageSize: headerImageSize, textFieldCount: textFieldCount, textViewItem: textViewItem, actionCount: actionCount, actionStyle: actionStyle)
        
        let isAdjustWidth: Bool = (title == nil && headerImageSize == nil && actionCount == nil) && (message != nil && ((message!.size.width + diffWidth) < XJJAlert.ContentWidth))
        
        if isAdjustWidth {
            size.width = (message?.size.width ?? 0) + diffWidth
            size.height += XJJAlert.mergeV
        }else {
            size.width = XJJAlert.ContentWidth
        }
                
        return size
    }
    
    private static func promptHeight(title: XJJText? = nil, message: XJJText? = nil, headerImageSize: CGSize? = nil, textFieldCount: Int? = nil, textViewItem: XJJTextViewItem? = nil, actionCount: Int? = nil, actionStyle: XJJAlertActionStyle? = .H) -> CGFloat {
        var height: CGFloat = 0
        
        // headImage
        if let size = headerImageSize {
            height += size.height * XJJAlert.ContentWidth / size.width + XJJAlert.lineWidth
        }
        if let text = title {
            height += text.size.height + XJJAlert.mergeV * 2 + XJJAlert.lineWidth
        }
        if let text = message {
            height += text.textHeight(XJJAlert.ContentWidth - XJJAlert.borderH * 2) + XJJAlert.mergeV * 2 + XJJAlert.lineWidth
        }
        if let count = textFieldCount {
            height += (XJJAlert.textFieldHeight + XJJAlert.mergeV) * CGFloat(count)
        }
        if textViewItem != nil {
            height += XJJAlert.textViewHeight + XJJAlert.mergeV
        }
        if let count = actionCount {
            switch actionStyle! {
            case .H:
                height += XJJAlert.btnHeight
            case .H2:
                let vCount = count / 2 + ((count % 2) > 0 ? 1 : 0)
                height += XJJAlert.btnHeight * CGFloat(vCount) + XJJAlert.lineWidth * CGFloat(vCount - 1)
            case .V:
                height += XJJAlert.btnHeight * CGFloat(count) + XJJAlert.lineWidth * CGFloat(count - 1)
            }
        }
        
        return height
    }
    
    //MARK: - normal prompt alert
    static func prompt(title: XJJText,
                       message: XJJText,
                       headerImage: UIImage? = nil,
                       actions: [XJJText]? = nil,
                       actionStyle: XJJAlertActionStyle? = .H,
                       cancelEnable: Bool? = true,
                       resultBlock: ((_ item: XJJAlertItem) -> Void)? = nil,
                       cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let promptHeight = promptHeight(title: title, message: message, headerImageSize: headerImage?.size, actionCount: actions?.count, actionStyle: actionStyle)
        let promptY = (UIScreen.main.bounds.height - promptHeight) / 2
        let promptView = XJJAlertPromptView(frame: CGRect(x: XJJAlert.contentX, y: promptY, width: XJJAlert.ContentWidth, height: promptHeight))
        
        promptView.headerImage = headerImage
        promptView.titleText = title
        promptView.messageText = message
        promptView.createActions(actions ?? [], style: actionStyle!)
        
        alertView.content = promptView
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
        }
        
        promptView.actionBlock = { item in
            resultBlock?(item)
            alertView.remove()
        }
    }
    
    //MARK: - state prompt alert
    static func statePrompt(title: XJJText?,
                            message: XJJText,
                            headerImage: UIImage? = nil,
                            dismissTime: TimeInterval? = 1.5,
                            cancelEnable: Bool? = false,
                            cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let promptSize = promptSize(title: title, message: message, headerImageSize: headerImage?.size)
        let promptX = (UIScreen.main.bounds.width - promptSize.width) / 2
        let promptY = (UIScreen.main.bounds.height - promptSize.height) / 2
        let promptView = XJJAlertPromptView(frame: CGRect(x: promptX, y: promptY, width: promptSize.width, height: promptSize.height))
        
        promptView.headerImage = headerImage
        promptView.titleText = title
        promptView.messageText = message
        
        alertView.content = promptView
        
        XJJTools.keywindow?.addSubview(alertView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissTime!) { // dismissTime 秒后消失
            alertView.remove()
        }
        
        alertView.tapBlock = {
            cancelBlock?()
        }
    }
    
    //MARK: - text field alert
    static func textField(title: XJJText,
                          message: XJJText,
                          textFields: [XJJTextFieldItem],
                          headerImage: UIImage? = nil,
                          actions: [XJJText]? = nil,
                          actionStyle: XJJAlertActionStyle? = .H,
                          cancelEnable: Bool? = false,
                          resultBlock: ((_ item: XJJAlertItem) -> Void)? = nil,
                          cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let promptHeight = promptHeight(title: title, message: message, headerImageSize: headerImage?.size, textFieldCount: textFields.count, actionCount: actions?.count, actionStyle: actionStyle)
        let promptY = (UIScreen.main.bounds.height - promptHeight) / 2
        let promptView = XJJAlertPromptView(frame: CGRect(x: XJJAlert.contentX, y: promptY, width: XJJAlert.ContentWidth, height: promptHeight))
        
        promptView.headerImage = headerImage
        promptView.titleText = title
        promptView.messageText = message
        promptView.addTextFields(textFields)
        promptView.createActions(actions ?? [], style: actionStyle!)
        
        alertView.content = promptView
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
            if cancelEnable == false {
                promptView.resignAllFirstResponder()
            }
        }
        
        promptView.actionBlock = { item in
            resultBlock?(item)
            alertView.remove()
        }
    }
    
    //MARK: - text view alert
    static func textView(title: XJJText,
                         message: XJJText,
                         textViewItem: XJJTextViewItem,
                         headerImage: UIImage? = nil,
                         actions: [XJJText]? = nil,
                         actionStyle: XJJAlertActionStyle? = .H,
                         cancelEnable: Bool? = false,
                         resultBlock: ((_ item: XJJAlertItem) -> Void)? = nil,
                         cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let promptHeight = promptHeight(title: title, message: message, headerImageSize: headerImage?.size, textViewItem: textViewItem, actionCount: actions?.count, actionStyle: actionStyle)
        let promptY = (UIScreen.main.bounds.height - promptHeight) / 2
        let promptView = XJJAlertPromptView(frame: CGRect(x: XJJAlert.contentX, y: promptY, width: XJJAlert.ContentWidth, height: promptHeight))
        
        promptView.headerImage = headerImage
        promptView.titleText = title
        promptView.messageText = message
        promptView.textViewItem = textViewItem
        promptView.createActions(actions ?? [], style: actionStyle!)
        
        alertView.content = promptView
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
            if cancelEnable == false {
                promptView.resignAllFirstResponder()
            }
        }
        
        promptView.actionBlock = { item in
            resultBlock?(item)
            alertView.remove()
        }
    }
}
