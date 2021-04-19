//
//  XJJVideoItem.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/1.
//

import Foundation

class XJJVideoItem: Codable {
    
    var HTTPVideoUrls: [String: XJJVideoSubItem]? // http 视频资源
    var MMSVideoUrls: [String: XJJVideoSubItem]? // mms 视频资源
    
    func http_source(forKey: String) -> XJJVideoSubItem? {
        return self.HTTPVideoUrls?[forKey]
    }
    
    func mms_source(forKey: String) -> XJJVideoSubItem? {
        return self.MMSVideoUrls?[forKey]
    }
}

class XJJVideoSubItem: Codable {
    var type: String?
    var urlString: String?
    
    enum VType: String {
        case recorded = "recorded"
        case live = "live"
    }
    
    func videoType() -> VType {
        guard let _type = type else {return .recorded}
        return VType(rawValue: _type) ?? .recorded
    }
}
