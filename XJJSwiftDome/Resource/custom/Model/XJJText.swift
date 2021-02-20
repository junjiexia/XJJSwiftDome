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
    
    // 每个文字，随机颜色和字体显示
    var randomFactor: TRandom? // 随机因子
    var randomAttr: NSAttributedString {
        get {
            return randomAttrForText()
        }
    }
    var wholeRandomAttr: NSAttributedString {
        get {
            return wholeRandomAttrForText()
        }
    }
    
    enum TType { // 文字类型
        case text // 字符串
        case range // 范围属性化字符串
        case designated // 特定属性化字符串
        case random // 随机颜色和字体
        case wholeRandom // 整体随机颜色和字体
    }
    
    struct TRange {
        var index: Int = 0 // 位置
        var count: Int = 0 // 数量
        var color: UIColor = UIColor.darkText
        var font: UIFont = UIFont.systemFont(ofSize: 15)
    }
    
    struct TDesignated {
        var designated: String = "" // 目标文字
        var color: UIColor = UIColor.darkText
        var font: UIFont = UIFont.systemFont(ofSize: 15)
    }
    
    struct TRandom {
        var fontSize: (Int, Int) = (10, 15) // 字体最小值，最大值
        var fontArr: [String] = [] // 字体名称数组
        var redColorRange: (Int, Int) = (0, 256) // 红色最小值，最大值
        var greenColorRange: (Int, Int) = (0, 256) // 绿色最小值，最大值
        var blueColorRange: (Int, Int) = (0, 256) // 蓝色最小值，最大值
        var alphaRange: (CGFloat, CGFloat) = (1, 1) // 透明度最小值，最大值
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
    
    init(random factor: TRandom) {
        self.type = .random
        self.randomFactor = factor
    }
    
    init(wholeRandom factor: TRandom) {
        self.type = .wholeRandom
        self.randomFactor = factor
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
    
    init(random text: String, factor: TRandom) {
        self.type = .random
        self.text = text
        self.randomFactor = factor
    }
    
    init(wholeRandom text: String, factor: TRandom) {
        self.type = .wholeRandom
        self.text = text
        self.randomFactor = factor
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
    
    private func randomAttrForText() -> NSAttributedString {
        let attrText: NSMutableAttributedString = NSMutableAttributedString(string: "")
        
        if let random = randomFactor {
            
            _ = self.text.map({
                let redDiff = random.redColorRange.1 - random.redColorRange.0
                let redColor = CGFloat(random.redColorRange.0 + (redDiff == 0 ? 0 : Int(arc4random()) % redDiff)) / 255.0
                let greedDiff = random.greenColorRange.1 - random.greenColorRange.0
                let greedColor = CGFloat(random.greenColorRange.0 + (greedDiff == 0 ? 0 : Int(arc4random()) % greedDiff)) / 255.0
                let blueDiff = random.blueColorRange.1 - random.blueColorRange.0
                let blueColor = CGFloat(random.blueColorRange.0 + (blueDiff == 0 ? 0 : Int(arc4random()) % (blueDiff))) / 255.0
                let alphaDiff = UInt32((random.alphaRange.1 - random.alphaRange.0) * 100)
                let alpha = random.alphaRange.0 + (alphaDiff == 0 ? 0 : CGFloat(arc4random() % alphaDiff) / 100.0)
                let random_color = UIColor(red: redColor, green: greedColor, blue: blueColor, alpha: alpha)
                
                let fontName = random.fontArr[Int(arc4random()) % random.fontArr.count]
                let sizeDiff = random.fontSize.1 - random.fontSize.0
                let fontSize = CGFloat(random.fontSize.0 + (sizeDiff == 0 ? 0 : Int(arc4random()) % sizeDiff))
                let random_font = UIFont(name: fontName, size: fontSize) ?? font
                
                attrText.append(NSAttributedString(string: String($0), attributes: [NSAttributedString.Key.foregroundColor: random_color, NSAttributedString.Key.font: random_font]))
            })
        }
        
        return attrText
    }

    private func wholeRandomAttrForText() -> NSAttributedString {
        
        if let random = randomFactor {
            let redDiff = random.redColorRange.1 - random.redColorRange.0
            let redColor = CGFloat(random.redColorRange.0 + (redDiff == 0 ? 0 : Int(arc4random()) % redDiff)) / 255.0
            let greedDiff = random.greenColorRange.1 - random.greenColorRange.0
            let greedColor = CGFloat(random.greenColorRange.0 + (greedDiff == 0 ? 0 : Int(arc4random()) % greedDiff)) / 255.0
            let blueDiff = random.blueColorRange.1 - random.blueColorRange.0
            let blueColor = CGFloat(random.blueColorRange.0 + (blueDiff == 0 ? 0 : Int(arc4random()) % (blueDiff))) / 255.0
            let alphaDiff = UInt32((random.alphaRange.1 - random.alphaRange.0) * 100)
            let alpha = random.alphaRange.0 + (alphaDiff == 0 ? 0 : CGFloat(arc4random() % alphaDiff) / 100.0)
            let random_color = UIColor(red: redColor, green: greedColor, blue: blueColor, alpha: alpha)
            
            let fontName = random.fontArr[Int(arc4random()) % random.fontArr.count]
            let sizeDiff = random.fontSize.1 - random.fontSize.0
            let fontSize = CGFloat(random.fontSize.0 + (sizeDiff == 0 ? 0 : Int(arc4random()) % sizeDiff))
            let random_font = UIFont(name: fontName, size: fontSize) ?? font
            
            return NSAttributedString(string: self.text, attributes: [NSAttributedString.Key.foregroundColor: random_color, NSAttributedString.Key.font: random_font])
        }else {
            return NSAttributedString(string: self.text, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
        }
    }
    
}

//MARK: - 相关扩展
extension UILabel {
    func setText(_ text: XJJText) {
        switch text.type {
        case .text:
            self.text = text.text
            self.attributedText = nil
            self.textColor = text.color
            self.font = text.font
        case .range:
            self.text = ""
            self.attributedText = text.rangeAttr
        case .designated:
            self.text = ""
            self.attributedText = text.designatedAttr
        case .random:
            self.text = ""
            self.attributedText = text.randomAttr
        case .wholeRandom:
            self.text = ""
            self.attributedText = text.wholeRandomAttr
        }        
    }
}

extension UIButton {
    func setText(_ text: XJJText) {
        switch text.type {
        case .text:
            self.setTitle(text.text, for: .normal)
            self.setTitleColor(text.color, for: .normal)
            self.titleLabel?.font = text.font
            self.titleLabel?.attributedText = nil
        case .range:
            self.setTitle("", for: .normal)
            self.setAttributedTitle(text.rangeAttr, for: .normal)
        case .designated:
            self.setTitle("", for: .normal)
            self.setAttributedTitle(text.designatedAttr, for: .normal)
        case .random:
            self.setTitle("", for: .normal)
            self.setAttributedTitle(text.randomAttr, for: .normal)
        case .wholeRandom:
            self.setTitle("", for: .normal)
            self.setAttributedTitle(text.wholeRandomAttr, for: .normal)
        }
    }
}
