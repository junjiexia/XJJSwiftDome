//
//  XJJFTPConfig.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/5.
//

import Foundation

class XJJFTPConfig {
    //服务器端口//
    static let port: UInt16 = 8080
    //特殊字串//
    static var message = "message"
    static var info = "info"
    //特定发送或接收的tag//
    static let id_tag = 100000 // tag 起始值
    static let server_accept_tag = 10001 // 默认服务端接收tag
    static let server_send_message_tag = 10002 // 默认服务端发送消息tag
    static let server_send_infos_tag = 10003 // 默认服务端发送json的tag
    static let client_connect_tag = 10004 // 默认客户端连接tag
    static let client_send_message_tag = 10005 // 默认客户端发送消息tag
    static let client_send_infos_tag = 10006 // 默认客户端发送json的tag
    //ftp log开关
    static var openFTPLog: Bool = true
    //当前发送最大tag//分配0～10
    static var max_send_id: Int = 0
    //当前接收最大tag//
    static var max_reseive_id: Int = 11
}

func ftp_print(_ items: Any...) {
    if XJJFTPConfig.openFTPLog {
        print("FTP-", items)
    }
}
