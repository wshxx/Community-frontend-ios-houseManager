//
//  XHWLVisitLogModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/22.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit



class XHWLVisitLogModel: NSObject {

    var sysVisitor:XHWLVisitorModel = XHWLVisitorModel()
    var yzName:String = ""

//    func mj_objectClassInArray() -> [AnyHashable : Any]! {
//        return ["sysVisitor":XHWLVisitorModel.self] // [JZMJewelryCategoryModel class]
//    }

    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }

    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}

class XHWLVisitorModel:NSObject {
    var id:String = ""
    var name:String = ""
    var type:String = ""
    var sex:String = ""
    var telephone:String = ""
    var certificateType:String = ""
    var cetificateNo:String = ""
    var timeUnit:String = ""
    var timeNo:String = ""
    var carNo:String = ""
    var accessTime:String = "" // 进入时间
    var leaveTime:String = ""
    var accessReason:String = ""
    var qrCode:String = ""
    var sysAccount:XHWLSysAccountModel = XHWLSysAccountModel()
    var roomNo:String = ""
    var sysAccountName:String = ""
    var isYZAgree:String = ""  // n 拒绝 y 同意
    var registTime:String = "" // 登记时间
    var effectiveTime:String = "" // 有效时间
    var effectiveTimes:String = "" // 有效次数
    var remainTimes:String = "" // 滞留时间
    var isYZInvitation:String = ""
    var accessWay:String = ""

//    func mj_objectClassInArray() -> [AnyHashable : Any]! {
//        return ["sysAccount":XHWLSysAccountModel.self] // [JZMJewelryCategoryModel class]
//    }

    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }

    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}

class XHWLSysAccountModel:NSObject {
    var id:String = ""
    var loginTime:String = ""
    var name:String = ""
    var password:String = ""
    var token:String = ""
    var weChat:String = ""
};

