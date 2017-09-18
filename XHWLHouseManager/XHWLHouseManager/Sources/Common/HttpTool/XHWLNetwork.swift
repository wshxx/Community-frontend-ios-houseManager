//
//  XHWLNetwork.swift
//  XHWLHouseManager
//
//  Created by admin on 2017/9/17.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

@objc protocol XHWLNetworkDelegate:NSObjectProtocol {

    @objc func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject])
    @objc func requestFail(_ requestKey:NSInteger, _ error:NSError)
    @objc optional func requestCancel(_ requestKey:NSInteger)
    @objc optional func requestError(_ requestKey:NSInteger, _ message:String)
    //请求成功返回错误字段为  Type = E
    @objc optional func requestSuccessWithTypeE(_ requestKey:NSInteger)
}

class XHWLNetwork: NSObject, XHWLHttpToolDelegate {
    weak var delegate:XHWLNetworkDelegate?
    
    // 单例
    class var shared: XHWLNetwork {
        struct Static {
            static let instance = XHWLNetwork()
        }
        return Static.instance
    }
    
    func superWithLoadData(_ parameters:Any, _ requestKey:XHWLRequestKeyID, _ method:HTTPMethod) {
        
        
//        [[FireflyShowViewManager sharedInstance]showWaitingView]; // 提示
//        [[self class] checkReachabilityStatus]; // 检测网络状态
        
        
//        NSMutableDictionary * mutableParame = [NSMutableDictionary dictionaryWithDictionary:parameters];
//        //增加应用报文头
//        // 增加头部信息
//        NSMutableDictionary *deviceDict = [NSMutableDictionary dictionary];
//        
//        [deviceDict setObject:@"013" forKey:@"sysno"]; //系统编码
//        [deviceDict setObject:@"03" forKey:@"channelNumber"];// 渠道号
//        [deviceDict setObject:@"11" forKey:@"terminalCode"];
//        
//        EHUserData * user = [EHUserData unarchiveUserInfo];
//        
//        if ([user.userId length]) {
//            
//            [deviceDict setObject:user.userId forKey:@"userId"];
//            [deviceDict setObject:user.orgId forKey:@"orgId"];
//        }
//        
//        [deviceDict setObject:@"1.0" forKey:@"version"];
//        [deviceDict setObject:@"1234567890" forKey:@"seriaNumber"];
//        
//            [deviceDict setObject:@"2016-12-09" forKey:@"transDate"];
//        [mutableParame setObject:deviceDict forKey:@"appHeader"];
//        NSString *stringInputValue = [[NSString alloc] initWithData:[mutableParame toJSON]
//            encoding:NSUTF8StringEncoding];
//        NSString *aesInputValue = [FireflySecurityUtil aesEncrypt:stringInputValue
//            key:[FireflySecurityUtil sharedInstance].aesToken
//            vector:AES_VECTOR]; // 加密
        
        
        let request = XHWLHttpTool() 
        request.initWithKey(requestKey, self)
        request.validTime = 1200
        if method == .get {
            request.getHttpTool(parameters as! NSArray)
        } else {
            request.postHttpTool(parameters as! Parameters)
        }
    }
    
    func superWithUploadImage(_ parameters:NSDictionary, _ requestKey:XHWLRequestKeyID, _ data:[Data], _ name:[String]) {
        let request = XHWLHttpTool()
        request.initWithKey(requestKey, self)
        request.validTime = 1200
        request.uploadHttpTool(parameters as! [String : String], data, name)
    }
    
    // 登录
    func getLoginClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_LOGIN, .get)
    }
    
    // 验证下一步
    func postVercodeNextClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_VERCODENEXT, .post)
    }
    
    // 修改密码
    func postForgetPwdClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_FORGETPWD, .post)
    }
    
    // 重置密码
    func postResetPwdClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_RESETPWD, .post)
    }
    
    // 获取验证码
    func getVerCodeClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_GETVERCODE, .get)
    }
    
    // 扫描二维码
    func getScanCodeClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_SCANCODE, .get)
    }
    
    // 上传图片
    func uploadImageClick(_ parameters:NSDictionary, _ data:[Data], _ name:[String], _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithUploadImage(parameters, .XHWL_SCANCODE, data, name)
    }
    
    // 报事列表
    func getReportListClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_REPORTLIST, .get)
    }
    
    // 修改姓名 手机号
    func postModifyUserClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_MODIFYUSER, .post)
    }
    
    // 历史告警
    func postHistoryAlerClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_HISTORYALER, .post)
    }
    
    // 访客登记
    func postVisitRegisterClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_VISITREGISTER, .post)
    }
    
    // 退出登录
    func getLogoutClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_LOGOUT, .get)
    }
    
    
    
    // 某项目所有设备某日能耗
    func postEnergyLoseClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
//        ProjectCode 	string 	是 	项目编号
//        Date 	Date 	是 	日期
//        token 	string 	是 	用户登录token
//        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_ENERGYLOSE, .post)
    }
    
    // 返回某项目某设备当前实时数据
    func postRealDataClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
//        ProjectCode 	string 	是 	项目编号
//        DeviceID 	string 	是 	设备ID
//        token 	string 	是 	用户登录token
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_REALDATA, .post)
    }
    
    // 返回项目所有房间与环境监测设备对应关系
    func postNavParameClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        //        ProjectCode 	string 	是 	项目编号
        //        DeviceID 	string 	是 	设备ID
        //        token 	string 	是 	用户登录token
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_NAVPARAME, .post)
    }
    
    // 获取项目当前设定周期内最新告警
    func postNewAlerClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {

        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_NEWALER, .post)
    }
    
    
    //   所有设备信息
    func postDeviceInfoClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_DEVICEINFO, .post)
    }
    
    
    // MARK: - XHWLHttpToolDelegate
    func requestSuccess(_ requestKey:NSInteger, result request:Any) {
//        [[FireflyShowViewManager sharedInstance]dismissWaitingView];
        
       self.delegate?.requestSuccess(requestKey, request as! [String : AnyObject])
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        self.delegate?.requestFail(requestKey, error)
    }
    
}
