//
//  Validation.swift
//  XHWLHouseOwner
//
//  Created by 柳玉豹 on 2017/8/19.
//  Copyright © 2017年 xinghaiwulian. All rights reserved.
//

import Foundation

/*
 * 验证各种文本的格式
 * 使用方式：Validation.email("blog@@csdn.com").isRight //false
*/
enum Validation {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    
    case URL(_: String)
    case IP(_: String)
    case carNo(_: String) // 车牌
    case cardNum(_:String) // 身份证
    case passNum(_:String) // 护照
    
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
//            /*
//             手机号码
//             移动: 134[0-8], 135, 136, 137, 138, 139, 150, 151, 158, 159, 182, 187, 188
//             联通: 130, 131, 132, 152, 155, 156, 185, 186
//             电信: 133, 1349, 153, 180, 189
//             */
//
// 
//            NSString * MOBILE = @"@^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//            /*
//             中国移动: China Mobile
//             移动: 134[0-8], 135, 136, 137, 138, 139, 150, 151, 158, 159, 182, 187, 188
//             */
//
//            NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//            /*
//             中国联通: China Unicom
//             联通: 130, 131, 132, 152, 155, 156, 185, 186
//             */
//
//            NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//            /*
//             中国电信: China Telecom
//             电信: 133, 1349, 153, 180, 189
//             */
//
//            NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//            /*
//             大陆地区固定电话及小灵通
//             区号: 010, 020, 021, 022, 023, 024, 025, 027, 028, 029
//             号码: 七位或八位
//             */
            
            predicateStr = "^[1][358]\\d{9}"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        case let .carNo(str):
//            第一：现在大多数车牌
//            1.常规车牌号：仅允许以汉字开头，后面可录入六个字符，由大写英文字母和阿拉伯数字组成。如：粤B12345；
//            2.最后一个为汉字的车牌：允许以汉字开头，后面可录入六个字符，前五位字符，由大写英文字母和阿拉伯数字组成，而最后一个字符为汉字，汉字包括“挂”、“学”、“警”、“港”、“澳”。如：粤Z1234港。
//            3.新军车牌：以两位为大写英文字母开头，后面以5位阿拉伯数字组成。如：BA12345。
//            我的正则：/^[冀豫云辽黑湘皖鲁苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼渝京津沪新京军空海北沈兰济南广成使领A-Z]{1}[a-zA-Z0-9]{5}[a-zA-Z0-9挂学警港澳]{1}$/;
//            是没问题的
//
//            第二：新能源车
//            组成：省份简称（1位汉字）+发牌机关代号（1位字母）+序号（6位），总计8个字符，序号不能出现字母I和字母O
//            通用规则：不区分大小写，第一位：省份简称（1位汉字），第二位：发牌机关代号（1位字母）
//            序号位：
//            小型车，第一位：只能用字母D或字母F，第二位：字母或者数字，后四位：必须使用数字
//            大型车，前五位：必须使用数字，第六位：只能用字母D或字母F。
//            正则：[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领]{1}[a-zA-Z]{1} (([D|F]{1}[a-zA-Z0-9]{1}[0-9]{4}) | ([0-9]{5}[D|F]{1}))

            predicateStr = "^([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1})|([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领]{1}[a-zA-Z]{1}(([D|F]{1}[a-zA-Z0-9]{1}[0-9]{4})|([0-9]{5}[D|F]{1})))$"
            currObject = str
        case let .cardNum(str):
            
//            predicateStr = "^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$"
            predicateStr = "^((11|12|13|14|15|21|22|23|31|32|33|34|35|36|37|41|42|43|44|45|46|50|51|52|53|54|61|62|63|64|65)[0-9]{4})(([1|2][0-9]{3}[0|1][0-9][0-3][0-9][0-9]{3}[Xx0-9])|([0-9]{2}[0|1][0-9][0-3][0-9][0-9]{3}))$"
            currObject = str
        case let .passNum(str):
//            护照号码的格式：
//            因私普通护照号码格式有:14/15+7位数,G+8位数；因公普通的是:P.+7位数；
//            公务的是：S.+7位数 或者 S+8位数,以D开头的是外交护照.D=diplomatic
//            ^1[45][0-9]{7}|G[0-9]{8}|P[0-9]{7}|S[0-9]{7,8}|D[0-9]+$
            
//            /^[a-zA-Z0-9]{3,21}$/   /^(P\d{7})|(G\d{8})$/
            predicateStr = "^([a-zA-Z0-9]{5,17})|([a-zA-Z]{5,17})$"
            currObject = str
            
//            [HMhm]{1}([0-9]{10}|[0-9]{8}) 港澳通行证
//            var re1 = /^[0-9]{8}$/; var re2 = /^[0-9]{10}$/; 台湾通行证
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluate(with:currObject)
    }
    
    
}
