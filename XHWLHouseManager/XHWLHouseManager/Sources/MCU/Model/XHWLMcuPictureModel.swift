//
//  XHWLMcuPictureModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/29.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMcuPictureModel: NSObject {

    var id:String = ""
    var imageUrl:String = ""
    var isSelected:Bool = false
    var isEdit:Bool = false
    var sysProject:XHWLProjectModel = XHWLProjectModel()
    var wyAccount:XHWLAccountModel = XHWLAccountModel()
    
    func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["wyAccount":XHWLAccountModel.self] // [JZMJewelryCategoryModel class]
    }
}

