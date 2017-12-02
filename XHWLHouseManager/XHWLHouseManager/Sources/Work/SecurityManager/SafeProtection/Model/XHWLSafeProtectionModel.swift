//
//  XHWLSafeProtectionModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/18.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit


enum XHWLSafeGuardStateEnum : NSInteger {
    case issue              // 重大事件
    case undistributed      // 待分配
    case pending            // 待处理
    case unerase            // 待销项
    case erase              // 已销项
}

class XHWLStepsModel: NSObject {
    
    var id:String = ""
    var operater:String = ""
    var operation:String = ""
    var remarks :String = ""
    var createTime:String = ""
}

class XHWLSafeProtectionModel: NSObject {

    var id:String = ""
    var address:String = ""
    var remarks:String = ""
    var urgency :Bool = false
    var image:String = ""
    var video:String = ""
    var code:String = ""
    var origin:NSInteger = 0  // 来源； 1：小七当家，2：小七专家，3：优你家app,4:巡更app，5：云对讲
    var createTime:String = ""
    var type:NSInteger = 0  // 异常类型，1：安防，2：工程，3：环境，4：客服，5：业主
    var status:String = ""
    var repealTime :String = ""
    var projectCode :String = ""
    var peopleName:String = ""
    var roleName :String = ""
    var handles:NSArray = NSArray()
    var steps:NSArray = NSArray()
    
    // 来源； 1：小七当家，2：小七专家，3：优你家app,4:巡更app，5：云对讲
    func getOriginString() -> String {
        switch origin {
        case 1:
            return "小七当家"
        case 2:
            return "小七专家"
        case 3:
            return "优你家app"
        case 4:
            return "巡更app"
        case 5:
            return "云对讲"
        default:
            return ""
        }
    }
    
    // 异常类型，1：安防，2：工程，3：环境，4：客服，5：业主
    func stringWith(type:NSInteger) -> String {
        switch type {
        case 1:
            return "安防"
        case 2:
            return "工程"
        case 3:
            return "环境"
        case 4:
            return "客服"
        case 5:
            return "业主"
        default:
            return ""
        }
    }
    
    var dataSource:NSArray! = NSArray()
    var state:XHWLSafeGuardStateEnum = .undistributed {
        willSet {
            
            var urgencyStr = "不紧急"
            if self.urgency {
                urgencyStr = "紧急"
            }
            
            var imageOrVideoStr = self.video
            if imageOrVideoStr.isEmpty {
                imageOrVideoStr = self.image
            }
            let array1 :NSArray = [["name":"异常类型：", "content":stringWith(type: self.type), "type":"0"],
                                   ["name":"报事位置：", "content":self.address, "type":"0"],
                                   ["name":"报事内容：", "content":self.remarks, "type":"0"],
                                   ["name":"是否紧急：", "content":urgencyStr, "type":"0"], // 紧急/不紧急
                                   ["name":"现场照片：", "content":imageOrVideoStr, "type":"1"]] // 限制3张照片/10s
            let dataAry1 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array1)
            
            let array2 :NSArray = [["name":"报事人：", "content":self.peopleName, "type":"0"],
                                   ["name":"报事岗位：", "content":self.roleName, "type":"0"],
                                   ["name":"报事时间：", "content":Date.getDateWith(Int(self.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                   ["name":"工单编号：", "content":self.code, "type":"0"]]
            let dataAry2 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array2)
            
            
            switch newValue {
            case .issue:
                let array4 :NSArray = [["name":"现场照片：", "content":"", "type":"1"],
                                       ["name":"处理意见：", "content":self.roleName, "type":"2"],
                                       ["name":"处理人：", "content":self.roleName, "type":"0"],
                                       ["name":"上报时间：", "content":Date.getDateWith(Int(self.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"备注：", "content":self.roleName, "type":"0"],
                                       ["name":"上报人：", "content":self.code, "type":"0"]]
                let dataAry4 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array4)
                
                let array3 :NSArray = [["name":"处理人：", "content":self.roleName, "type":"0"],
                                       ["name":"分配时间：", "content":Date.getDateWith(Int(self.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"分配人：", "content":self.code, "type":"0"]]
                let dataAry3 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array3)
                
                dataSource = [["重大事件详情":dataAry4],
                              ["处理详情":dataAry3],
                              ["事件详情":dataAry1],
                              ["来源详情":dataAry2]]
                break
            case .undistributed:
                dataSource = [["事件详情":dataAry1],
                            ["来源详情":dataAry2]]
                break
            case .pending:
                
                var array3 :NSArray = NSArray()
                
                let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
                let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
//                if userModel.wyAccount.wyRole.name == "安管主任" ||
//                    userModel.wyAccount.wyRole.name == "项目经理" {
                    array3 = [["name":"处理人：", "content":self.roleName, "type":"0"],
                              ["name":"分配时间：", "content":Date.getDateWith(Int(self.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                              ["name":"分配人：", "content":self.code, "type":"0"]]
//                } else {
                    array3 = [["name":"现场照片：", "content":"", "type":"1"],
                              ["name":"处理结果：", "content":self.roleName, "type":"2"],
                              ["name":"处理人：", "content":self.roleName, "type":"0"],
                              ["name":"分配时间：", "content":Date.getDateWith(Int(self.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                              ["name":"分配人：", "content":self.code, "type":"0"]]
//                }
                let dataAry3 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array3)
                
                dataSource = [["处理详情":dataAry3],
                              ["事件详情":dataAry1],
                              ["来源详情":dataAry2]]
                break
            case .unerase:
                let array3 :NSArray = [["name":"现场照片：", "content":self.image, "type":"1"],
                                       ["name":"处理结果：", "content":self.roleName, "type":"0"],
                                       ["name":"处理时间：", "content":Date.getDateWith(Int(self.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"处理人：", "content":self.roleName, "type":"0"],
                                       ["name":"分配时间：", "content":Date.getDateWith(Int(self.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"分配人：", "content":self.code, "type":"0"]]
                let dataAry3 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array3)
                
                dataSource = [["处理详情":dataAry3],
                              ["事件详情":dataAry1],
                              ["来源详情":dataAry2]]
                break
            case .erase:
                let array3 :NSArray = [["name":"销项时间：", "content":self.roleName, "type":"1"],
                                       ["name":"销项人：", "content":self.roleName, "type":"1"],
                                       ["name":"", "content":"", "type":"3"],
                                       ["name":"现场照片：", "content":self.roleName, "type":"1"],
                                       ["name":"处理结果：", "content":self.roleName, "type":"0"],
                                       ["name":"处理时间：", "content":Date.getDateWith(Int(self.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"处理人：", "content":self.roleName, "type":"0"],
                                       ["name":"分配时间：", "content":Date.getDateWith(Int(self.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"分配人：", "content":self.code, "type":"0"]]
                let dataAry3 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array3)
                
                dataSource = [["处理详情":dataAry3],
                              ["事件详情":dataAry1],
                              ["来源详情":dataAry2]]
                break
            }
        }
    }
}

