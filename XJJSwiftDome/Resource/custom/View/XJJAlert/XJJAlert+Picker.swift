//
//  XJJAlert+Picker.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/5.
//

import Foundation
import UIKit

extension XJJAlert {
    private static func pickerViewHeight(number: XJJAlertPickerNumber) -> CGFloat {
        var height: CGFloat = 0
        
        switch number {
        case .single:
            height = XJJAlert.borderV + XJJAlert.textHeight + XJJAlert.pickerHeight + XJJAlert.btnHeight
        case .double:
            height = XJJAlert.borderV + XJJAlert.textHeight * 3 + XJJAlert.pickerHeight * 2 + XJJAlert.btnHeight
        }
        
        return height
    }
    
    static func datePicker(style: XJJAlertPickerStyle,
                           titleText: XJJText? = nil,
                           current: DateComponents? = nil,
                           sureText: XJJText? = nil,
                           cancelEnable: Bool? = true,
                           dateBlock: ((_ date: DateComponents) -> Void)?,
                           cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let height: CGFloat = pickerViewHeight(number: .single)
        let datePicker = XJJAlertPickerView(frame: CGRect(x: XJJAlert.contentX, y: (UIScreen.main.bounds.height - height) / 2, width: XJJAlert.ContentWidth, height: height))
        
        datePicker.create(date: style, number: .single, titleOne: titleText, sureText: sureText)
        datePicker.setCurrent(fristDate: current)
        
        alertView.content = datePicker
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
        }
        
        datePicker.sureDateBlock = { date, _ in
            dateBlock?(date)
            alertView.remove()
        }
    }
    
    static func doubleDatePicker(style: XJJAlertPickerStyle,
                                 firstText: XJJText? = nil,
                                 secondtext: XJJText? = nil,
                                 firstDate: DateComponents? = nil,
                                 secondDate: DateComponents? = nil,
                                 sureText: XJJText? = nil,
                                 cancelEnable: Bool? = true,
                                 dateBlock: ((_ first: DateComponents, _ second: DateComponents) -> Void)?,
                                 cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let height: CGFloat = pickerViewHeight(number: .double)
        let datePicker = XJJAlertPickerView(frame: CGRect(x: XJJAlert.contentX, y: (UIScreen.main.bounds.height - height) / 2, width: XJJAlert.ContentWidth, height: height))
        
        datePicker.create(date: style, number: .double, titleOne: firstText, titleTwo: secondtext, sureText: sureText)
        datePicker.setCurrent(fristDate: firstDate)
        datePicker.setCurrent(secondDate: secondDate)
        
        alertView.content = datePicker
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
        }
        
        datePicker.sureDateBlock = { first, second in
            dateBlock?(first, second)
            alertView.remove()
        }
    }
    
    static func picker(titleText: XJJText,
                       pickerArr: [[XJJText]],
                       current: [XJJText]? = nil,
                       sureText: XJJText? = nil,
                       cancelEnable: Bool? = true,
                       selectBlock: ((_ text: [XJJText]) -> Void)?,
                       cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let height: CGFloat = pickerViewHeight(number: .single)
        let picker = XJJAlertPickerView(frame: CGRect(x: XJJAlert.contentX, y: (UIScreen.main.bounds.height - height) / 2, width: XJJAlert.ContentWidth, height: height))
        picker.create(custom: .single, firstPickerData: pickerArr, titleOne: titleText, sureText: sureText)
        picker.setCurrent(current ?? [])
        
        alertView.content = picker
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
        }
        
        picker.sureBntClickBlock = { text, _ in
            selectBlock?(text)
            alertView.remove()
        }
    }
    
    static func doublePicker(titleText: XJJText,
                             pickerArr: [[XJJText]],
                             otherTitleText: XJJText,
                             otherPickerArr: [[XJJText]],
                             currentValue: [XJJText]? = nil,
                             otherValue: [XJJText]? = nil,
                             sureText: XJJText? = nil,
                             cancelEnable: Bool? = true,
                             selectBlock: ((_ text: [XJJText], _ other: [XJJText]) -> Void)?,
                             cancelBlock: (() -> Void)? = nil)
    {
        let alertView = XJJAlertBackgroundView(frame: UIScreen.main.bounds)
        alertView.cancelEnable = cancelEnable!
        
        let height: CGFloat = pickerViewHeight(number: .double)
        let picker = XJJAlertPickerView(frame: CGRect(x: XJJAlert.contentX, y: (UIScreen.main.bounds.height - height) / 2, width: XJJAlert.ContentWidth, height: height))
        picker.create(custom: .double, firstPickerData: pickerArr, secondPickerData: otherPickerArr, titleOne: titleText, titleTwo: otherTitleText, sureText: sureText)
        picker.setCurrent(currentValue ?? [], other: otherValue)
        alertView.content = picker
        
        XJJTools.keywindow?.addSubview(alertView)
        
        alertView.tapBlock = {
            cancelBlock?()
        }
        
        picker.sureBntClickBlock = { text, other in
            selectBlock?(text, other)
            alertView.remove()
        }
    }
}
