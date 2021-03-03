//
//  TestViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/4.
//

import UIKit

class TestViewController: XJJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    private func initUI() {
        self.page = .test
        
        //self.gradientLayer()
        self.videoSource()
        
        
        
    }
    
    // 渐变 - CAGradientLayer
    private func gradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        gradientLayer.locations = [0.2, 0.5, 0.8]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.addSublayer(gradientLayer)
    }
    
    private func videoSource() {
        _ = XJJVideo()
    }

}
