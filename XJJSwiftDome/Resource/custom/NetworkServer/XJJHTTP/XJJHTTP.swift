//
//  XJJHTTP.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/2.
//

import Foundation
import UIKit

final class XJJHTTP {
    static let openLog: Bool = true
    
    /*
     - 下载文件 -
     saveFileType: 储存位置，needCashe 为 false 时有效
     needCache: 是否需要 cache 缓存
                true 返回 data，不返回路径
                false 返回路径，不返回 data，data 需要通过路径拿取
     */
    class func download(_ urlStr: String,
                        _ fileName: String,
                        saveFileType: XJJHTTPFileSaveType? = nil,
                        needCache: Bool? = true,
                        completionBlock: ((_ isSuccess: Bool, _ filePath: String?, _ data: Data?) -> Void)?)
    {
        XJJHTTPManager.share.download(urlStr, fileName, saveFileType: saveFileType, needCache: needCache, completionBlock)
    }
    
    class func stream(read urlString: String,
                port: Int? = nil,
                minLength: Int? = nil,
                maxLength: Int? = nil,
                timeOut: TimeInterval? = nil,
                resultBlock: ((_ currentData: Data?, _ cumulativeData: Data?, _ error: Error?) -> Void)?,
                completionBlock: ((_ data: Data?, _ error: Error?) -> Void)?)
    {
        let item = XJJHTTPStreamWorkerTask(read: urlString, port: port, minLength: minLength, maxLength: maxLength, timeOut: timeOut)
        XJJHTTPManager.share.stream(item, resultBlock: resultBlock, completionBlock: completionBlock)
    }
}

func http_print(_ items: Any...) {
    if XJJHTTP.openLog {
        print("HTTP-", items)
    }
}
