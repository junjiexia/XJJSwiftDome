//
//  XJJMMSConfig.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/24.
//

import Foundation

class XJJMMSConfig {
    /* command to send */
    static let cmdHeaderLength = 40
    static let cmdPrefixLength = 8
    static let cmdBodyLength = 1024 * 16 /* FIXME: make this dynamic */
    /* receive */
    static let maxBufferSize = 102400 /* 接收最大包长度 */
    static let maxHeaderSize = 8192 * 2 /* 接收最大头长度 */
    static let maxStreamNum = 23 /* 接收最大流个数 */
}
