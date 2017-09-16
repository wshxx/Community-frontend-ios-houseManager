//
//  XHWLIssueAccountModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLIssueAccountModel: NSObject {
    var id:String = ""
    var name:String = ""
    var password:String = ""
    var token:String = ""
    var weChat:String = ""
    var loginTime:String = ""
    var wyRole:XHWLRoleModel = XHWLRoleModel()
    var talkbackUUID:String = ""
    var wyRoleName:String = ""
    
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
