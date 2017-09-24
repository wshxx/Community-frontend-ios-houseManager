//
//  XHWLDeviceTitleModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/23.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDeviceTitleModel: NSObject {

    var deviceTitle:String = ""
    var deviceAry:NSArray = NSArray()
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["deviceAry":XHWLDeviceSubTitleModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}
