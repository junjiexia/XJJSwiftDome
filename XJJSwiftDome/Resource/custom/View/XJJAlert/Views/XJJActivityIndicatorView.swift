//
//  XJJActivityIndicatorView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/5.
//

import UIKit

class XJJActivityIndicatorView: UIView {
    
    var aiText: XJJText? {
        didSet {
            guard let text = aiText else {return}
            self.setupText(text)
        }
    }
    
    func startAnimating() {
        self.aiView.startAnimating()
    }
    
    func stopAnimating() {
        self.aiView.stopAnimating()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var aiView: UIActivityIndicatorView!
    private var textLabel: UILabel!
    
    private func initUI() {
        self.setupUI()
        self.initAIView()
        self.initText()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    private func initAIView() {
        self.aiView = UIActivityIndicatorView(style: .large)
        self.addSubview(aiView)
        
        let aiX: CGFloat = (bounds.width - XJJAlert.activityIndicatorWidth) / 2
        self.aiView.frame = CGRect(x: aiX, y: XJJAlert.borderV, width: XJJAlert.activityIndicatorWidth, height: XJJAlert.activityIndicatorWidth)
    }
    
    private func initText() {
        self.textLabel = UILabel()
        self.addSubview(textLabel)
        
        self.textLabel.numberOfLines = 0
    }
    
    private func setupText(_ text: XJJText) {
        self.textLabel.setText(text)
        let textY: CGFloat = aiView.frame.maxY + XJJAlert.mergeV
        self.textLabel.frame = CGRect(x: XJJAlert.borderH, y: textY, width: bounds.width - XJJAlert.borderH * 2, height: bounds.height - textY - XJJAlert.borderV)
    }
}
