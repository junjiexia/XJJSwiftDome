//
//  UIViewController+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/6/11.
//

import Foundation
import UIKit

extension UIViewController {
    public func asViewController<T>(_ cs: T.Type) -> T? {
        return self as? T
    }
}
