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
        //self.videoSource()
        self.testImage()
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
    
    // video
    private func videoSource() {
        guard let host = XJJVideo().list?.http_source(forKey: "CCTV1")?.urlString else {return}
        XJJMMS.share.creatClient(host: host)
    }

    // image
    private var imageView: UIImageView!
    private var otherImageView: UIImageView!
    
    private func testImage() {
        self.imageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 200, height: 200))
        self.view.addSubview(imageView)
        
        self.imageView.backgroundColor = UIColor.white
        self.imageView.setupLockImage()
        
        self.otherImageView = UIImageView(frame: CGRect(x: 50, y: 400, width: 200, height: 200))
        self.view.addSubview(otherImageView)
        
        self.otherImageView.backgroundColor = UIColor.white
        self.otherImageView.setupLockImage()
        
        UIImageView.lockImageOpenBlock = { imageView, isOpen in
            if self.imageView == imageView {
                print("锁是否打开：", isOpen)
            }
        }
    }
    
}
