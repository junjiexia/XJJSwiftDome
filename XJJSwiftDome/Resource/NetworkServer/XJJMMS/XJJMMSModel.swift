//
//  XJJMMSModel.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/16.
//

// 数据模型参考 libmms
// XJJMMSModel 中没有填写，大概也就是就收到的文件模型，以及推流的数据，mms 源文件失效，也就没有继续写的必要了，以后有机会在写

import Foundation

class XJJMMSHeader: Codable {
    var packetLength: UInt32 = 0x0 // 包长度
    var flags: UInt8 = 0x0 //
    var packetIdType: UInt8 = 0x0 //
    var packetSeq: UInt32 = 0x0 //
}

class XJJMMSStream: Codable {
    var streamId: Int = 0 // 通道ID
    var streamType: XJJGUID.StreamType = .ASF_UNKNOWN // 通道类型
    var bitRate: Int = 0 // 通道速率
    var bitRatePos: Int = 0 // 通道定位
}

class XJJMMSModel: Codable {
    
    var urlString: String?
    var post: UInt16?
    var userName: String?
    var password: String?
    
    
}

extension XJJMMSModel {
    
    func byteOrFromLow<T>(value: T) -> T where T: FixedWidthInteger, T: UnsignedInteger {
        
        if let num = value as? UInt16 {
            
            let high = (num >> 8) & 0xff
            let low = num & 0xff
            
            return T((high << 8) | low)
        }else if let num = value as? UInt32 {
            let first = (num >> 24) & 0xff
            let second = (num >> 16) & 0xff
            let third = (num >> 8) & 0xff
            let fourth = num & 0xff
            
            return T(fourth | (third << 8) | (second << 16) | (first << 24))
        }else if let num = value as? UInt64 {
            let first = (num >> 56) & 0xff
            let second = (num >> 48) & 0xff
            let third = (num >> 40) & 0xff
            let fourth = (num >> 32) & 0xff
            let fifth = (num >> 24) & 0xff
            let sixth = (num >> 16) & 0xff
            let seventh = (num >> 8) & 0xff
            let eighth = num & 0xff
            
            let result = eighth | (seventh << 8) | (sixth << 16) | (fifth << 24) | (fourth << 32) | (third << 40) | (second << 48) | (first << 56)
            
            return T(result)
        }
        
        return value
    }
    
    func byteOrFromHigh<T>(value: T) -> T where T: FixedWidthInteger, T: UnsignedInteger {
        
        if let num = value as? UInt16 {
            
            let high = (num >> 8) & 0xff
            let low = num & 0xff
            
            return T((low << 8) | high)
        }else if let num = value as? UInt32 {
            let first = (num >> 24) & 0xff
            let second = (num >> 16) & 0xff
            let third = (num >> 8) & 0xff
            let fourth = num & 0xff
            
            return T(first | (second << 8) | (third << 16) | (fourth << 24))
        }else if let num = value as? UInt64 {
            let first = (num >> 56) & 0xff
            let second = (num >> 48) & 0xff
            let third = (num >> 40) & 0xff
            let fourth = (num >> 32) & 0xff
            let fifth = (num >> 24) & 0xff
            let sixth = (num >> 16) & 0xff
            let seventh = (num >> 8) & 0xff
            let eighth = num & 0xff
            
            let result = first | (second << 8) | (third << 16) | (fourth << 24) | (fifth << 32) | (sixth << 40) | (seventh << 48) | (eighth << 56)
            
            return T(result)
        }
        
        return value
    }
    
}

extension XJJMMSModel {
    
}
