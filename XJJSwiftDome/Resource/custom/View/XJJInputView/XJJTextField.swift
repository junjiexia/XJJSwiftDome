//
//  XJJTextField.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/2.
//

import UIKit

enum XJJTextFieldStyle {
    case normal // 普通，就一个输入框
    case title // 带有左边标题的输入框
    case action // 带有右边按钮的输入框
    case titleAndAction // 带有标题和按钮的输入框
}

class XJJTextFieldItem {
    var titleText: XJJText?
    var text: XJJText?
    var actionText: XJJText?
    var actionImage: UIImage?
    var style: XJJTextFieldStyle = .normal
    
    init(normal text: XJJText) {
        self.style = .normal
        self.text = text
    }
    
    init(title titleText: XJJText, text: XJJText) {
        self.style = .title
        self.titleText = titleText
        self.text = text
    }
    
    init(action text: XJJText, actionText: XJJText? = nil, actionImage: UIImage? = nil) {
        self.style = .action
        self.text = text
        self.actionText = actionText
        self.actionImage = actionImage
    }
    
    init(titleAndImage titleText: XJJText, text: XJJText, actionText: XJJText? = nil, actionImage: UIImage? = nil) {
        self.style = .titleAndAction
        self.titleText = titleText
        self.text = text
        self.actionText = actionText
        self.actionImage = actionImage
    }
}

class XJJTextField: UIView {
    
    var textBlock: ((_ text: String) -> Void)?
    
    var item: XJJTextFieldItem? {
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
        self.textField.removeKeyboardNotification()
        super.removeFromSuperview()
    }
    
    deinit {
        //print("XJJTextField deinit !!")
    }
    
    private var titleLabel: UILabel!
    private var textField: UITextField!
    private var action: UIButton!
    
    private var viewStyle: XJJTextFieldStyle = .normal
    private let borderH: CGFloat = 16
    private let mergeH: CGFloat = 5
    private let actionImageSize: CGSize = CGSize(width: 30, height: 30)
    
    private func initUI() {
        self.backgroundColor = UIColor.white
        
        self.initTitle()
        self.initTextField()
        self.initAction()
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel)
    }
    
    private func initTextField() {
        self.textField = UITextField()
        self.addSubview(textField)
        
        self.textField.borderStyle = .none
        self.textField.returnKeyType = .done
        self.textField.delegate = self
        self.textField.layer.borderWidth = 1
        self.textField.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.textField.layer.cornerRadius = 5
        self.textField.addTarget(self, action: #selector(textAction), for: .editingChanged)
        self.textField.addKeyboardNotification()
    }
    
    @objc private func textAction(_ tf: UITextField) {
        switch viewStyle {
        case .normal, .title:
            self.item?.text?.text = tf.text ?? ""
            self.textBlock?(tf.text ?? "")
        default:
            break
        }
    }
    
    private func initAction() {
        self.action = UIButton(type: .custom)
        self.addSubview(action)
    
        self.action.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
    }
    
    @objc private func btnAction(_ btn: UIButton) {
        switch viewStyle {
        case .action, .titleAndAction:
            self.item?.text?.text = textField.text ?? ""
            self.textBlock?(textField.text ?? "")
        default:
            break
        }
    }

    private func setupUI(_ item: XJJTextFieldItem) {
        self.viewStyle = item.style
        if let text = item.titleText {
            self.titleLabel.setText(text)
            self.titleLabel.frame = CGRect(x: borderH, y: 0, width: text.size.width, height: bounds.height)
        }
        
        if let text = item.actionText {
            self.action.setText(text)
            self.action.frame = CGRect(x: bounds.width - text.size.width - borderH, y: 0, width: text.size.width, height: bounds.height)
        }else if let image = item.actionImage {
            self.action.setImage(image, for: .normal)
            self.action.frame = CGRect(origin: CGPoint(x: bounds.width - actionImageSize.width - borderH, y: (bounds.height - actionImageSize.height) / 2), size: actionImageSize)
        }
        
        if let text = item.text {
            self.textField.setText(text)
            var x: CGFloat = 0
            var width: CGFloat = 0
            
            switch viewStyle {
            case .normal:
                x = borderH
                width = bounds.width - x - borderH
            case .title:
                x = titleLabel.frame.maxX + mergeH
                width = bounds.width - x - borderH
            case .action:
                x = borderH
                width = action.frame.minX - x - mergeH
            case .titleAndAction:
                x = titleLabel.frame.maxX - mergeH
                width = action.frame.minX - x - mergeH
            }
            
            self.textField.frame = CGRect(x: x, y: 0, width: width, height: bounds.height)
        }
    }
}

extension XJJTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("textField Did Begin Editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("textField Did End Editing")
    }
}
