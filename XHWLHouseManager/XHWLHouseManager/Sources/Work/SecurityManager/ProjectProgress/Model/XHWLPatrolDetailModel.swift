//
//  XHWLPatrolDetailModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/27.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPatrolDetailModel: NSObject {

    var count:String = ""
    var lineList:NSMutableArray = NSMutableArray()
    var progress:String = ""
    var totalChecksDetail:NSArray = NSArray()
    var isFlod:Bool = false
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["totalChecksDetail":XHWLPatrolTotalCheckModel.self,
                "lineList":XHWLPatrolLineModel.self
        ] // [JZMJewelryCategoryModel class]
    }
}

class XHWLPatrolLineModel: NSObject {
    var count:String = ""
    var currentTimePlanChecksList:NSArray = NSArray()
    var currentTimeChecksDetail:NSArray = NSArray()
    var endDate:String = ""
    var fri:String = ""
    var lineId:String = ""
    var lineName:String = ""
    var mon:String = ""
    var planTime:NSArray = NSArray()
    var progress:String = ""
    var sat:String = ""
    var startDate:String = ""
    var sun:String = ""
    var thu:String = ""
    var tue:String = ""
    var wed:String = ""
    var isFlod:Bool = false
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["currentTimeChecksDetail":XHWLPatrolTotalCheckModel.self,
                "currentTimePlanChecksList":XHWLPatrolTotalCheckModel.self,
                "planTime":XHWLPatrolPlanTimeModel.self
        ]
    }
}

class XHWLPatrolPlanTimeModel: NSObject {
    var count:String = ""
    var endTime:String = ""
    var progress:String = ""
    var startTime:String = ""
}

class XHWLPatrolTotalCheckModel: NSObject {
    var arriveTime:String = ""
    var arriveType:String = ""
    var lineId:String = ""
    var lineName:String = ""
    var nodeId:String = ""
    var nodeName:String = ""
    var orderNum:String = ""
}


