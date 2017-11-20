//
//  XHWLProjectModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/14.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLProjectModel: NSObject {
    var id:String = ""
    var sysDivision:XHWLSysDivisionModel = XHWLSysDivisionModel()
    var name:String = ""
    var code:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var divisionName:String = ""
    
    var ccProjectCode:String = ""
    var entranceCode:String = ""
    var patrolCode:String = ""
    var parkingCode:String = ""
    var nodeID:String = ""
    var nodeType:String = ""

    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["sysDivision":XHWLSysDivisionModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}

class XHWLSysDivisionModel: NSObject {
    
    var id = ""
    var name = ""
    var code = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}
