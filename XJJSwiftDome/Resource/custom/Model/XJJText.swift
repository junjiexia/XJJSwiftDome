//
//  XJJText.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/1/28.
//

import Foundation
import UIKit

class XJJText {
    var type: TType = .text
    var text: String = ""
    var color: UIColor = UIColor.darkText
    var font: UIFont = UIFont.systemFont(ofSize: 15)
    
    // 按照顺序设置多个范围，定义多个不同颜色和字体的文本
    var rangeAttrArr: [TRange] = []
    var rangeAttr: NSAttributedString {
        get {
            return rangeAttrForText()
        }
    }
    
    // 设置特定字符，指定其颜色和字体，组成多个不同颜色和字体的文本
    var designatedAttrArr: [TDesignated] = []
    var designatedAttr: NSAttributedString {
        get {
            return designatedAttrForText()
        }
    }
    
    enum TType { // 文字类型
        case text // 字符串
        case range // 范围属性化字符串
        case designated // 特定属性化字符串
    }
    
    struct TRange {
        var index: Int = 0
        var count: Int = 0
        var color: UIColor = UIColor.darkText
        var font: UIFont = UIFont.systemFont(ofSize: 15)
    }
    
    struct TDesignated {
        var designated: String = ""
        var color: UIColor = UIColor.darkText
        var font: UIFont = UIFont.systemFont(ofSize: 15)
    }
    
    init() {}
    
    init(type color: UIColor?, font: UIFont?) { // 普通文字格式
        self.type = .text
        self.color = color ?? UIColor.darkText
        self.font = font ?? UIFont.systemFont(ofSize: 15)
    }
    
    init(rangeType attrArr: [TRange]) {
        self.type = .range
        self.rangeAttrArr = attrArr
    }
    
    init(designatedType attrArr: [TDesignated]) {
        self.type = .designated
        self.designatedAttrArr = attrArr
    }
    
    init(_ text: String, color: UIColor? = nil, font: UIFont? = nil) {
        self.type = .text
        self.text = text
        self.color = color ?? UIColor.darkText
        self.font = font ?? UIFont.systemFont(ofSize: 15)
    }
    
    init(range text: String, attrArr: [TRange]) {
        self.type = .range
        self.text = text
        self.rangeAttrArr = attrArr
    }
    
    init(designated text: String, attrArr: [TDesignated]) {
        self.type = .designated
        self.text = text
        self.designatedAttrArr = attrArr
    }
    
    /*
     此处 rangeAttrArr 中的 index + count 必须按照顺序填写，不得有重复交集
     */
    private func rangeAttrForText() -> NSAttributedString {
        let attrText: NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        if rangeAttrArr.count > 0, text.count > 0 {
            var index = 0
            for i in 0..<rangeAttrArr.count {
                let attr = rangeAttrArr[i]
                if attr.index != index {
                    if index + attr.index - 1 > text.count {
                        attrText.append(NSAttributedString(string: text.sub(index, text.count - 1 - index), attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]))
                        break
                    }else {
                        attrText.append(NSAttributedString(string: text.sub(index, attr.index - 1), attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]))
                        index = attr.index
                    }
                }
                
                if index + attr.count > text.count {
                    attrText.append(NSAttributedString(string: text.sub(index, text.count - 1 - index), attributes: [NSAttributedString.Key.foregroundColor: attr.color, NSAttributedString.Key.font: attr.font]))
                    break
                }else {
                    attrText.append(NSAttributedString(string: text.sub(attr.index, attr.count), attributes: [NSAttributedString.Key.foregroundColor: attr.color, NSAttributedString.Key.font: attr.font]))
                    index += attr.count
                }
                
                if i == rangeAttrArr.count - 1, index < text.count - 1 {
                    attrText.append(NSAttributedString(string: text.sub(index, text.count - 1 - index), attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]))
                }
            }
        }
        
        return attrText
    }
    
    private func designatedAttrForText() -> NSAttributedString {
        let attrText: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
        
        if designatedAttrArr.count > 0, text.count > 0 {
            for i in 0..<designatedAttrArr.count {
                let attr = designatedAttrArr[i]
                for i in 0..<text.characters().count {
                    let char = text.characters()[i]
                    if attr.designated.contains(char) {
                        attrText.replaceCharacters(in: NSRange(location: i, length: 1), with: NSAttributedString(string: String(char), attributes: [NSAttributedString.Key.foregroundColor: attr.color, NSAttributedString.Key.font: attr.font]))
                    }
                }
            }
        }
        
        return attrText
    }

}
