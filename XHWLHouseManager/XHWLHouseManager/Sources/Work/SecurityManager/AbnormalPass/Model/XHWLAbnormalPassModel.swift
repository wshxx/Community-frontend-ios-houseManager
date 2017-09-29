//
//  XHWLAbnormalPassModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/28.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLAbnormalPassModel: NSObject {

    var cardNo:String = ""
    
    var project:String = ""
    var station:String = ""
    var reason:String = ""
    var inDate:String = ""
    var roadCode:String = ""
    var outDate:String = ""
    var date:String = ""
    var oper:String = ""
    var roadName:String = ""
    
    func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return [
            "oper" : "operator"
        ]
    }
    
//    func mj_objectClassInArray() -> [AnyHashable : Any]! {
//        return ["sysProject":XHWLSysProject.self] // [JZMJewelryCategoryModel class]
//    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
    
}
