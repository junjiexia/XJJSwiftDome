//
//  XJJSliderView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/13.
//

import UIKit

class XJJSliderView: UIView {
    
    var titleText: XJJText? {
        didSet {
            guard let text = titleText else {return}
            self.setupUI(text)
        }
    }
    
    var sliderValue: Float? { //
        didSet {
            guard let value = sliderValue else {return}
            if value < minValue {
                self.sliderView.progress = 0
                self.stateLabel.text = "\(minValue)"
            }else if value >= maxValue {
                self.sliderView.progress = 1.0
                self.stateLabel.text = "\(maxValue)"
            }else {
                self.sliderView.progress = value
                self.stateLabel.text = String(format: "%.\(decimals)f", value / maxValue + minValue)
            }
        }
    }
    
    var minValue: Float = 0
    var maxValue: Float = 0
    var decimals: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var titleLabel: UILabel!
    private var sliderView: UIProgressView!
    private var stateLabel: UILabel!
    
    private let borderH: CGFloat = 16
    private let stateWidth: CGFloat = 50
    private let mergeH: CGFloat = 5
    private let sliderHeight: CGFloat = 3
    
    private func initUI() {
        self.initTitle()
        self.initProgress()
        self.initState()
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel)
    }
    
    private func initProgress() {
        self.sliderView = UIProgressView(progressViewStyle: .default)
        self.addSubview(sliderView)
        
        self.sliderView.progressTintColor = UIColor.blue
        self.sliderView.trackTintColor = UIColor.lightGray
        
    }
    
    private func initState() {
        self.stateLabel = UILabel()
        self.addSubview(stateLabel)
        
        self.stateLabel.setText(XJJText("-"))
    }
    
    private func setupUI(_ text: XJJText) {
        self.titleLabel.setText(text)
        self.titleLabel.frame = CGRect(x: borderH, y: 0, width: text.size.width, height: bounds.height)
        self.stateLabel.frame = CGRect(x: bounds.width - borderH - stateWidth, y: 0, width: stateWidth, height: bounds.height)
        self.sliderView.frame = CGRect(x: titleLabel.frame.maxX + mergeH, y: (bounds.height - sliderHeight) / 2, width: stateLabel.frame.minX - mergeH * 2 - titleLabel.frame.maxX, height: sliderHeight)
    }
    
}
