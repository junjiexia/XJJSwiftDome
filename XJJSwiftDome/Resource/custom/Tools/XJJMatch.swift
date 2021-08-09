//
//  XJJMatch.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/2.
//

/***************************<以下内容摘录于：http://www.cocoachina.com/ios/20150415/11568.html>
 字面的“\\.”定义了一个字符串:\.
 正则表达式\.则是匹配一个单个的句号字符.
 .匹配任一字符。p.p匹配pop,pup,pmp,p@p等等。
 \w匹配任意“word-like”字符，包括数字，字母，下划线，不过不能匹配标点符号和其他字符。hello\w会匹配”hello_“,”hello9”和”helloo”,但不匹配”hello!”。
 \d 匹配数字，大部分情况下是[0-9]。\d\d?:\d\d会匹配时间格式的字符串，比如”9：30“和”12：45“。
 \b 匹配额外的字符，例如空格，标点符号。to\b 会匹配”to the moon”和“to!”中得“to”,但是不会匹配“tomorrow”。\b 用在整个单词的匹配方面和方便。
 \s 会匹配空白字符，比如，空格，制表符，换行符。hello\s 会匹配“Well,hello there!”中的 “hello ”。
 ^用在一行的开始。记住，这个特殊的^不同于方括号中的^!例如，^Hello 会匹配字符串“Hello there”，而不会去匹配“He said Hello”。
 $ 用在一行的结束，例如，the end$ 会匹配“It was the end” 而不会去匹配 “the end was near”。
 * 匹配 它之前的元素0次或多次。12*3  会匹配 13, 123, 1223, 122223, 和 1222222223。
 + 匹配 它之前的元素1次或多次. 12+3  会匹配  123, 1223, 122223, 和 1222222223。
 花括号{}包含了匹配的最大和值最小个数。例如，10{1，2}1会匹配“101”和“1001”，而不会匹配“10001”，因为匹配的最小个数为1，最大个数为2。He[LI]{2,}o会匹配“HeLLo”和“HellLLLIo”和任意其他的“hello”添加多个L的变种，所以没有限制，因为，最少的个数是2，最大的个数没有设置。
 */
 
import Foundation

/* 比较方法
    * NSPredicate（谓词）
    * NSRegularExpression（系统的正则表达式类）可获取匹配到的内容
*/

/* NSRegularExpression.Options:
    caseInsensitive             // 不区分大小写的
    allowCommentsAndWhitespace  // 允许注释和空白
    ignoreMetacharacters        // 忽略元字符    :---  \  ^  $  .  |  ?  *  +  ()  []  {}
    dotMatchesLineSeparators    // 匹配任何字符，包括行分隔符
    anchorsMatchLines           // 允许^和$在匹配的开始和结束行
    useUnixLineSeparators       // 使用Unix行分隔符
    useUnicodeWordBoundaries    // 使用Unicode单词边界
 */

/* NSRegularExpression.MatchingOptions:
    reportProgress              // 在长时间运行的匹配操作期间定期调用块。
    reportCompletion            // 在完成任何匹配后调用块一次。
    anchored                    // 将匹配限制为搜索范围开始处的匹配
    withTransparentBounds       // 允许匹配查找超出搜索范围的范围。
    withoutAnchoringBounds      // 防止^和$自动匹配搜索范围的开头和结尾。
 */

fileprivate class XJJMatch {
    /*
        * org 原始字串
        * nor 规则字串
     */
    fileprivate class func predicate_match(_ org: String, nor: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", nor)
        return predicate.evaluate(with:org)
    }
    
    fileprivate class func regex_match(matchStrings org: String, nor: String) -> [String] {
        var matchString: [String] = []
        do {
            let regex = try NSRegularExpression(pattern: nor, options: .caseInsensitive)
            let results = regex.matches(in: org, options: .reportProgress, range: NSMakeRange(0, org.count))
            if results.count > 0 {
                for result in results {
                    let string = org.sub(result.range.location, result.range.length)
                    matchString.append(string)
                }
            }else {
                //print("正则比较  ", org, " - ", nor, " 不匹配！")
            }
        } catch {
            print("正则比较  ", org, " - ", nor, " 出现错误: ", error)
        }
        
        return matchString
    }
}


//MARK: - 其他类扩展
extension String {
    func isPhoneNumber() -> Bool {
        return XJJMatch.predicate_match(self, nor: ExpPhone.china)
    }
    
    func isNormalTitle() -> Bool {
        return XJJMatch.predicate_match(self, nor: ExpText.title)
    }
    
    func isNormalDescription() -> Bool {
        return XJJMatch.predicate_match(self, nor: ExpText.description)
    }
    
    func hasEmoji() -> Bool {
        for char in self {
            if ExpText.nineKey.contains(char) { // 九宫格的符号不算所表情，跳过
                continue
            }else if XJJMatch.predicate_match(String(char), nor: ExpText.emoji) {
                return true
            }
        }
        
        return false
    }
    
    func isMac() -> Bool {
        return XJJMatch.predicate_match(self, nor: ExpMac.mac)
    }
    
    func isPsw() -> Bool {
        return XJJMatch.predicate_match(self, nor: ExpPassword.letter_number)
    }
    
    func isNineKey() -> Bool {
        for char in self {
            if ExpText.nineKey.contains(char) {
                return true
            }
        }
        return false
    }
}



//MARK: - 正则表达式（规则）
fileprivate struct ExpEmail {
    static let general = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9]+\\.[A-Za-z]{1,4}$"
}

fileprivate struct ExpPassword {
    //有数字和字母，至少有一个数字和字母
    /*
     ^ 匹配一行的开头位置
     (?![0-9]+$) 预测该位置后面不全是数字
     (?![a-zA-Z]+$) 预测该位置后面不全是字母
     [0-9A-Za-z] {6,10} 由6-10位数字或这字母组成
     $ 匹配行结尾位置
     */
    static let least_one_letter_number = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10}$"
    static let letter_number = "^[A-Za-z0-9]+$"
}

fileprivate struct ExpPhone {
    static let general = "^[0-9+]{1,32}$"
//    static let china = "^(13[0-9]{9})|(14[0-9]{9})|(15[0-9]{9})|(16[0-9]{9})|(17[0-9]{9})|(18[0-9]{9})|(19[0-9]{9})$"
    static let china = "^1[3-9][0-9]{9}$"
    static let china_mobile = "^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$"
    static let china_unicom = "^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$"
    static let china_telecom = "^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$"
}

fileprivate struct ExpWebsite {
    static let general = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
}

fileprivate struct ExpText {
    static let title = "^[A-Za-z0-9\\u4e00-\\u9fa5]+$" // 一般的名称、标题（只含有中文、字母、数字）
    
    // 特殊文字（含有中文、字母、数字，以及其他一些特殊符号）
    // 特殊符号可根据需要更改
    static let description = "^[a-zA-Z0-9\\u4E00-\\u9FA5\\u278b-\\u2792,.;:?!。，！？-_：；\"\"“”、‘’''()（） /<>《》·~@#￥$%^&*=+|]+$"
    
    // 表情 //
    static let emoji = "^[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]+$"
    
    // 九宫格输入 //
    static let nineKey = "➋➌➍➎➏➐➑➒"
}

fileprivate struct ExpMac {
    static let mac = "^[0-9A-Fa-f:]+$"
}
