//
//  XJJNewsItem.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/26.
//

import Foundation

class XJJNewsItem {
    
    var id: ID = .first
    
    enum ID: String { // 标识 = 标识字串
        case first = "推荐"
        case second = "体育"
        case third = "教育"
        case fourth = "外交"
        case fifth = "财经"
        case sixth = "旅游"
        case seventh = "美食"
        case eighth = "开心一刻"
        case ninth = "猜你喜欢"
    }
    
    init() {}
    
    func asTable() -> XJJNewsTableItem? {
        return self as? XJJNewsTableItem
    }
}
