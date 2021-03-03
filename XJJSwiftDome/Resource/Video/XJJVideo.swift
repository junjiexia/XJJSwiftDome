//
//  XJJVideo.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/1.
//

import Foundation

class XJJVideo {
    
    var list: XJJVideoItem? // 视频列表
    
    init() {
        if let path: String = Bundle.main.path(forResource: "XJJVideoSource", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            self.list = Data.dictToModel(dict)
            print("oringe:", dict, "model:", list ?? "转换模组失败！")
        }
    }
    
}
