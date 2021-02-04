//
//  ViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/1.
//

import UIKit

class ViewController: XJJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }

    private func initUI() {
        XJJCheck.checkFont("JSuHunTi", perfectMatch: false)
        self.page = .first
    }

}

