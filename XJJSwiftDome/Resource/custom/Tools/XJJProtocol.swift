//
//  XJJProtocol.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/24.
//

import Foundation

// 拷贝协议
protocol XJJCopyable {
    associatedtype T
    
    func copy()-> T
}
