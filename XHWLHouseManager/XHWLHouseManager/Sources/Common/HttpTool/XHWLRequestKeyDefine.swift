//
//  XHWLRequestKeyDefine.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/9/17.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

/**
 *  网络请求的业务ID，方便以后扩展功能模块
 */
enum XHWLRequestKeyID : NSInteger {
    case XHWL_NONE = 0      // 当前全链接 post
    case XHWL_LOGIN         // 登录
    case XHWL_VERCODENEXT   // 下一步
    case XHWL_FORGETPWD     // 忘记密码
    case XHWL_RESETPWD      // 重置密码
    case XHWL_GETVERCODE    // 获取验证码
    case XHWL_SCANCODE      // 扫描二维码
    case XHWL_REPORTLIST    // 报事列表
    case XHWL_MODIFYUSER    // 修改姓名 手机号
    case XHWL_HISTORYALER   // 历史告警
    case XHWL_VISITREGISTER // 访客登记
    case XHWL_LOGOUT        // 退出登录
    case XHWL_SAFEGUARDSUBMIT // 处理安防事件（提交）
    case XHWL_EXCEPTIONPASSLOG // 获取停车场异常放行记录
    case XHWL_HANDLEEXCEPTIONPASS// 处理异常放行记录
    case XHWL_MAPKIT // 在线定位
    case XHWL_REALPROGRESS // 实时进度
    case XHWL_UNIT //获取单元信息
    
    case XHWL_REALDATA      // 返回某项目某设备当前实时数据
    case XHWL_NAVPARAME     // 返回项目所有房间与环境监测设备对应关系
    case XHWL_NEWALER       // 获取项目当前设定周期内最新告警
    case XHWL_DEVICEINFO    // 所有设备信息
    case XHWL_OPENDOOR // 开门
    case XHWL_VISITLIST  // 访客登记记录
    case XHWL_DOORLIST // 门列表
}


class XHWLRequestKeyDefine: NSObject {
    
    var trandIdDict:NSDictionary!
    
    // 单例
    class var shared: XHWLRequestKeyDefine {
        struct Static {
            static let instance = XHWLRequestKeyDefine()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        initWebServiceDomain()
    }
    
    func initWebServiceDomain() {
        self.trandIdDict = [
            XHWLRequestKeyID.XHWL_NONE: "",
            XHWLRequestKeyID.XHWL_LOGIN:"wyBase/login",                     // 登录
            XHWLRequestKeyID.XHWL_VERCODENEXT:"wyBase/testVerificatCode",   // 下一步
            XHWLRequestKeyID.XHWL_RESETPWD: "wyBase/password/reset",        // 重置密码
            XHWLRequestKeyID.XHWL_FORGETPWD: "wyBase/password/modify",      // 忘记密码
            XHWLRequestKeyID.XHWL_GETVERCODE: "wyBase/getVerificatCode",    // 获取验证码
            XHWLRequestKeyID.XHWL_SCANCODE: "wyBusiness/qrcode",            // 扫描二维码
            XHWLRequestKeyID.XHWL_REPORTLIST:"wyBusiness/complaint",        // 报事列表
            XHWLRequestKeyID.XHWL_MODIFYUSER:"wyBusiness/wyUser",           // 修改姓名 手机号
            XHWLRequestKeyID.XHWL_HISTORYALER :"wyBusiness/iot/machine/alarmHistory",   // 历史告警
            XHWLRequestKeyID.XHWL_VISITREGISTER :"wyBusiness/visitor/regist",           // 访客登记
            XHWLRequestKeyID.XHWL_LOGOUT: "wyBase/logout",                              // 退出登录
            XHWLRequestKeyID.XHWL_SAFEGUARDSUBMIT:"wyBusiness/complaint/manage",        // 处理安防事件（提交）
            XHWLRequestKeyID.XHWL_EXCEPTIONPASSLOG:"wyBusiness/parking/out/exeption",   // 获取停车场异常放行记录
            XHWLRequestKeyID.XHWL_HANDLEEXCEPTIONPASS: "wyBusiness/parking/out/exeption/handle", // 处理异常放行记录
            XHWLRequestKeyID.XHWL_MAPKIT:"wyBusiness/patrol/collectNodes",      // 在线定位
            XHWLRequestKeyID.XHWL_REALPROGRESS: "wyBusiness/patrol/progress",   // 实时进度
            XHWLRequestKeyID.XHWL_UNIT:"wyBusiness/unit",                       // 获取单元信息
            XHWLRequestKeyID.XHWL_NEWALER:"wyBusiness/iot/machine/alarm",       // 获取项目当前设定周期内最新告警
            XHWLRequestKeyID.XHWL_DEVICEINFO:"wyBusiness/iot/machine/device",   // 返回项目下所有设备信息
            XHWLRequestKeyID.XHWL_OPENDOOR:"appBusiness/iot/entrance/openDoor", // 开门
            XHWLRequestKeyID.XHWL_VISITLIST:"wyBusiness/visitor",               // 访客登记记录
            XHWLRequestKeyID.XHWL_DOORLIST:"wyBusiness/iot/entrance/getDoorList",  // 门列表
            
            XHWLRequestKeyID.XHWL_NAVPARAME:"wyBusiness/iot/machine/navparame", //返回项目所有房间与环境监测设备对应关系 " http://202.105.104.105:8804/realdata/get", //
            
        ]
    }
}
