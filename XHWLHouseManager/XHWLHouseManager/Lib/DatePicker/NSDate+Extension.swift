//
//  XHWLDatePicker.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/25.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

let xDateFormatYYYYMMDD:String = "YYYY-MM-DD"
let xDateFormatYYMMDDTHHmmss:String = "yyyy-MM-dd'T'HH:mm:ss"

extension Calendar {
    
    static var sharedCalendar: Calendar {
        struct Static {
            static var instance = Calendar.current
        }
        
        return Static.instance
    }
}

extension Date {

    static var shareDateFormatter: DateFormatter {
        struct Static {
            static var instance = DateFormatter()
        }
        
        Static.instance.timeZone = TimeZone.init(abbreviation: "CCD")
        Static.instance.dateFormat = xDateFormatYYYYMMDD
        
        return Static.instance
    }
    
    func dateByAddingDays(_ days:NSInteger) -> Date {
        let calendar:Calendar = Calendar.sharedCalendar
        var components:DateComponents = DateComponents()
        components.day = days
        
        return calendar.date(byAdding: components, to: self)!
    }

    func daysBetween(_ aDate:Date) -> NSInteger {
        let unitFlags:Set<Calendar.Component> = [.day] //
        let from:Date = Date.at_dateFromString(self.stringForYearMonthDayDashed())
        let to:Date = Date.at_dateFromString(aDate.stringForYearMonthDayDashed())
        let calendar:Calendar = Calendar.init(identifier: .gregorian)
        let components:DateComponents = calendar.dateComponents(unitFlags , from: from, to: to)
        
        return labs(components.day!) + 1
    }

    func stringForYearMonthDayDashed() -> String {
        
        return stringForFormat(xDateFormatYYYYMMDD)
    }
    
    func stringForFormat(_ format:String) ->String {
        if format.isEmpty {
            return ""
        }
        
        let formatter:DateFormatter = Date.shareDateFormatter
        formatter.dateFormat = format
        
        let timeStr:String = formatter.string(from: self)
        
        return timeStr
    }
    
    static func at_dateFromString(_ dateString:String) -> Date {
        let dateFormatter:DateFormatter = self.shareDateFormatter
        
        if NSString.init(string: dateString).length > NSString.init(string: xDateFormatYYYYMMDD).length {
            dateFormatter.dateFormat = xDateFormatYYMMDDTHHmmss
        } else {
            dateFormatter.dateFormat = xDateFormatYYYYMMDD
        }
        let date:Date = dateFormatter.date(from: dateString)!

        return date
    }
}

