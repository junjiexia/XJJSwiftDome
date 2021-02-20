//
//  UIDevice+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/20.
//

import Foundation
import UIKit

extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch 5" // (Gen)
        case "iPod7,1":  return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":  return "iPhone 5"
        case "iPhone5,2":  return "iPhone 5" // (GSM+CDMA)
        case "iPhone5,3":  return "iPhone 5c" // (GSM)
        case "iPhone5,4":  return "iPhone 5c" // (GSM+CDMA)
        case "iPhone6,1":  return "iPhone 5s" // (GSM)
        case "iPhone6,2":  return "iPhone 5s" // (GSM+CDMA)
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":  return "iPhone 7"
        case "iPhone9,2":  return "iPhone 7 Plus"
        case "iPhone9,3":  return "iPhone 7"
        case "iPhone9,4":  return "iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":  return "iPhone 8"
        case "iPhone10,2","iPhone10,5":  return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":  return "iPhone X"
        case "iPhone11,2":  return "iPhone XS"
        case "iPhone11,4","iPhone11,6":  return"iPhone XS Max"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"
            
        case "iPad1,1":  return "iPad"
        case "iPad1,2":  return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":  return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":  return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":  return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":  return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":  return "Apple TV 4"
        case "i386", "x86_64":  return "Simulator"
        default:  return identifier
        }
    }
}

final class EDevice {
    
    enum UIType {
        case less5S
        case normal
        case x
        case eleven
        case twelve
        case unown
    }
    
    class func getIphoneType() -> UIType {
        let str = UIDevice.current.modelName
        switch str {
        case "iPhone 5", "iPhone 5c", "iPhone 5s":
            return .less5S
        case "iPhone X", "iPhone XS", "iPhone XS Max", "iPhone XR":
            return .x
        case "iPhone 11", "iPhone 11 Pro", "iPhone 11 Pro Max":
            return .eleven
        case "iPhone 12 mini", "iPhone 12", "iPhone 12 Pro", "iPhone 12 Pro Max":
            return .twelve
        case "Simulator":
            if UIScreen.main.bounds.height == 812 {
                return .x
            }
            return .normal
        default:
            if UIScreen.main.bounds.height == 812 {
                return .x
            }
            return .normal
        }
    }
    
    class func isMoreX() -> Bool {
        return EDevice.getIphoneType() == .x || EDevice.getIphoneType() == .eleven || EDevice.getIphoneType() == .twelve
    }
    
    class func getCurrentVersion() -> String { // 登录需要使用
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return version
        }
        return ""
    }
    
    /**
     
     *此uuid在相同的一个程序里面-相同的vindor-相同的设备下是不会改变的
     
     *此uuid是唯一的，但应用删除再重新安装后会变化，采取的措施是：只获取一次保存在钥匙串中，之后就从钥匙串中获取
     
     **/
    class func getUUID() -> String {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        }
        return ""
    }
}
