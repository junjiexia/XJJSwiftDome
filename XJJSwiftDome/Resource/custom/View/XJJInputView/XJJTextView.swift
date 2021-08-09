//
//  XJJTextView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/4.
//

import UIKit

enum XJJTextViewStyle {
    case normal // 普通，就一个输入框
    case title // 带有左边标题的输入框
}

class XJJTextViewItem {
    var titleText: XJJText?
    var text: XJJText?
    var style: XJJTextViewStyle = .normal
    
    init(normal text: XJJText) {
        self.style = .normal
        self.text = text
    }
    
    init(title titleText: XJJText, text: XJJText) {
        self.style = .title
        self.titleText = titleText
        self.text = text
    }
}

class XJJTextView: UIView {
    
    var textBlock: ((_ text: String) -> Void)?
    
    var item: XJJTextViewItem? {
        didSet {
            guard let _item = item else {return}
            self.setupUI(_item)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        self.textView.removeKeyboardNotification()
        super.removeFromSuperview()
    }
    
    private var titleLabel: UILabel!
    private var textView: UITextView!
    
    private var viewStyle: XJJTextViewStyle = .normal
    private let borderH: CGFloat = 16
    private let mergeH: CGFloat = 5
    private let textHeight: CGFloat = 30
    
    private func initUI() {
        self.backgroundColor = UIColor.white
        
        self.initTitle()
        self.initTextView()
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel)
    }
    
    private func initTextView() {
        self.textView = UITextView()
        self.addSubview(textView)
    
        self.textView.returnKeyType = .done
        self.textView.delegate = self
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.textView.layer.cornerRadius = 5
        self.textView.addKeyboardNotification()
    }
    
    private func setupUI(_ item: XJJTextViewItem) {
        self.viewStyle = item.style
        var textX: CGFloat = borderH
        
        if let text = item.titleText {
            self.titleLabel.setText(text)
            self.titleLabel.frame = CGRect(x: borderH, y: 0, width: text.size.width, height: textHeight)
            textX = titleLabel.frame.maxX + mergeH
        }
        
        if let text = item.text {
            self.textView.setText(text)
            self.textView.frame = CGRect(x: textX, y: 0, width: bounds.width - textX - borderH, height: bounds.height)
        }
    }
}

extension XJJTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.item?.text?.text = textView.text
        self.textBlock?(textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
