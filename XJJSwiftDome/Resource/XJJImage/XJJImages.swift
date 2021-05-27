//
//  XJJImages.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/5/11.
//

import Foundation
import UIKit

class XJJImages {
    
    static var image01: UIImage? {
        get {
            return image(imagePath: ImagePath.image01.rawValue, type: ".jpeg")
        }
    }
    
    enum ImagePath: String {
        case image01 = "xjj_image01"
    }
    
    private class func image(imagePath: String, type: String? = ".png") -> UIImage? {
        guard let path = Bundle.main.path(forResource: imagePath, ofType: type) else {return nil}
        return UIImage(contentsOfFile: path)
    }
    
    /* 自绘图片
        * 优先实例化并缓存
     */
    static let returnImage: UIImage? = UIImage.backArrow
    static let settingImage: UIImage? = UIImage.mutSixGaps
    static let listMenuImage: UIImage? = UIImage.listMenuThreeLines
    static let fullScreen: UIImage? = UIImage.fullScreen
    static let cancelFullScreen: UIImage? = UIImage.cancelFullScreen
    static let play: UIImage? = UIImage.play
    static let pause: UIImage? = UIImage.pause
    static let progressBarButton: UIImage? = UIImage.progressBarButton
    static let rewind: UIImage? = UIImage.rewind
    static let forward: UIImage? = UIImage.forward
}
