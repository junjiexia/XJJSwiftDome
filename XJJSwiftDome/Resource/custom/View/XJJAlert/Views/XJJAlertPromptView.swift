//
//  XJJAlertPromptView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/7/29.
//

import UIKit

class XJJAlertPromptView: UIView {
    
    var actionBlock: ((_ item: XJJAlertItem) -> Void)?
    
    var headerImage: UIImage? {
        didSet {
            guard let image = headerImage else {return}
            self.setupHeader(image)
        }
    }
    
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
    
    var textViewItem: XJJTextViewItem? {
        didSet {
            guard let item = textViewItem else {return}
            self.setupTextView(item)
        }
    }
    
    var lineColor: UIColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    
    func addTextFields(_ textArr: [XJJTextFieldItem]) {
        self.createTextFields(textArr)
    }
    
    func createActions(_ textArr: [XJJText], style: XJJAlertActionStyle) {
        self.buttonStyle = style
        self.createButtons(textArr)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //print("XJJAlertPromptView deinit !!")
    }
    
    private var headerImageView: UIImageView! // 顶部图片
    private var headerLine: UIView! // 顶部图片下部隔断线
    private var titleLabel: UILabel! // 标题
    private var titleLine: UIView! // 标题下部隔断线
    private var messageLabel: UILabel! // 消息
    private var textFieldArr: [XJJTextField] = [] // 输入框数组
    private var textView: XJJTextView! // 文本输入框
    private var messageLine: UIView! // 消息下部隔断线
    private var buttonArr: [UIButton] = [] // 按钮数组
    private var buttonHLines: [UIView] = [] // 按钮水平隔断线数组
    private var buttonVLines: [UIView] = [] // 按钮垂直隔断线数组
    
    private var buttonStyle: XJJAlertActionStyle = .H // 按钮分布类型
    private var viewY: CGFloat = 0 // view 布局高度
    
    private func initUI() {
        self.setupUI()
        self.initHeader()
        self.initTitle()
        self.initMessage()
        self.initTextView()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    private func initHeader() {
        self.headerImageView = UIImageView()
        self.addSubview(headerImageView)
        
        self.headerLine = UIView()
        self.addSubview(headerLine)
        
        self.headerLine.backgroundColor = lineColor
    }
    
    private func setupHeader(_ image: UIImage) {
        self.headerImageView.image = image
        self.headerImageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: bounds.width / image.size.width * image.size.height))
        self.headerLine.frame = CGRect(x: 0, y: headerImageView.frame.maxY, width: bounds.width, height: XJJAlert.lineWidth)
        self.viewY = headerLine.frame.maxY
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel)
        
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        
        self.titleLine = UIView()
        self.addSubview(titleLine)
        
        self.titleLine.backgroundColor = lineColor
    }
    
    private func setupTitle(_ text: XJJText) {
        self.titleLabel.setText(text)
        self.titleLabel.frame = CGRect(x: XJJAlert.borderH, y: viewY + XJJAlert.mergeV, width: bounds.width - XJJAlert.borderH * 2, height: text.size.height)
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
        self.messageLine.frame = CGRect(origin: CGPoint.zero, size: CGSize.zero)
        self.viewY = messageLabel.frame.maxY
    }
    
    private func createTextFields(_ arr: [XJJTextFieldItem]) {
        self.removeTextFields()
        
        if arr.count > 0 {
            let y = viewY + XJJAlert.mergeV
            
            for i in 0..<arr.count {
                let item = arr[i]
                
                let tf = XJJTextField(frame: CGRect(x: 0, y: y + (XJJAlert.textFieldHeight + XJJAlert.mergeV) * CGFloat(i), width: bounds.width, height: XJJAlert.textFieldHeight))
                tf.item = item
                
                self.addSubview(tf)
                self.textFieldArr.append(tf)
                
                if i == arr.count - 1 {
                    self.viewY = tf.frame.maxY
                }
            }
        }
    }
    
    private func removeTextFields() {
        if self.textFieldArr.count > 0 {
            self.textFieldArr.forEach { $0.removeFromSuperview() }
            self.textFieldArr.removeAll()
        }
    }
    
    private func initTextView() {
        self.textView = XJJTextView()
        self.addSubview(textView)
    }
    
    private func setupTextView(_ item: XJJTextViewItem) {
        self.textView.frame = CGRect(x: 0, y: viewY + XJJAlert.mergeV, width: bounds.width, height: XJJAlert.textViewHeight)
        self.textView.item = item
        self.viewY = textView.frame.maxY
    }
    
    private func createButtons(_ arr: [XJJText]) {
        self.removeButtons()
        
        if arr.count > 0 {
            self.messageLine.frame = CGRect(x: 0, y: viewY + XJJAlert.mergeV, width: bounds.width, height: XJJAlert.lineWidth)
            
            for i in 0..<arr.count {
                let text = arr[i]
                
                let btn = UIButton(type: .custom)
                btn.setTitle(text.text, for: .normal)
                btn.setTitleColor(text.color, for: .normal)
                btn.titleLabel?.font = text.font
                btn.tag = i + 1
                btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                self.addSubview(btn)
                self.buttonArr.append(btn)
                
                switch buttonStyle {
                case .H:
                    let width: CGFloat = (bounds.width - XJJAlert.lineWidth * CGFloat(arr.count - 1)) / CGFloat(arr.count)
                    btn.frame = CGRect(x: (width + XJJAlert.lineWidth) * CGFloat(i), y: messageLine.frame.maxY, width: width, height: XJJAlert.btnHeight)
                    if i > 0 {
                        let line = UIView(frame: CGRect(x: btn.frame.minX, y: btn.frame.minY, width: XJJAlert.lineWidth, height: btn.bounds.height))
                        line.backgroundColor = lineColor
                        
                        self.addSubview(line)
                        self.buttonHLines.append(line)
                    }
                case .H2:
                    let width: CGFloat = (bounds.width - XJJAlert.lineWidth) / 2
                    let section = i / 2
                    let row = i % 2
                    let oddNum = (arr.count % 2) > 0
                    let vCount = arr.count / 2 + (oddNum ? 1 : 0)
                    let x = (width + XJJAlert.lineWidth) * CGFloat(row)
                    let y = messageLine.frame.minY + XJJAlert.btnHeight * CGFloat(section)
                    
                    if i == arr.count - 1, oddNum { // 总数为单数时，最后一个占一整行
                        btn.frame = CGRect(x: x, y: y, width: bounds.width, height: XJJAlert.btnHeight)
                    }else {
                        btn.frame = CGRect(x: x, y: y, width: width, height: XJJAlert.btnHeight)
                    }
                    
                    if i > 0 {
                        let line = UIView()
                        line.backgroundColor = lineColor
                        
                        self.addSubview(line)
                        
                        if row > 0 {
                            line.frame = CGRect(x: width, y: btn.frame.minY, width: XJJAlert.lineWidth, height: btn.bounds.height)
                            self.buttonHLines.append(line)
                        }
                        if row == 0, section < vCount {
                            line.frame = CGRect(x: 0, y: btn.frame.minY, width: bounds.width, height: XJJAlert.lineWidth)
                            self.buttonVLines.append(line)
                        }
                    }
                case .V:
                    btn.frame = CGRect(x: 0, y: messageLine.frame.maxY + (XJJAlert.btnHeight + XJJAlert.lineWidth) * CGFloat(i), width: bounds.width, height: XJJAlert.btnHeight)
                    if i > 0 {
                        let line = UIView(frame: CGRect(x: 0, y: btn.frame.minY, width: bounds.width, height: XJJAlert.lineWidth))
                        line.backgroundColor = lineColor
                        
                        self.addSubview(line)
                        self.buttonVLines.append(line)
                    }
                }
            }
        }
    }
    
    @objc private func buttonAction(_ btn: UIButton) {
        let item = XJJAlertItem(btn.tag - 1, btn.currentTitle ?? "")
        if textFieldArr.count > 0 {
            item.textFieldItems = textFieldArr.map { XJJAlertItem.Text(title: $0.item?.titleText?.text ?? "", inputText: $0.item?.text?.text ?? "") }
        }
        if let view = textView {
            item.textViewItem = XJJAlertItem.Text(title: view.item?.titleText?.text ?? "", inputText: view.item?.text?.text ?? "")
        }
        
        self.actionBlock?(item)
    }
    
    private func removeButtons() {
        if buttonArr.count > 0 {
            self.buttonArr.forEach { $0.removeFromSuperview() }
            self.buttonArr.removeAll()
        }
        if buttonHLines.count > 0 {
            self.buttonHLines.forEach { $0.removeFromSuperview() }
            self.buttonHLines.removeAll()
        }
        if buttonVLines.count > 0 {
            self.buttonVLines.forEach { $0.removeFromSuperview() }
            self.buttonVLines.removeAll()
        }
    }
}
