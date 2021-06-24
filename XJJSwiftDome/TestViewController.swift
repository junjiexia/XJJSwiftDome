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
        
        self.addRightImageItem(XJJImages.batteryFull!)
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
    private var thirdImageView: UIImageView!
    private var fourthImageView: UIImageView!
    
    private func testImage() {
        self.imageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 100, height: 100))
        self.view.addSubview(imageView)
        
        self.imageView.backgroundColor = UIColor.white
        self.imageView.setupPlayAndPause()
        
        self.otherImageView = UIImageView(frame: CGRect(x: 200, y: 100, width: 100, height: 100))
        self.view.addSubview(otherImageView)
        
        self.otherImageView.backgroundColor = UIColor.white
        self.otherImageView.setupPlayAndPause()
        
        UIImageView.playAndPauseBlock = { imageView, isPlay in
            if self.imageView == imageView {
                print("播放：", isPlay)
            }
        }
        
        self.thirdImageView = UIImageView(frame: CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 300))
        self.view.addSubview(thirdImageView)
        
        self.thirdImageView.backgroundColor = UIColor.white
        self.thirdImageView.image = XJJImages.image01?.grayImage
        
//        let maskView = UIImageView(image: UIImage.drawPlay(size: CGSize(width: 100, height: 100))?.grayImage)
//        self.thirdImageView.mask = maskView
        
        self.thirdImageView = UIImageView(frame: CGRect(x: 350, y: 100, width: 30, height: 30))
        self.view.addSubview(thirdImageView)
        
        self.thirdImageView.image = XJJImages.batteryFull
    }
    
}
