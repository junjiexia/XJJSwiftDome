//
//  XJJVideoPlayerMenuBottomView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/4/14.
//

import UIKit

class XJJVideoPlayerMenuBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var playBtn: UIButton!
    private var progressBar: XJJVideoProgressBar!
    private var fullScreenBtn: UIButton!
        
    private func initUI() {
        
    }

}
