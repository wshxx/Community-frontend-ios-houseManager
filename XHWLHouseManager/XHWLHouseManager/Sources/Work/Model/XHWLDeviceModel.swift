//
//  XHWLDeviceModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/18.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLDeviceModel: NSObject {

    var DeviceID:String = ""
    var DeviceName:String = ""
    var NavName:String = ""
    var TypeID:String = ""
    var TypeName:String = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }

}
