//
//  XHWLAccountModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/14.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLAccountModel: NSObject {
    
    var id:String = ""
    var workCode:String = ""
    var name:String = ""
    var password:String = ""
    var weChat:String = ""
    var token:String = ""
    var loginTime:String = ""
    var talkbackUUID:String = ""
    var wyRole:XHWLRoleModel = XHWLRoleModel()
    var wyRoleName:String = ""
    var isFirstLogin:String = ""
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["wyRole":XHWLRoleModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}


