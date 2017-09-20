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
    var totalLineDetail:XHWLDetailProgressModel = XHWLDetailProgressModel()
    var nickname:String = ""
    var inspectedLineDetail:XHWLDetailProgressModel = XHWLDetailProgressModel()
    var inspectedTotal:String = ""
}
