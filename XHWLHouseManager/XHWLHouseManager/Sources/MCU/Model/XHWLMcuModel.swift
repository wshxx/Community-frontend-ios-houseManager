//
//  XHWLMcuModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/20.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMcuModel: NSObject {
    
    var nodeID:String = ""          //         nodeID:8
    var nodeName:String = ""        //   中海物业集团
    var parentNodeID:String = ""    //   0
    var nodeType:NSInteger = 2      // 1:控制中心 2:区域
    var sysCode:String = ""         //
    var userCapability:String = ""  //
    var cascadeFlag:Bool = false     //   0
    var isOnline:Bool = false       //   0
    
    var isSelected:Bool = false
}

