//
//  XHWLScanModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/5.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import MJExtension

class XHWLScanModel:NSObject {
    var plant:XHWLScanDataModel = XHWLScanDataModel()
    var equipment:XHWLScanDataModel = XHWLScanDataModel()
    var type:String = ""
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["plant":XHWLScanDataModel.self] // [JZMJewelryCategoryModel class]
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }
}

class XHWLScanDataModel: NSObject {
    
    var address:String = ""
    var code:String = ""
    var id:String = ""
    var name:String = ""
    var status:String = ""
    var sysProject:XHWLSysProject = XHWLSysProject()
    var type:String = ""
    
    var category:String = ""
    var descriptions:String = ""
    var price:String = ""
    var prodDate:String = ""
    var projectName:String = ""
    var latitude:String = ""
    var longitude:String = ""
    

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
    
    var ccProjectCode:String = ""
    var code:String = ""
    var divisionName:String = ""
    var id:String = ""
    var latitude:String = ""
    var longitude:String = ""
    var name:String = ""
    
    override func setValue(_ value:Any?, forUndefinedKey key:String) {
        print("EditPubLicityModel 缺少:\(key)")
    }

}

