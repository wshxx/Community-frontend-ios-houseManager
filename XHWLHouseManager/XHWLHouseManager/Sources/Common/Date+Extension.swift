//
//  Date+Extension.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/20.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

extension Date {

    // MARK: - 获取当前时间戳
    static func stringToStamp(_ timeStr:String) -> Int {
        //获取当前时间
        let now:Date = stringToDate(timeStr)
        
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print("当前时间的时间戳：\(timeStamp)")
        
        return timeStamp
    }
    
    // MARK: - 获取当前时间戳
    static func getCurrentStamp() -> Int {
        //获取当前时间
        let now = Date()
        
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print("当前时间的时间戳：\(timeStamp)")
        
        return timeStamp
    }
    
    // MARK: - 时间字符串转Date
    static func stringToDate(_ dateStr:String) -> Date {
        
        let toDate:Date = stringToDate(dateStr, "yyyy-MM-dd HH:mm:ss")
        
        return toDate
    }
    
    static func stringToDate(_ dateStr:String, _ dateFormat:String) -> Date {
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        let toDate:Date = dformatter.date(from: dateStr)!
        
        return toDate
    }
    
    // MARK: - 当前时间字符串
    static func getCurrentDate()->String {
        let dateStr = getCurrentDate("yyyy-MM-dd HH:mm:ss")
        
        return dateStr
    }
    
    static func getCurrentDate(_ dateFormat:String)->String {
        let date = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = dateFormat
        let dateStr = dformatter.string(from: date)
        
        return dateStr
    }
    
    // MARK: - 时间戳转时间字符串
    static func getDateWith(_ timeStamp:Int) -> String {
        return self.getDateWith(timeStamp, "yyyy/MM/dd")
    }
    
    static func getStringDate(_ timeStamp:Int) -> String {
        return self.getDateWith(timeStamp, "yyyy-MM-dd HH:mm:ss")
    }
    
    static func getDateWith(_ timeStamp:Int, _ formatString:String) -> String {
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = formatString
        print("对应的日期时间：\(dformatter.string(from: date))")
        
        return dformatter.string(from: date)
    }
}
