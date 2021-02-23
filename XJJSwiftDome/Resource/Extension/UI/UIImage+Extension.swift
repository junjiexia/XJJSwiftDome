//
//  UIImage+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/23.
//

import Foundation
import UIKit

extension UIImage {
    func apply(_ color: UIColor, _ imageView: UIImageView) -> UIImage? {
        imageView.tintColor = color
        return self.withRenderingMode(.alwaysTemplate)
    }
}
