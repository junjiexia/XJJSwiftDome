//
//  UIScrollView+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/20.
//

import Foundation
import UIKit

extension UIScrollView {
    func needSubviewTouches() {
        self.canCancelContentTouches = true
        self.delaysContentTouches = false
    }
        
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    @objc open override func touchesMoved(_ touches: Set<UITouch>, with event:  UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
        super.touchesMoved(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesCancelled(touches, with: event)
        super.touchesCancelled(touches, with: event)
    }
}
