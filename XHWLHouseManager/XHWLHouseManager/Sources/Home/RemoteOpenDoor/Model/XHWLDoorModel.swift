//
//  XHWLDoorModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/2.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDoorModel: NSObject {

    var id:String = ""
    var sysBuilding:XHWLBuildingModel = XHWLBuildingModel()
    var name:String = ""
    var code:String = ""
    var address:String = ""
    var buildingName:String = ""
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["sysBuilding":XHWLBuildingModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}

class XHWLBuildingModel: NSObject {
    var id:String = ""
    var sysProject:XHWLProjectModel = XHWLProjectModel()
    var name:String = ""
    var code:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var projectName:String = ""
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["sysProject":XHWLProjectModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}
