//
//  XJJVideoItem.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/1.
//

import Foundation

class XJJVideoItem: Codable {
    
    var OldVideoUrls: [String: String]? // 2015年 获取视频url
    var VideoUrls: [String: String]? // 2020年 获取视频url
    
    func url(forKey: String) -> URL? {
        guard let urlString: String = self.VideoUrls?[forKey] else {return nil}
        return URL(string: urlString)
    }
}
