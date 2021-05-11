//
//  XJJScreen.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/5/10.
//

import Foundation
import UIKit

class XJJScreen {
    // 真实分辨率
    static let resolutionRatio: CGSize? = UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? UIScreen.main.currentMode?.size : nil
    // 每一份的分辨率
    static var perResolutionRatio: CGSize? {
        get {
            if let ratio = resolutionRatio {
                let size = UIScreen.main.bounds.size
                return CGSize(width: ratio.width / size.width, height: ratio.height / size.height)
            }
            
            return nil
        }
    }
}
