//
//  XHWLRoleModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/13.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRoleModel: NSObject {
    var code:String = ""
    var id:String = ""
    var name:String = "" // 工程、安管主任、安管人员
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}
