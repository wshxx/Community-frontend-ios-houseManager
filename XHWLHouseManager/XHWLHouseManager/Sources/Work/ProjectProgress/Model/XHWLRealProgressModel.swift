//
//  XHWLRealProgressModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/19.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRealProgressModel: NSObject {
    
    var progress:String = ""
    var id:String = ""
    var totalLine:String = ""
    var totalLineDetail:[XHWLDetailProgressModel] = NSMutableArray() as! [XHWLDetailProgressModel]
    var nickname:String = ""
    var inspectedLineDetail:[XHWLDetailProgressModel] = NSMutableArray() as! [XHWLDetailProgressModel]
    var inspectedTotal:String = ""
    var nodeTotal:String = ""
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["totalLineDetail":XHWLRoleModel.self,
                "inspectedLineDetail":XHWLRoleModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}

