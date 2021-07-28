//
//  String+FD.swift
//  Tools
//
//  Created by Mac on 2021/5/20.
//

import Foundation

extension String {
    static let addNotification = "addNotification";
    
    
    public func getUrls() -> [String] {
        var urls = [String]()
        // 创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            // 匹配字符串，返回结果集
            let  result = dataDetector.matches(in:self, options:NSRegularExpression.MatchingOptions(rawValue: 0), range:NSMakeRange(0, self.count))
            // 取出结果
            for checkingRes in result {
                urls.append((self as NSString).substring(with:checkingRes.range))
            }
        }
        catch {
            debugPrint(error)
        }
        return urls
    }
}
