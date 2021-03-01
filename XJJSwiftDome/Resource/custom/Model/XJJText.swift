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
    var alignment: NSTextAlignment = .left
    
    var size: CGSize {
        get {
            return getTextSize()
        }
    }
    
    var gradientLayer: CAGradientLayer? {
        get {
            return getGradientLayer()
        }
    }
    
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
    var randomFactor: TRandom = TRandom() // 随机因子
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
    
    var totalRange: [TRange] = [] // 完整的分段
    
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
        var alignment: NSTextAlignment = .center
    }
    
    struct TDesignated {
        var designated: String = "" // 目标文字
        var color: UIColor = UIColor.darkText
        var font: UIFont = UIFont.systemFont(ofSize: 15)
        var alignment: NSTextAlignment = .center
    }
    
    struct TRandom {
        var fontSize: (Int, Int) = (10, 15) // 字体最小值，最大值
        var fontArr: [String] = [] // 字体名称数组
        var redColorRange: (Int, Int) = (0, 256) // 红色最小值，最大值
        var greenColorRange: (Int, Int) = (0, 256) // 绿色最小值，最大值
        var blueColorRange: (Int, Int) = (0, 256) // 蓝色最小值，最大值
        var alphaRange: (CGFloat, CGFloat) = (1, 1) // 透明度最小值，最大值
        var alignment: NSTextAlignment = .center
    }
    
    init() {}
    
    init(type color: UIColor?, font: UIFont?, alignment: NSTextAlignment? = nil) { // 普通文字格式
        self.type = .text
        self.color = color ?? UIColor.darkText
        self.font = font ?? UIFont.systemFont(ofSize: 15)
        self.alignment = alignment ?? .left
    }
    
    init(rangeType attrArr: [TRange]) {
        self.type = .range
        self.rangeAttrArr = attrArr
    }
    
    init(designatedType attrArr: [TDesignated]) {
        self.type = .designated
        self.designatedAttrArr = attrArr
    }
    
    init(randomType factor: TRandom) {
        self.type = .random
        self.randomFactor = factor
    }
    
    init(wholeRandomType factor: TRandom) {
        self.type = .wholeRandom
        self.randomFactor = factor
    }
    
    init(_ text: String, color: UIColor? = nil, font: UIFont? = nil, alignment: NSTextAlignment? = nil) {
        self.type = .text
        self.text = text
        self.color = color ?? UIColor.darkText
        self.font = font ?? UIFont.systemFont(ofSize: 15)
        self.totalRange = [TRange(index: 0, count: text.count, color: color ?? UIColor.darkText, font: font ?? UIFont.systemFont(ofSize: 15))]
        self.alignment = alignment ?? .left
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
        self.totalRange = []
        
        if rangeAttrArr.count > 0, text.count > 0 {
            var index = 0
            for i in 0..<rangeAttrArr.count {
                let attr = rangeAttrArr[i]
                if attr.index != index {
                    if index + attr.index - 1 > text.count {
                        attrText.append(NSAttributedString(string: text.sub(index, text.count - 1 - index), attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]))
                        self.totalRange.append(TRange(index: index, count: text.count - 1 - index, color: color, font: font))
                        break
                    }else {
                        attrText.append(NSAttributedString(string: text.sub(index, attr.index - 1), attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]))
                        self.totalRange.append(TRange(index: index, count: attr.index - 1, color: color, font: font))
                        index = attr.index
                    }
                }
                
                if index + attr.count > text.count {
                    attrText.append(NSAttributedString(string: text.sub(index, text.count - 1 - index), attributes: [NSAttributedString.Key.foregroundColor: attr.color, NSAttributedString.Key.font: attr.font]))
                    self.totalRange.append(TRange(index: index, count: text.count - 1 - index, color: attr.color, font: attr.font))
                    break
                }else {
                    attrText.append(NSAttributedString(string: text.sub(attr.index, attr.count), attributes: [NSAttributedString.Key.foregroundColor: attr.color, NSAttributedString.Key.font: attr.font]))
                    self.totalRange.append(TRange(index: attr.index, count: attr.count, color: attr.color, font: attr.font))
                    index += attr.count
                }
                
                if i == rangeAttrArr.count - 1, index < text.count - 1 {
                    attrText.append(NSAttributedString(string: text.sub(index, text.count - 1 - index), attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]))
                    self.totalRange.append(TRange(index: index, count: text.count - 1 - index, color: color, font: font))
                }
            }
        }
        
        return attrText
    }
    
    static let designatedAll: String = "~~~!!!@@@$$$%%%"
    static let numbers: String = "0123456789"
    
    private func designatedAttrForText() -> NSAttributedString {
        let attrText: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font])
        self.totalRange = text.map {[weak self] _ in
            guard let sself = self else {return TRange()}
            return TRange(index: 0, count: 1, color: sself.color, font: sself.font)
        }
        
        if designatedAttrArr.count > 0, text.count > 0 {
            self.designatedAttrArr.forEach {[weak self] in guard let sself = self else {return}; if $0.designated == XJJText.designatedAll { sself.color = $0.color; sself.font = $0.font } }
            
            for i in 0..<designatedAttrArr.count {
                let attr = designatedAttrArr[i]
                for i in 0..<text.characters().count {
                    let char = text.characters()[i]
                    if attr.designated.contains(char) {
                        attrText.replaceCharacters(in: NSRange(location: i, length: 1), with: NSAttributedString(string: String(char), attributes: [NSAttributedString.Key.foregroundColor: attr.color, NSAttributedString.Key.font: attr.font]))
                        self.totalRange[i].index = i
                        self.totalRange[i].color = attr.color
                        self.totalRange[i].font = attr.font
                    }
                }
            }
        }
        
        return attrText
    }
    
    private func randomAttrForText() -> NSAttributedString {
        let attrText: NSMutableAttributedString = NSMutableAttributedString(string: "")
        self.totalRange = []
        
        let factor = self.randomFactor
        let arr = self.text.characters()
        
        for i in 0..<arr.count {
            let tx = String(arr[i])
            
            let redDiff = factor.redColorRange.1 - factor.redColorRange.0
            let redColor = CGFloat(factor.redColorRange.0 + (redDiff == 0 ? 0 : Int(arc4random()) % redDiff)) / 255.0
            let greedDiff = factor.greenColorRange.1 - factor.greenColorRange.0
            let greedColor = CGFloat(factor.greenColorRange.0 + (greedDiff == 0 ? 0 : Int(arc4random()) % greedDiff)) / 255.0
            let blueDiff = factor.blueColorRange.1 - factor.blueColorRange.0
            let blueColor = CGFloat(factor.blueColorRange.0 + (blueDiff == 0 ? 0 : Int(arc4random()) % (blueDiff))) / 255.0
            let alphaDiff = UInt32((factor.alphaRange.1 - factor.alphaRange.0) * 100)
            let alpha = factor.alphaRange.0 + (alphaDiff == 0 ? 0 : CGFloat(arc4random() % alphaDiff) / 100.0)
            let random_color = UIColor(red: redColor, green: greedColor, blue: blueColor, alpha: alpha)
            
            let fontName = factor.fontArr[Int(arc4random()) % factor.fontArr.count]
            let sizeDiff = factor.fontSize.1 - randomFactor.fontSize.0
            let fontSize = CGFloat(factor.fontSize.0 + (sizeDiff == 0 ? 0 : Int(arc4random()) % sizeDiff))
            let random_font = UIFont(name: fontName, size: fontSize) ?? font
            
            attrText.append(NSAttributedString(string: tx, attributes: [NSAttributedString.Key.foregroundColor: random_color, NSAttributedString.Key.font: random_font]))
            self.totalRange.append(TRange(index: i, count: 1, color: random_color, font: random_font))
        }
        
        return attrText
    }

    private func wholeRandomAttrForText() -> NSAttributedString {
        
        let redDiff = randomFactor.redColorRange.1 - randomFactor.redColorRange.0
        let redColor = CGFloat(randomFactor.redColorRange.0 + (redDiff == 0 ? 0 : Int(arc4random()) % redDiff)) / 255.0
        let greedDiff = randomFactor.greenColorRange.1 - randomFactor.greenColorRange.0
        let greedColor = CGFloat(randomFactor.greenColorRange.0 + (greedDiff == 0 ? 0 : Int(arc4random()) % greedDiff)) / 255.0
        let blueDiff = randomFactor.blueColorRange.1 - randomFactor.blueColorRange.0
        let blueColor = CGFloat(randomFactor.blueColorRange.0 + (blueDiff == 0 ? 0 : Int(arc4random()) % (blueDiff))) / 255.0
        let alphaDiff = UInt32((randomFactor.alphaRange.1 - randomFactor.alphaRange.0) * 100)
        let alpha = randomFactor.alphaRange.0 + (alphaDiff == 0 ? 0 : CGFloat(arc4random() % alphaDiff) / 100.0)
        let random_color = UIColor(red: redColor, green: greedColor, blue: blueColor, alpha: alpha)
        
        let fontName = randomFactor.fontArr[Int(arc4random()) % randomFactor.fontArr.count]
        let sizeDiff = randomFactor.fontSize.1 - randomFactor.fontSize.0
        let fontSize = CGFloat(randomFactor.fontSize.0 + (sizeDiff == 0 ? 0 : Int(arc4random()) % sizeDiff))
        let random_font = UIFont(name: fontName, size: fontSize) ?? font
        
        self.totalRange = [TRange(index: 0, count: self.text.count, color: random_color, font: random_font)]
        return NSAttributedString(string: self.text, attributes: [NSAttributedString.Key.foregroundColor: random_color, NSAttributedString.Key.font: random_font])
    }
    
    private func getTextSize() -> CGSize {
        let _font = self.font
        switch type {
        case .text:
            return text.getSize(font)
        case .range:
            return text.getSize(rangeAttrArr.max { $0.font.pointSize > $1.font.pointSize }?.font ?? _font)
        case .designated:
            return text.getSize(designatedAttrArr.max { $0.font.pointSize > $1.font.pointSize }?.font ?? _font)
        case .random, .wholeRandom:
            return text.getSize(UIFont.systemFont(ofSize: CGFloat(randomFactor.fontSize.1)))
        }
    }
    
    private func getGradientLayer() -> CAGradientLayer? {
        let count = totalRange.count
        
        if count > 0 {
            let layer = CAGradientLayer()
            layer.colors = []
            layer.locations = []
            
            for i in 0..<count {
                layer.colors?.append(totalRange[i].color.cgColor)
                if i == 0, totalRange[i].index == 0 {
                    
                }else {
                    layer.locations?.append(NSNumber(floatLiteral: Double(totalRange[i].index) / Double(count)))
                }
            }

            layer.locations?.append(1.0)
            
            return layer
        }
        
        return nil
    }
}

extension XJJText: XJJCopyable {
    typealias T = XJJText
    
    func copy() -> XJJText {
        let obj = XJJText()
        
        obj.type = self.type
        obj.text = self.text
        obj.color = self.color
        obj.font = self.font
        obj.totalRange = self.totalRange
        obj.alignment = self.alignment
        
        obj.rangeAttrArr = self.rangeAttrArr
        obj.designatedAttrArr = self.designatedAttrArr
        obj.randomFactor = self.randomFactor
        
        return obj
    }
    
    func newText(_ text: String) -> XJJText {
        let new = self.copy()
        new.text = text
        return new
    }
}

//MARK: - 相关扩展
extension UILabel {
    func setText(_ text: XJJText?) {
        switch text?.type {
        case .text:
            self.attributedText = nil
            self.text = text?.text
            self.textColor = text?.color
            self.font = text?.font
            self.textAlignment = text?.alignment ?? .left
        case .range:
            self.text = ""
            self.attributedText = text?.rangeAttr
            self.textAlignment = text?.alignment ?? .center
        case .designated:
            self.text = ""
            self.attributedText = text?.designatedAttr
            self.textAlignment = text?.alignment ?? .center
        case .random:
            self.text = ""
            self.attributedText = text?.randomAttr
            self.textAlignment = text?.alignment ?? .center
        case .wholeRandom:
            self.text = ""
            self.attributedText = text?.wholeRandomAttr
            self.textAlignment = text?.alignment ?? .center
        case .none:
            break
        }
    }
}

extension UIButton {
    func setText(_ text: XJJText?) {
        switch text?.type {
        case .text:
            self.setAttributedTitle(nil, for: .normal)
            self.setTitle(text?.text, for: .normal)
            self.setTitleColor(text?.color, for: .normal)
            self.titleLabel?.font = text?.font
        case .range:
            self.setTitle("", for: .normal)
            self.setAttributedTitle(text?.rangeAttr, for: .normal)
        case .designated:
            self.setTitle("", for: .normal)
            self.setAttributedTitle(text?.designatedAttr, for: .normal)
        case .random:
            self.setTitle("", for: .normal)
            self.setAttributedTitle(text?.randomAttr, for: .normal)
        case .wholeRandom:
            self.setTitle("", for: .normal)
            self.setAttributedTitle(text?.wholeRandomAttr, for: .normal)
        case .none:
            break
        }
    }
}
