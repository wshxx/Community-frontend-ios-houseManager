//
//  XHWLRealProgressModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/19.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRealProgressModel: NSObject {
    
    var count:String = ""
    var nickname:String = ""
    var lineList:NSArray = NSArray()
    var userId:String = ""
    var progress:String = ""
    var isFlod:Bool = false
    var totalChecksDetail:NSArray = NSArray()
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["lineList":XHWLLineModel.self,
        "totalChecksDetail":XHWLCheckDetailModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}

class XHWLLineModel: NSObject {
    
    var count:String = ""
    var currentTimeChecksDetail:NSArray = NSArray()
    var endDate:String = ""
    var fri:String = ""
    var lineId:String = ""
    var lineName:String = ""
    var mon:String = ""
    var planTime:NSArray = NSArray()
    var progress:String = ""
    var sat:String = ""
    var startDate :String = ""
    var sun :String = ""
    var thu:String = ""
    var tue:String = ""
    var wed:String = ""

    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["planTime":XHWLPlanTimeModel.self,
                "currentTimeChecksDetail":XHWLCheckDetailModel.self] // [JZMJewelryCategoryModel class]
    }
}

class XHWLPlanTimeModel:NSObject {
    var count:String = ""
    var endTime:String = ""
    var progress:String = ""
    var startTime:String = ""
}
//{
//    var arriveTime = "";
//    var arriveType = "-1";
//    var nodeId = 2653;
//    var nodeName = ceshi1;
//    var orderNum = 2;
//}

class XHWLCheckDetailModel:NSObject {
//    var arriveTime:String = ""
//    var arriveType:String = "" //-1未巡更 0 已巡更
//    var collectNodeId:String = ""
//    var endTime:String = ""
//    var nodeName:String = ""
//    var startTime:String = ""
//    var userId:String = ""
    var isFlod:Bool = false
    
    var arriveTime:String = ""
    var arriveType:String = ""
    var lineId:String = ""
    var lineName:String = ""
    var nodeId:String = ""
    var nodeName:String = ""
    var orderNum:String = ""

    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}



