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
        * UIGraphicsGetImageFromCurrentImageContext() 绘制图片无法释放，一张图片只能创建一次
        * 在其他线程绘制图片，UIGraphicsGetImageFromCurrentImageContext() 可以释放
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
    static let open: UIImage? = UIImage.subtract
    static let close: UIImage? = UIImage.add
    static let check: UIImage? = UIImage.check
    static let checkWithBox: UIImage? = UIImage.checkWithBox
    static let noCheckWithBox: UIImage? = UIImage.noCheckWithBox
}

//MARK: - 电池图片
extension XJJImages {
    static let batteryFull: UIImage? = UIImage.batteryFull
    
    /*
        * 随时变化的图片需要在其他线程绘制图片，否则 UIGraphicsGetImageFromCurrentImageContext() 无法释放
     */
    static func getImage(battery: UIImage.Battery, size: CGSize? = nil, isFull: Bool? = false, resultBlock: ((_ image: UIImage?) -> Void)?) {
        DispatchQueue.global().async {
            let image = UIImage.drawBattery(battery: battery, size: size, isFull: isFull)
            DispatchQueue.main.async {
                resultBlock?(image)
            }
        }
    }
}
