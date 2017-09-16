//
//  XHWLUserModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/13.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLUserModel: NSObject {
    
    var name:String = ""
    var code:String = ""
    var telephone:String = ""
    var identity:String = ""
    var sex:String = ""
    var wyAccountName:String = ""
    var id:String = ""
    var wyAccount:XHWLAccountModel = XHWLAccountModel()
    
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
