//
//  XHWLScanModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import MJExtension

class XHWLScanModel: NSObject {

    var category:String = ""
    var code:String = ""
    var descri:String = ""
    var id:String = ""
    var name:String = ""
    var price:String = ""
    var projectName:String = ""
    var status:String = ""
    var sysProject:XHWLSysProject = XHWLSysProject()
    var type:String = ""
    
    var address:String = ""
    
    func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return [
            "descri" : "description"
        ]
    }
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["sysProject":XHWLSysProject.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
    
//    class func dicToModel(list:[[String : Any]]) -> [XHWLScanModel] {
//        var models = [XHWLScanModel]()
//        for dict in list {
//            models.append(XHWLScanModel(dict: dict))
//        }
//        return models
//    }
}


class XHWLSysProject: NSObject {
    
    let code:String = ""
    let divisionName:String = ""
    let id:String = ""
    let latitude:String = ""
    let longitude:String = ""
    let name:String = ""
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }

}

