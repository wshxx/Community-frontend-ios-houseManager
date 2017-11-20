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
    var operatorName:String = ""
    var roadName:String = ""
    var handleTime:String = ""
    var handleName:String = ""
    var id :String = ""
    var outExceptionId:String = ""
    var status:String = "" // n拒绝 y同意
    var uploadTime:String = ""
    var wyAccount:XHWLAccountModel = XHWLAccountModel()
    
    func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return [
            "operatorName" : "operator"
        ]
    }
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["wyAccount":XHWLAccountModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}
