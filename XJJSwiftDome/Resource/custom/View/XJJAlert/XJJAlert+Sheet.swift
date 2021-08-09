//
//  XJJAlert+Sheet.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/24.
//

import Foundation
import UIKit

extension XJJAlert {
    /************************
     ******* sheet（系统）
     ************************/
    static func sheet(on viewController: UIViewController,
                      _ title: XJJText?,
                      _ message: XJJText?,
                      _ actions: [XJJText],
                      cancelText: XJJText? = nil,
                      _ callback: ((_ index: Int, _ text: String) -> Void)?) {
        let alert_vc = UIAlertController(title: title?.text, message: message?.text, preferredStyle: .actionSheet)
        if let ti = title {
            var attr: NSMutableAttributedString = NSMutableAttributedString(string: "")
            
            switch ti.type {
            case .text:
                attr = NSMutableAttributedString(string: ti.text)
                attr.addAttributes([NSAttributedString.Key.foregroundColor: ti.color, NSAttributedString.Key.font: ti.font ], range: NSRange(location: 0, length: attr.length))
            case .range:
                attr.append(ti.rangeAttr)
            case .random:
                attr.append(ti.randomAttr)
            case .designated:
                attr.append(ti.designatedAttr)
            case .wholeRandom:
                attr.append(ti.wholeRandomAttr)
            }
            
            alert_vc.setValue(attr, forKey: "attributedTitle")
        }
        
        let cancel = UIAlertAction(title: cancelText?.text ?? "取消", style: .cancel) { (action) in
            callback?(-1, cancelText?.text ?? "取消")
        }
        if let color = cancelText?.color {
            cancel.setValue(color, forKey: "titleTextColor")
        }
        
        alert_vc.addAction(cancel)
        
        if actions.count > 0 {
            for i in 0..<actions.count {
                let action = UIAlertAction(title: actions[i].text, style: .default) { (action) in
                    callback?(i, actions[i].text)
                }
                action.setValue(actions[i].color, forKey: "titleTextColor")
                
                alert_vc.addAction(action)
            }
        }
        
        viewController.present(alert_vc, animated: true, completion: nil)
    }
}
