//
//  XHWLIssueReportModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/15.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLIssueReportModel: NSObject {

    var id:String = ""
    var code:String = ""
    var equipmentCode:String = ""
    var imgUrl:String = ""
    var wyAccount:XHWLIssueAccountModel = XHWLIssueAccountModel()
    var type:String = ""
    var urgency:String = ""
    var inspectionPoint:String = ""
    var remarks:String = ""
    var createTime:String = ""
    var status:String = ""
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["wyAccount":XHWLIssueAccountModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}
