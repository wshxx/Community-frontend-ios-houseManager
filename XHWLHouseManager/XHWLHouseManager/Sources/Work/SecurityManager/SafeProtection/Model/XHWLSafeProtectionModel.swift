//
//  XHWLSafeProtectionModel.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/18.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSafeProtectionModel: NSObject {

//    var code:String = ""
//    var createTime:String = ""
//    var equipmentCode:String = ""
//    var id :String = ""
//    var imgUrl:String = ""
//    var inspectionPoint:String = ""
//    var manageImgUrl:String = ""
//    var manageRemarks:String = ""
//    var manageTime:String = ""
//    var manageWYAccount:String = ""
//    var remarks:String = ""
//    var status :String = ""
//    var type :String = ""
//    var urgency:String = ""
//    var wyAccount :String = ""
    
    
    var appComplaint:XHWLAppComplaint = XHWLAppComplaint()
    var complaintUserName:String = ""
    var manageUserName :String = ""
    
    var dataSource:NSArray! = NSArray()
    var state:XHWLSafeGuardStateEnum = .undistributed {
        willSet {
            
            let array1 :NSArray = [["name":"异常类型：", "content":self.appComplaint.manageRemarks, "type":"0"],
                                   ["name":"报事位置：", "content":self.manageUserName, "type":"0"],
                                   ["name":"事件备注：", "content":self.manageUserName, "type":"0"],
                                   ["name":"是否紧急：", "content":self.appComplaint.urgency, "type":"0"],
                                   ["name":"现场照片：", "content":self.manageUserName, "type":"1"]]
            let dataAry1 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array1)
            
            let array2 :NSArray = [["name":"报事人：", "content":self.complaintUserName, "type":"0"],
                                   ["name":"报事岗位：", "content":self.appComplaint.wyAccount.wyRole.name, "type":"0"],
                                   ["name":"报事时间：", "content":Date.getDateWith(Int(self.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                   ["name":"工单编号：", "content":self.appComplaint.code, "type":"0"]]
            let dataAry2 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array2)
            
            
            switch newValue {
            case .issue:
                let array4 :NSArray = [["name":"现场照片：", "content":"", "type":"1"],
                                       ["name":"处理意见：", "content":self.appComplaint.wyAccount.wyRole.name, "type":"2"],
                                       ["name":"处理人：", "content":self.complaintUserName, "type":"0"],
                                       ["name":"上报时间：", "content":Date.getDateWith(Int(self.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"备注：", "content":self.appComplaint.wyAccount.wyRole.name, "type":"0"],
                                       ["name":"上报人：", "content":self.appComplaint.code, "type":"0"]]
                let dataAry4 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array4)
                
                let array3 :NSArray = [["name":"处理人：", "content":self.complaintUserName, "type":"0"],
                                       ["name":"分配时间：", "content":Date.getDateWith(Int(self.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"分配人：", "content":self.appComplaint.code, "type":"0"]]
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
                if userModel.wyAccount.wyRole.name == "安管主任" ||
                    userModel.wyAccount.wyRole.name == "项目经理" {
                    array3 = [["name":"处理人：", "content":self.complaintUserName, "type":"0"],
                              ["name":"分配时间：", "content":Date.getDateWith(Int(self.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                              ["name":"分配人：", "content":self.appComplaint.code, "type":"0"]]
                } else {
                    array3 = [["name":"现场照片：", "content":"", "type":"1"],
                              ["name":"处理意见：", "content":self.appComplaint.wyAccount.wyRole.name, "type":"2"],
                              ["name":"处理人：", "content":self.complaintUserName, "type":"0"],
                              ["name":"分配时间：", "content":Date.getDateWith(Int(self.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                              ["name":"分配人：", "content":self.appComplaint.code, "type":"0"]]
                }
                let dataAry3 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array3)
                
                dataSource = [["处理详情":dataAry3],
                              ["事件详情":dataAry1],
                              ["来源详情":dataAry2]]
                break
            case .unerase:
                let array3 :NSArray = [["name":"现场照片：", "content":self.manageUserName, "type":"1"],
                                       ["name":"处理意见：", "content":self.appComplaint.wyAccount.wyRole.name, "type":"0"],
                                       ["name":"处理时间：", "content":Date.getDateWith(Int(self.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"处理人：", "content":self.complaintUserName, "type":"0"],
                                       ["name":"分配时间：", "content":Date.getDateWith(Int(self.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"分配人：", "content":self.appComplaint.code, "type":"0"]]
                let dataAry3 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array3)
                
                dataSource = [["处理详情":dataAry3],
                              ["事件详情":dataAry1],
                              ["来源详情":dataAry2]]
                break
            case .erase:
                let array3 :NSArray = [["name":"销项时间：", "content":self.manageUserName, "type":"1"],
                                       ["name":"销项人：", "content":self.manageUserName, "type":"1"],
                                       ["name":"", "content":"", "type":"3"],
                                       ["name":"现场照片：", "content":self.manageUserName, "type":"1"],
                                       ["name":"处理意见：", "content":self.appComplaint.manageRemarks, "type":"0"],
                                       ["name":"处理时间：", "content":Date.getDateWith(Int(self.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"处理人：", "content":self.complaintUserName, "type":"0"],
                                       ["name":"分配时间：", "content":Date.getDateWith(Int(self.appComplaint.createTime)!, "yyyy-MM-dd HH:mm:ss"), "type":"0"],
                                       ["name":"分配人：", "content":self.appComplaint.code, "type":"0"]]
                let dataAry3 = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array3)
                
                dataSource = [["处理详情":dataAry3],
                              ["事件详情":dataAry1],
                              ["来源详情":dataAry2]]
                break
            }
        }
    }
}


class XHWLAppComplaint:NSObject {
    var code:String = ""
    var createTime:String = ""
    var equipmentCode:String = ""
    var id:String = ""
    var imgUrl:String = ""
    var inspectionPoint:String = ""
    var manageImgUrl:String = ""
    var manageRemarks:String = ""
    var manageTime:String = ""
    var manageWYAccount:String = ""
    var remarks:String = ""
    var status:String = ""
    var type:String = ""
    var urgency:String = ""
    var wyAccount:XHWLAccountModel = XHWLAccountModel()
}
