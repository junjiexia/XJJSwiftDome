//
//  XJJVideoItem.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/1.
//

import Foundation

class XJJVideoItem: Codable {
    
    var HTTPVideoUrls: [String: String]? // http 视频资源
    var MMSVideoUrls: [String: String]? // mms 视频资源
    
    func http_source(forKey: String) -> String? {
        return self.HTTPVideoUrls?[forKey]
    }
    
    func http_url(forKey: String) -> URL? {
        guard let urlString: String = self.HTTPVideoUrls?[forKey] else {return nil}
        return URL(string: urlString)
    }
    
    func mms_url(forKey: String) -> URL? {
        guard let urlString: String = self.MMSVideoUrls?[forKey] else {return nil}
        return URL(string: urlString)
    }
}
