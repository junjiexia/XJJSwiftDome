//
//  XJJRHLabel.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/6.
//

import UIKit

/*
    * 跑马灯
 */

class XJJRHLabel: UIView {
    
    var text: XJJText? {
        didSet {
            guard let t = text else {return}
            self.setupLabel(t)
        }
    }
    
    var showTitle: XJJText = XJJText("")
    var rate: TimeInterval = 1.0 // 时间速率，影响最终移动的时间，速率越大，需要的时间越长
    var style: Style = .Static
    
    enum Style {
        case Static
        case AlwaysMove
        case ClickMove
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func removeFromSuperview() {
        self.label.layer.removeAllAnimations()
        super.removeFromSuperview()
    }
    
    deinit {
        //print("XJJRHLabel deinit")
    }
    
    private var label: UILabel!
    
    private var tap: UITapGestureRecognizer?
    private var timer: Timer?
    
    private var duration: TimeInterval = 0.1 // 每个单词经历的时间，可以通过 rate 和 duration 来影响最终的时间
    private var isMove: Bool = false // 是否正在动画
    private var needTap: Bool = true // 是否需要手势（点击、滚动效果）
    
    private func initUI() {
        self.setupUI()
        self.initLabel()
    }
    
    private func setupUI() {
        self.clipsToBounds = true
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func initLabel() {
        self.label = UILabel()
        self.addSubview(label)
        
        switch style {
        case .Static:
            self.label.lineBreakMode = .byTruncatingTail
        default:
            self.label.lineBreakMode = .byWordWrapping
        }
    }
    
    private func setupLabel(_ text: XJJText) {
        self.label.setText(text)
        
        var labelWidth = self.bounds.width
        if text.text.count > 0 {
            self.needTap = text.size.width > self.bounds.width
            if self.style != .Static {
                labelWidth = needTap ? text.size.width : self.bounds.width
            }
            self.setupTap()
        }
        self.label.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.bounds.height)
        
        switch style {
        case .AlwaysMove:
            self.startMove()
        default:
            break
        }
    }
    
    private func setupTap() {
        switch style {
        case .AlwaysMove:
            if self.tap != nil {
                self.removeGestureRecognizer(tap!)
                self.tap = nil
            }
        default:
            if needTap {
                self.tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
                self.addGestureRecognizer(tap!)
            }else {
                if self.tap != nil {
                    self.removeGestureRecognizer(tap!)
                    self.tap = nil
                }
            }
        }
    }
    
    @objc func tapClick(_ tap: UITapGestureRecognizer) {
        switch style {
        case .AlwaysMove:
            break
        case .ClickMove:
            self.startMove()
        case .Static:
            XJJAlert.prompt(title: showTitle, message: XJJText(self.label.text ?? ""))
        }
    }
    
    private func startMove() {
        guard self.label.frame.width > self.bounds.width else {return}
        guard !self.isMove, self.style != .Static else {return}
        self.isMove = true
        var count: Int = 1
        if let c = self.label.text?.count {
            count = c
        }
        let interval: TimeInterval = duration * TimeInterval(count) * rate
        self.startAnimate(interval)
    }
    
    private func startAnimate(_ interval: TimeInterval) {
        let diff: CGFloat = self.label.frame.width - self.bounds.width
        UIView.animate(withDuration: interval, animations: {
            self.label.frame.origin.x = -diff
        }) { (complete) in
            if complete {
                self.nextAnimate(interval, diff)
            }
        }
    }
    
    private func nextAnimate(_ interval: TimeInterval, _ diff: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.animate(withDuration: interval, animations: {
                self.label.frame.origin.x = 0
            }, completion: { (complete) in
                if complete {
                    self.endAnimate(interval)
                }
            })
        })
    }
    
    private func endAnimate(_ interval: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            switch self.style {
            case .AlwaysMove:
                self.startAnimate(interval)
            case .ClickMove:
                self.endMove()
            case .Static:break
            }
        })
    }
    
    private func endMove() {
        self.isMove = false
    }
}
