//
//  String+Validation.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/22.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

extension String {
    
    //验证身份证
    func validateIDCardNumber() -> Bool {
//        if self.characters.count != 18 {
//            return false
//        }
//        let codeArray = ["7","9","10","5","8","4","2","1","6","3","7","9","10","5","8","4","2"]
//        let checkCodeDic = NSDictionary(objects: ["1","0","X","9","8","7","6","5","4","3","2"], forKeys: ["0","1","2","3","4","5","6","7","8","9","10"])
//        let scan = NSScanner(string: self.substringToIndex(self.startIndex.advancedBy(17)))
//        
//        var val:Int32 = 0
//        let isNum = scan.scanInt(&val) && scan.atEnd
//        if !isNum {
//            return false
//        }
//        var sumValue = 0
//        for i in 0  ..< 17  {
//            sumValue += Int(self.substringWithRange(Range(start: self.startIndex.advancedBy(i),end: self.startIndex.advancedBy(i+1))))! * Int(codeArray[i])!
//        }
//        let obj = checkCodeDic.objectForKey("\(sumValue%11)")
//        if obj == nil {
//            return false
//        }else {
//            if String(obj!) == self.substringWithRange(Range(start: self.startIndex.advancedBy(17),end: self.startIndex.advancedBy(18))).uppercaseString {
//                return true
//            }
//        }
        
        return false
    }
    
    
    
    // 验证身份证
    func validateIDCardNumber(_ sfz:String)->Bool{
        
//        let value = sfz.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        
//        var length = 0
//        if value == ""{
//            return false
//        }else{
//            length = value.characters.count
//            if length != 15 && length != 18{
//                return false
//            }
//        }
//        
//        //省份代码
//        let arearsArray = ["11","12", "13", "14",  "15", "21",  "22", "23",  "31", "32",  "33", "34",  "35", "36",  "37", "41",  "42", "43",  "44", "45",  "46", "50",  "51", "52",  "53", "54",  "61", "62",  "63", "64",  "65", "71",  "81", "82",  "91"]
//        let valueStart2 = (value as NSString).substringToIndex(2)
//        var arareFlag = false
//        if arearsArray.contains(valueStart2){
//            
//            arareFlag = true
//        }
//        if !arareFlag{
//            return false
//        }
//        var regularExpression = NSRegularExpression()
//        
//        var numberofMatch = Int()
//        var year = 0
//        switch (length){
//        case 15:
//            year = Int((value as NSString).substringWithRange(NSRange(location:6,length:2)))!
//            if year%4 == 0 || (year%100 == 0 && year%4 == 0){
//                do{
//                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: .CaseInsensitive) //检测出生日期的合法性
//                    
//                }catch{
//                    
//                    
//                }
//                
//                
//            }else{
//                do{
//                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: .CaseInsensitive) //检测出生日期的合法性
//                    
//                }catch{}
//            }
//            
//            numberofMatch = regularExpression.numberOfMatchesInString(value, options:NSMatchingOptions.ReportProgress, range: NSMakeRange(0, value.characters.count))
//            
//            if(numberofMatch > 0) {
//                return true
//            }else {
//                return false
//            }
//            
//        case 18:
//            year = Int((value as NSString).substringWithRange(NSRange(location:6,length:4)))!
//            if year%4 == 0 || (year%100 == 0 && year%4 == 0){
//                do{
//                    regularExpression = try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$", options: .CaseInsensitive) //检测出生日期的合法性
//                    
//                }catch{
//                    
//                }
//            }else{
//                do{
//                    regularExpression =  try NSRegularExpression.init(pattern: "^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$", options: .CaseInsensitive) //检测出生日期的合法性
//                    
//                }catch{}
//            }
//            
//            numberofMatch = regularExpression.numberOfMatchesInString(value, options:NSMatchingOptions.ReportProgress, range: NSMakeRange(0, value.characters.count))
//            
//            if(numberofMatch > 0) {
//                let s =
//                    (Int((value as NSString).substringWithRange(NSRange(location:0,length:1)))! +
//                        Int((value as NSString).substringWithRange(NSRange(location:10,length:1)))!) * 7 +
//                        (Int((value as NSString).substringWithRange(NSRange(location:1,length:1)))! +
//                            Int((value as NSString).substringWithRange(NSRange(location:11,length:1)))!) * 9 +
//                        (Int((value as NSString).substringWithRange(NSRange(location:2,length:1)))! +
//                            Int((value as NSString).substringWithRange(NSRange(location:12,length:1)))!) * 10 +
//                        (Int((value as NSString).substringWithRange(NSRange(location:3,length:1)))! +
//                            Int((value as NSString).substringWithRange(NSRange(location:13,length:1)))!) * 5 +
//                        (Int((value as NSString).substringWithRange(NSRange(location:4,length:1)))! +
//                            Int((value as NSString).substringWithRange(NSRange(location:14,length:1)))!) * 8 +
//                        (Int((value as NSString).substringWithRange(NSRange(location:5,length:1)))! +
//                            Int((value as NSString).substringWithRange(NSRange(location:15,length:1)))!) * 4 +
//                        (Int((value as NSString).substringWithRange(NSRange(location:6,length:1)))! +
//                            Int((value as NSString).substringWithRange(NSRange(location:16,length:1)))!) *  2 +
//                        Int((value as NSString).substringWithRange(NSRange(location:7,length:1)))! * 1 +
//                        Int((value as NSString).substringWithRange(NSRange(location:8,length:1)))! * 6 +
//                        Int((value as NSString).substringWithRange(NSRange(location:9,length:1)))! * 3
//                
//                let Y = s%11
//                var M = "F"
//                let JYM = "10X98765432"
//                
//                M = (JYM as NSString).substringWithRange(NSRange(location:Y,length:1))
//                if M == (value as NSString).substringWithRange(NSRange(location:17,length:1))
//                {
//                    return true
//                }else{return false}
//                
//                
//            }else {
//                return false
//            }
        
//        default:
            return false
//        }
    }
    
    
//    struct MyRegex {
//        let regex: NSRegularExpression?
//        
//        init(_ pattern: String) {
//            regex = try? NSRegularExpression(pattern: pattern,
//                                             options: .CaseInsensitive)
//        }
//        
//        func match(input: String) -> Bool {
//            if let matches = regex?.matchesInString(input,
//                                                    options: [],
//                                                    range: NSMakeRange(0, (input as NSString).length)) {
//                return matches.count > 0
//            } else {
//                return false
//            }
//        }
//    }
//    
//    let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
//    let matcher = MyRegex(mailPattern)
//    let maybeMailAddress = "admin@hangge.com"
//    if matcher.match(maybeMailAddress) {
//    print("邮箱地址格式正确")
//    }else{
//    print("邮箱地址格式有误")
//    }
}
