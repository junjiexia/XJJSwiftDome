//
//  XJJSheet.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/24.
//

import Foundation
import UIKit

class XJJSheet {
    /************************
     ******* sheet（系统）
     ************************/
    class func sheet(on viewController: UIViewController,
                     _ title: String?,
                     _ actions: [String],
                     titleFont: UIFont? = nil,
                     titleColor: UIColor? = nil,
                     actionColors: [UIColor?]? = nil,
                     cancelText: String? = nil,
                     cancelColor: UIColor? = nil,
                     _ callback: ((_ index: Int, _ text: String) -> Void)?) {
        let alert_vc = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        if let ti = title {
            let attr: NSMutableAttributedString = NSMutableAttributedString(string: ti)
            attr.addAttributes([NSAttributedString.Key.foregroundColor: titleColor ?? UIColor.darkText, NSAttributedString.Key.font: titleFont ?? UIFont.systemFont(ofSize: 15)], range: NSRange(location: 0, length: attr.length))
            alert_vc.setValue(attr, forKey: "attributedTitle")
        }
        
        let cancel = UIAlertAction(title: cancelText ?? "取消", style: .cancel) { (action) in
            callback?(-1, cancelText ?? "取消")
        }
        if let color = cancelColor {
            cancel.setValue(color, forKey: "titleTextColor")
        }
        
        alert_vc.addAction(cancel)
        
        if actions.count > 0 {
            for i in 0..<actions.count {
                let action = UIAlertAction(title: actions[i], style: .default) { (action) in
                    callback?(i, actions[i])
                }
                if let colorArr = actionColors, i < colorArr.count {
                    if let color = colorArr[i] {
                        action.setValue(color, forKey: "titleTextColor")
                    }
                }
                
                alert_vc.addAction(action)
            }
        }
        
        viewController.present(alert_vc, animated: true, completion: nil)
    }
}
