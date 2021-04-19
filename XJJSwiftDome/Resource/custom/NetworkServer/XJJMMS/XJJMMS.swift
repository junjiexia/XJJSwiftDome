//
//  XJJMMS.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/16.
//

// 本来想弄个 mms 直播，没想找到的 mms 地址都失效了，mms 用的也比较少了，没了测试，所以放弃了，改用 http

import Foundation

final class XJJMMS {
    
    static let share = XJJMMS()
    
    private var client: XJJMMSClient!
    
    func creatClient(host: String) {
        self.client = XJJMMSClient(host: host)
        self.client.socketConnect()
    }
    
    static let openLog: Bool = true
}

func mms_print(_ items: Any...) {
    if XJJMMS.openLog {
        print("MMS-", items)
    }
}
