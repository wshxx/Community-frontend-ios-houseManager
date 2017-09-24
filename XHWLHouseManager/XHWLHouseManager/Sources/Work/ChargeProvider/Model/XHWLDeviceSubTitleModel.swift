//
//  XHWLDeviceSubTitleModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDeviceSubTitleModel: NSObject {

    var deviceSubTitle:String = ""
    var deviceSubAry:NSArray = NSArray()
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["deviceSubAry":XHWLDeviceModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}
