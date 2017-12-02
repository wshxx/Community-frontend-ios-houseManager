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
    case XHWL_NONE = 0              // 当前全链接 post
    case XHWL_LOGIN                 // 登录
    case XHWL_VERCODENEXT           // 下一步
    case XHWL_FORGETPWD             // 忘记密码
    case XHWL_RESETPWD              // 重置密码
    case XHWL_GETVERCODE            // 获取验证码
    case XHWL_SCANCODE              // 扫描二维码
    case XHWL_REPORTLIST            // 报事列表
    case XHWL_MODIFYUSER            // 修改姓名 手机号
    case XHWL_HISTORYALER           // 历史告警
    case XHWL_VISITREGISTER         // 访客登记
    case XHWL_LOGOUT                // 退出登录
    case XHWL_SAFEGUARDSUBMIT       // 处理安防事件（提交）
    case XHWL_EXCEPTIONPASSLOG      // 获取停车场异常放行记录
    case XHWL_HANDLEEXCEPTIONPASS   // 处理异常放行记录
    case XHWL_MAPKIT                // 在线定位
    case XHWL_REALPROGRESS          // 实时进度
    case XHWL_UNIT                  // 获取单元信息
    case XHWL_REALDATA              // 返回某项目某设备当前实时数据
    case XHWL_NAVPARAME             // 返回项目所有房间与环境监测设备对应关系
    case XHWL_NEWALER               // 获取项目当前设定周期内最新告警
    case XHWL_DEVICEINFO            // 所有设备信息
    case XHWL_OPENDOOR              // 开门
    case XHWL_VISITLIST             // 访客登记记录
    case XHWL_DOORLIST              // 门列表
    case XHWL_MESSAGECOUNT          // 消息总数
    case XHWL_BINDCARDLOG           // 蓝牙绑卡记录
    case XHWL_DELETECARDLOG         // 删除蓝牙绑卡记录
    case XHWL_SAVECARDLOG           // 保存蓝牙绑卡记录
    case XHWL_REGISTERJPUSH         // 访客登记提交推送
    case XHWL_SEARCHPIN             // 巡更—在线定位—轨迹回放
    case XHWL_PATROLDETAIL          // 巡更—在线定位—点击位置查看详情
    case XHWL_VIDEOUPLOAD           // 上传云瞳抓拍图片
    case XHWL_VIDEOIMGLIST          // 获取云瞳抓拍图片
    case XHWL_DELETEVIDEOIMG        // 删除抓拍图片
    case XHWL_ROSTERLIST            // 获取名单列表
    case XHWL_ADDROSTER             // 名单---添加新名单（黑名单、灰名单）
    case XHWL_ROSTERINFO            // 根据证件号获取名单信息
    case XHWL_CHANNELLIST           // 获取所有频道列表
    case XHWL_ADDCHANNEL            // 新增频道/频道成员
    case XHWL_DELETECHANNEL         // 删除频道/频道成员
    case XHWL_WORKERLIST            // 获取所有物业工作人员信息
    case XHWL_RENAMECHANNEL         // 频道重命名
    case XHWL_TALKPUSH              // 对讲时向频道成员发起推送
    case XHWL_FILEUPLOAD            // 文件上传
    case XHWL_NEWVERSION            // 版本控制---获取最新版本信息
    case XHWL_ADDWARNING            // 报事
    case XHWL_WARNINGLIST           // 获取报事列表
    case XHWL_WARNINGDETAIL         // 获取报事详情
    case XHWL_WARNINGPEOPLE         // 分配人员（重新分配一样）
    case XHWL_ACCOUNTINFO           // 获取所有物业工作人员信息
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
            XHWLRequestKeyID.XHWL_LOGIN:"v1/wyBase/login",                     // 登录
            XHWLRequestKeyID.XHWL_VERCODENEXT:"v1/wyBase/testVerificatCode",   // 下一步
            XHWLRequestKeyID.XHWL_RESETPWD: "v1/wyBase/password/reset",        // 重置密码
            XHWLRequestKeyID.XHWL_FORGETPWD: "v1/wyBase/password/modify",      // 忘记密码
            XHWLRequestKeyID.XHWL_GETVERCODE: "v1/wyBase/getVerificatCode",    // 获取验证码
            XHWLRequestKeyID.XHWL_SCANCODE: "v1/wyBusiness/qrcode",            // 扫描二维码
            XHWLRequestKeyID.XHWL_REPORTLIST:"v1/wyBusiness/complaint",        // 报事列表
            XHWLRequestKeyID.XHWL_MODIFYUSER:"v1/wyBusiness/wyUser",           // 修改姓名 手机号
            XHWLRequestKeyID.XHWL_HISTORYALER :"v1/wyBusiness/iot/machine/alarmHistory",   // 历史告警
            XHWLRequestKeyID.XHWL_VISITREGISTER :"v1/wyBusiness/visitor/regist",           // 访客登记
            XHWLRequestKeyID.XHWL_LOGOUT: "v1/wyBase/logout",                              // 退出登录
            XHWLRequestKeyID.XHWL_SAFEGUARDSUBMIT:"v1/wyBusiness/complaint/manage",        // 处理安防事件（提交）
            XHWLRequestKeyID.XHWL_EXCEPTIONPASSLOG:"v1/wyBusiness/parking/out/exeption",   // 获取停车场异常放行记录
            XHWLRequestKeyID.XHWL_HANDLEEXCEPTIONPASS: "v1/wyBusiness/parking/out/exeption/handle", // 处理异常放行记录
            XHWLRequestKeyID.XHWL_MAPKIT:"v1/wyBusiness/patrol/collectNodes",          // 在线定位
            XHWLRequestKeyID.XHWL_REALPROGRESS: "v1/wyBusiness/patrol/progress",       // 实时进度
            XHWLRequestKeyID.XHWL_UNIT:"v1/wyBusiness/room",                           // 获取单元信息
            XHWLRequestKeyID.XHWL_NEWALER:"v1/wyBusiness/iot/machine/alarm",           // 获取项目当前设定周期内最新告警
            XHWLRequestKeyID.XHWL_DEVICEINFO:"v1/wyBusiness/iot/machine/device",       // 返回项目下所有设备信息
            XHWLRequestKeyID.XHWL_OPENDOOR:"v1/appBusiness/iot/entrance/openDoor",     // 开门
            XHWLRequestKeyID.XHWL_VISITLIST:"v1/wyBusiness/visitor",                   // 访客登记记录
            XHWLRequestKeyID.XHWL_DOORLIST:"v1/wyBusiness/iot/entrance/getDoorList",   // 门列表
            XHWLRequestKeyID.XHWL_NAVPARAME:"v1/wyBusiness/iot/machine/navparame",     //返回项目所有房间与环境监测设备对应关系 " http://202.105.104.105:8804/realdata/get", //
            XHWLRequestKeyID.XHWL_BINDCARDLOG:"v1/wyBusiness/bluetoothCard",           //绑卡记录
            XHWLRequestKeyID.XHWL_DELETECARDLOG:"v1/wyBusiness/delBluetoothCard",      // 删除蓝牙绑卡记录
            XHWLRequestKeyID.XHWL_SAVECARDLOG:"v1/wyBusiness/bluetoothCard/bind",      // 保存蓝牙绑卡记录
            XHWLRequestKeyID.XHWL_MESSAGECOUNT:"v1/wyBase/tips/count",                 // 消息总数
            XHWLRequestKeyID.XHWL_REGISTERJPUSH:"v1/wyBusiness/visitor/regist/jgPush",     // 访客登记提交推送
            XHWLRequestKeyID.XHWL_SEARCHPIN:"v1/wyBusiness/patrol/trails/playback",        // 巡更—在线定位—轨迹回放
            XHWLRequestKeyID.XHWL_PATROLDETAIL:"v1/wyBusiness/patrol/position/progress",   // 巡更—在线定位—点击位置查看详情
            XHWLRequestKeyID.XHWL_VIDEOUPLOAD:"v1/wyBusiness/iot/video/upload",            // 上传云瞳抓拍图片
            XHWLRequestKeyID.XHWL_VIDEOIMGLIST:"v1/wyBusiness/iot/video/getList",          // 获取云瞳抓拍图片
            XHWLRequestKeyID.XHWL_DELETEVIDEOIMG:"v1/wyBusiness/iot/video/delete",         // 删除抓拍图片
            XHWLRequestKeyID.XHWL_ROSTERLIST:"v1/wyBusiness/wyRoster/getByType",           // 获取名单列表
            XHWLRequestKeyID.XHWL_ADDROSTER:"v1/wyBusiness/wyRoster/new",                  // 名单---添加新名单（黑名单、灰名单）
            XHWLRequestKeyID.XHWL_ROSTERINFO:"v1/wyBusiness/wyRoster/getRosterByCetificateNo", // 根据证件号获取名单信息
            XHWLRequestKeyID.XHWL_CHANNELLIST:"v1/wyBusiness/channel/list",                // 获取所有频道列表
            XHWLRequestKeyID.XHWL_ADDCHANNEL:"v1/wyBusiness/channel/add",                  // 新增频道/频道成员
            XHWLRequestKeyID.XHWL_DELETECHANNEL:"v1/wyBusiness/channel/removeMember",      // 删除频道/频道成员
            XHWLRequestKeyID.XHWL_WORKERLIST:"v1/wyBusiness/channel/getMembers",           // 获取所有物业工作人员信息
            XHWLRequestKeyID.XHWL_RENAMECHANNEL:"v1/wyBusiness/channel/rename",            // 频道重命名
            XHWLRequestKeyID.XHWL_TALKPUSH:"v1/wyBusiness/talkBackPushToChannelPerson",    // 对讲时向频道成员发起推送
            XHWLRequestKeyID.XHWL_FILEUPLOAD:"v1/appBase/filesUpload",                     // 文件上传
            XHWLRequestKeyID.XHWL_NEWVERSION:"version/getNewestVersion",                   // 版本控制---获取最新版本信息
            XHWLRequestKeyID.XHWL_ADDWARNING:"SysWarning/addWarning",                       // 报事
            XHWLRequestKeyID.XHWL_WARNINGLIST:"SysWarning/getWarning",                      // 获取报事列表
            XHWLRequestKeyID.XHWL_WARNINGDETAIL:"SysWarning/getWarningById",                // 获取报事详情
            XHWLRequestKeyID.XHWL_WARNINGPEOPLE:"SysWarning/allocationWarningHandler",      // 分配人员（重新分配一样）
            XHWLRequestKeyID.XHWL_ACCOUNTINFO:"v1/wyBusiness/getWYAccountByProject",        // 获取所有物业工作人员信息
        ]
    }
}
