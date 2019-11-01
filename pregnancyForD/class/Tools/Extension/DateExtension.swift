//
//  NSDate-Extension.swift
//  04-时间的处理
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

import Foundation


extension Date {
    
    static func createTimeWithString(_ number : NSNumber) -> String {
        
        let milliseconds = number.int64Value
        let timeStamp = TimeInterval.init(milliseconds)/1000.0
        let createDate = Date.init(timeIntervalSince1970: timeStamp)
        
        return Date.timeStr(date : createDate)
    }
    
    static func timeStr(date : Date)->String{
        // 创建时间格式化对象
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "en")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 获取当前时间
        let nowDate = Date()
        
        // 获取创建时间和当前时间差
        let interval = Int(nowDate.timeIntervalSince(date))
        
        // 判断时间显示的格式
        // 5.1.1分钟之内
        if interval < 60 {
            return "刚刚"
        }
        
        // 5.2.一个小时内
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        // 5.3.一天之内
        if interval < 60 * 60 * 24 {
            return "\(interval / 60 / 60)小时前"
        }
        
        // 6.其他时间的显示
        // 6.1.创建日期对象
        let calendar = Calendar.current
        
        // 6.2.昨天的显示
        if calendar.isDateInYesterday(date) {
            fmt.dateFormat = "HH:mm"
            let timeString = fmt.string(from: date)
            return "昨天 \(timeString)"
        }
        
        // 6.3.一年之内
        let cpns = (calendar as NSCalendar).components(NSCalendar.Unit.year, from: date, to: nowDate, options: [])
        if cpns.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeString = fmt.string(from: date)
            return timeString
        }
        
        // 6.4.一年以上
        fmt.dateFormat = "yyyy-MM-dd"
        let timeString = fmt.string(from: date)
        
        return timeString
    }
    
    
    static func convertTimeStr(_ timeS : String)->String{
        let fmt = DateFormatter.init()
        fmt.locale = Locale(identifier: "en")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = fmt.date(from: timeS)
        
        return Date.timeStr(date : date!)
    }
    
    static func convertTimeStrToDouble(_ timeS : String)->TimeInterval{
        let fmt = DateFormatter.init()
        fmt.locale = Locale(identifier: "en")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = fmt.date(from: timeS)
        let t = date?.timeIntervalSince1970
        return t ?? 0
    }
    
    static func isWithin24hours(_ number : NSNumber) -> Bool{
        
        let milliseconds = number.intValue
        let timeStamp = TimeInterval.init(milliseconds)/1000.0
        let createDate = Date.init(timeIntervalSince1970: timeStamp)
        // 3.获取当前时间
        let nowDate = Date()
        
        // 4.获取创建时间和当前时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        // 1天之内 60 * 60 * 24 
        if interval < 86400 {
            return true
        }else{
            return false
        }

    }
    
    static func isNot24hours(_ dateStr : String) -> Bool{
        HCPrint(message: dateStr)
        let fmt = DateFormatter.init()
        fmt.locale = Locale(identifier: "en")
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let lastTime = fmt.date(from: dateStr)
    
        //获取当前时间a
        let nowDate = Date()
        
        // 获取创建时间和当前时间差
        let interval = Int(nowDate.timeIntervalSince(lastTime!))
        
        // 1天之内 60 * 60 * 24
        if interval < 86400 {
            return true
        }else{
            return false
        }
        
    }
}
