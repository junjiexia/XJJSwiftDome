//
//  XJJConfig.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/1/28.
//

import Foundation
import UIKit

class XJJConfig {
    
    
}

class XJJUIConfig {
    static let nav_h: CGFloat = EDevice.isMoreX() ? 88 : 64
    static let status_h: CGFloat = EDevice.isMoreX() ? 30 : 20
    static let tab_h: CGFloat = EDevice.isMoreX() ? 80 : 50
    static let bottom_h: CGFloat = EDevice.isMoreX() ? 30 : 0
}
