//
//  XHWLChannelModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/16.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLChannelModel: NSObject {
    var id:String = ""
    var name:String = ""
    var wyAccount:NSArray = NSArray()
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["wyAccount":XHWLChannelRoleModel.self]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}

class XHWLChannelRoleModel: NSObject {

    var id:String = ""
    var workCode:String = ""
    var wyUserName:String = ""
}
