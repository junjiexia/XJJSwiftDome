//
//  Date+ Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/23.
//

import Foundation

extension Date {
    // 现在
    static func now(_ format: String) -> String {
        return Date().dateString(format)
    }
    
    // 昨天 or 昨天相对于今天的时间
    static func yesterday(_ format: String) -> String {
        return dateString(before: 1, format)
    }
    
    // 格式字符串
    public func dateString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    // 时间字符串按格式转换为 Date
    static func date(_ str: String, _ format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: str)
    }
    
    // 今天之前某一天（字符串）
    static func dateString(before dayNumber: Int, _ format: String) -> String {
        return date(before: dayNumber).dateString(format)
    }
    
    // 今天之前某一天（Date）
    static func date(before dayNumber: Int) -> Date {
        let interval = Date().timeIntervalSince1970
        let beforeInterval = interval - TimeInterval(3600 * 24 * dayNumber)
        
        return Date(timeIntervalSince1970: beforeInterval)
    }
    
    // 今天之后某一天
    static func dateString(after dayNumber: Int, _ format: String) -> String {
        let interval = Date().timeIntervalSince1970
        let beforeInterval = interval + TimeInterval(3600 * 24 * dayNumber)
        let date = Date(timeIntervalSince1970: beforeInterval)
        
        return date.dateString(format)
    }
    
    // 某天之后某一天
    static func dateString(after dateStr: String, _ dayNumber: Int, _ format: String) -> String {
        let interval = Date.timeInterval(dateStr, format)
        let beforeInterval = interval + TimeInterval(3600 * 24 * dayNumber)
        let date = Date(timeIntervalSince1970: beforeInterval)
        
        return date.dateString(format)
    }
    
    // 某月开始（例：1月1号）
    public func beginningOfMonth(format: String) -> String {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(1, for: .day)
        if let date_goal: Date = calendar.date(from: components) {
            return date_goal.dateString(format)
        }
        
        return ""
    }
    
    // 2019-10-19T04:52:26.000+0000  ---->  2019-10-19  12:52:26
    static func timeString(T value: String?, format: String? = nil) -> String {
        if let timeS = value {
            let timeStr = timeS.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: ".000", with: " ")
            if let date = Date.date(timeStr, "yyyy-MM-dd HH:mm:ss ZZZZ") {
                return date.dateString(format ?? "yyyy-MM-dd HH:mm:ss")
            }
        }
        
        return value ?? ""
    }
}

//MARK: - 时间（24小时制 or 12小时制）
extension Date {
    // 是否是24小时
    public func is24H() -> Bool {
        let locale = NSLocale.current

        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!

        if dateFormat.contains("a") {
            return false
        }
        
        return true
    }
    
    public func HHMM() -> String {
        
        
        
        return ""
    }
}

//MARK: - 时间戳转换
extension Date {
    // 时间字符串 to 时间戳
    static func timeInterval(_ dateStr: String, _ format: String) -> TimeInterval {
        var interval: TimeInterval = 0
        
        if let date = date(dateStr, format) {
            interval = date.timeIntervalSince1970
        }
        
        return interval
    }
    
    // 时间戳 to 时间字符串
    static func dateString(of interval: TimeInterval, _ format: String) -> String {
        guard interval > 0 else {return ""}
        if String(Int(interval)).count == 13 {
            return dateString(msec: interval, format)
        }else if String(Int(interval)).count == 10 {
            return dateString(sec: interval, format)
        }
        
        return ""
    }
    
    // 时间戳 to 时间字符串（毫秒级）
    static func dateString(msec interval: TimeInterval, _ format: String) -> String {
        guard interval > 0 else {return ""}
        let timeInterval: TimeInterval = interval / 1000
        let date: Date = Date(timeIntervalSince1970: timeInterval)
        return date.dateString(format)
    }
    
    // 时间戳 to 时间字符串（秒级）
    static func dateString(sec interval: TimeInterval, _ format: String) -> String {
        guard interval > 0 else {return ""}
        let timeInterval: TimeInterval = interval
        let date: Date = Date(timeIntervalSince1970: timeInterval)
        return date.dateString(format)
    }
}

//MARK: - 星期
extension Date {
    // 数字转换为周几
    static func cycleStr(_ num: Int) -> String {
        switch num {
        case 0:
            return "周日"
        case 1:
            return "周一"
        case 2:
            return "周二"
        case 3:
            return "周三"
        case 4:
            return "周四"
        case 5:
            return "周五"
        case 6:
            return "周六"
        case 7:
            return "周日"
        default:
            return ""
        }
    }
    
    // 数字字符串转换为周几
    static func cycleStr(_ str: String) -> String {
        var string = str
        
        string.replace("1", "周一")
        string.replace("2", "周二")
        string.replace("3", "周三")
        string.replace("4", "周四")
        string.replace("5", "周五")
        string.replace("6", "周六")
        string.replace("7", "周日")
        
        return string
    }
    
    // 一周时间排序 str: "2,4,3,1"  +  spaceStr: ","  =  "周一,周二,周三,周四"
    static func cycleSortStr(_ str: String, _ spaceStr: String) -> String {
        guard str.count > 0 else {return str}
        let intArr = str.components(separatedBy: spaceStr).map{ Int($0) ?? 0 }.sorted(by: { $0 < $1 })
        let string = intArr.map{ cycleStr($0)}.joined(separator: spaceStr)
        
        return string
    }
    
    // 获取指定日期所在周的任意 weekDay 的日期 //
    // weekDay  -  1~7 '周一'~'周日'
    public func dateString(_ weekDay: Int, _ format: String) -> String {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
        if let week_day = components.weekday, let day = components.day {
            var diff = 0
            if week_day == 1 { // 默认 1 是 周日
                diff = weekDay - 7
            }else { // 2 ~ 7  -  '周一' ~ '周六'
                diff = weekDay - (week_day - 1)
            }
            
            components.setValue(day + diff, for: .day)
            if let date_goal: Date = calendar.date(from: components) {
                return date_goal.dateString(format)
            }
        }
        
        return ""
    }
}

//MARK: - 时间比较
extension Date {
    // 小于今天
    static func dateLessThanToday(_ time: TimeInterval, _ format: String) -> Bool {
        let s_s: String = dateString(of: time, format)
        let s: TimeInterval = timeInterval(s_s, format)
        let o: TimeInterval = timeInterval(Date.now(format), format)
        
        return s < o
    }
    
    // 小于明天
    static func dateLessThanTomorrow(_ time: TimeInterval, _ format: String) -> Bool {
        let s_s: String = dateString(of: time, format)
        let s: TimeInterval = timeInterval(s_s, format)
        let o: TimeInterval = timeInterval(Date.now(format), format) + 3600 * 24
        
        return s < o
    }
    
    // 小于
    static func dateLessThan(_ time: TimeInterval, _ other: TimeInterval, _ format: String) -> Bool {
        let s_s: String = dateString(of: time, format)
        let s: TimeInterval = timeInterval(s_s, format)
        let o_s: String = dateString(of: other, format)
        let o: TimeInterval = timeInterval(o_s, format)
        
        return s < o
    }
    
    // 大于明天
    static func dateMoreThanTomorrow(_ time: TimeInterval, _ format: String) -> Bool {
        let s_s: String = dateString(of: time, format)
        let s: TimeInterval = timeInterval(s_s, format)
        let o: TimeInterval = timeInterval(Date.now(format), format) + 3600 * 24
        
        return s > o
    }
    
    // 大于今天
    static func dateMoreThanToday(_ time: TimeInterval, _ format: String) -> Bool {
        let s_s: String = dateString(of: time, format)
        let s: TimeInterval = timeInterval(s_s, format)
        let o: TimeInterval = timeInterval(Date.now(format), format)
        
        return s > o
    }
    
    // 大于
    static func dateMoreThan(_ time: TimeInterval, _ other: TimeInterval, _ format: String) -> Bool {
        let s_s: String = dateString(of: time, format)
        let s: TimeInterval = timeInterval(s_s, format)
        let o_s: String = dateString(of: other, format)
        let o: TimeInterval = timeInterval(o_s, format)
        
        return s > o
    }
    
    // 相差多少天
    static func diffDayStr(_ dateStr: String, _ otherDateStr: String, _ format: String) -> String {
        let one = timeInterval(dateStr, format)
        let other = timeInterval(otherDateStr, format)
        
        let diff_day = fabs(one - other) / 24 / 3600
        
        return String(format: "%.1f天", diff_day)
    }
}

//MARK: - 特殊时间显示
extension Date {
    // 相差时间（n年n月n天n小时n分钟n小时）
    static func diffDateStr(_ dateStr: String, _ otherDateStr: String, _ format: String, components: Set<Calendar.Component>? = nil) -> String {
        guard let one_date = date(dateStr, format), let other_date = date(otherDateStr, format) else {return ""}
        
        let _components = components ?? [.year, .month, .day, .hour, .minute, .second]
        let diff_cmps = Calendar.current.dateComponents(_components, from: one_date, to: other_date)
        
        var dateString = ""
        
        if let year = diff_cmps.year, year > 0 {
            dateString += String(format: "%d年", year)
        }
        
        if let month = diff_cmps.month, month > 0 {
            dateString += String(format: "%d月", month)
        }
        
        if let day = diff_cmps.day, day > 0 {
            dateString += String(format: "%d天", day)
        }
        
        if let hour = diff_cmps.hour, hour > 0 {
            dateString += String(format: "%d小时", hour)
        }
        
        if let min = diff_cmps.minute, min > 0 {
            dateString += String(format: "%d分钟", min)
        }
        
        if let sec = diff_cmps.second, sec > 0 {
            dateString += String(format: "%d秒", sec)
        }
        
        return dateString
    }
    
    /// 返回: *天前
    static func beforeDay(_ dateStr: String, _ format: String) -> String {
        let date = timeInterval(dateStr, format)
        let now = Date().timeIntervalSince1970
        
        let s_day = Int(abs(date - now))
        
        if s_day < 60 {
            return "刚刚"
        }else if s_day < 3600 {
            return "\(s_day / 60)分钟前"
        }else if s_day < 24 * 3600 {
            return "\(s_day / 3600)小时前"
        }else if s_day < 30 * 24 * 3600 {
            return "\(s_day / 3600 / 24)天前"
        }else if s_day < 12 * 30 * 24 * 3600 {
            return "\(s_day / 3600 / 24 / 30)月前"
        }else {
            return "\(s_day / 3600 / 24 / 30 / 12)年前"
        }
    }
    
    static func smartTime(_ time: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: time / 1000)
        let diff_cmps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: Date())
        let format = DateFormatter()
        
        if diff_cmps.year == 0 { // 今年
            if diff_cmps.month == 0, diff_cmps.day == 1 { // 昨天
                format.dateFormat = "昨天 HH:mm"
                return format.string(from: date)
            }else if diff_cmps.month == 0, diff_cmps.day == 0 { // 今天
                if let h = diff_cmps.hour, h >= 1 {
                    return "\(h)小时前"
                }else if let m = diff_cmps.minute, m >= 1 {
                    return "\(m)分钟前"
                }else {
                    return "刚刚"
                }
            }else { // 今年的其他日子
                format.dateFormat = "MM-dd HH:mm"
                return format.string(from: date)
            }
        }else { // 非今年
            format.dateFormat = "yyyy-MM-dd HH:mm"
            return format.string(from: date)
        }
    }
    
    // *时*分 or *分 or *小时*分钟 or *分钟
    static func hour_min(_ min: Int, lessText: Bool? = false) -> String {
        let hourText = lessText! ? "时" : "小时"
        let minText = lessText! ? "分" : "分钟"
        if min / 60 > 0 {
            return "\(min / 60)\(hourText)\(min % 60)\(minText)"
        }
        return "\(min % 60)\(minText)"
    }
}
