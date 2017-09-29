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
    var planChecksList:NSArray = NSArray()
    var userId:String = ""
    var progress:String = ""
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["planChecksList":XHWLListModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}

class XHWLListModel:NSObject {
    var arriveTime:String = ""
    var arriveType:String = "" //-1未巡更 0 已巡更
    var collectNodeId:String = ""
    var endTime:String = ""
    var nodeName:String = ""
    var startTime:String = ""
    var userId:String = ""

    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}



