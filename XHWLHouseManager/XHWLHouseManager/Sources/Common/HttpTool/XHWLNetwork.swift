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
        
//        Reachability
        
//        Alamofire.
        
//        var manager: NetworkReachabilityManager?
//
//        manager = NetworkReachabilityManager(host: "www.apple.com")
//
//        manager?.listener = { status in
//
//            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable {
//
//            }
//
//            if status == NetworkReachabilityManager.NetworkReachabilityStatus.unknown {
//
//            }
////            if status == reachable(Alamofire.NetworkReachabilityManager.ConnectionType.ethernetOrWiFi) {
////
////            }
//
//            print("Network Status Changed: \(status)")
//
//        }
//
//        manager?.startListening()
        
//        error:Error Domain=NSURLErrorDomain Code=-1009 "似乎已断开与互联网的连接。" UserInfo={NSUnderlyingError=0x170253e00 {Error Domain=kCFErrorDomainCFNetwork Code=-1009 "(null)" UserInfo={_kCFStreamErrorCodeKey=50, _kCFStreamErrorDomainKey=1}}, NSErrorFailingURLStringKey=http://202.105.104.105:8006/ssh/v1/wyBusiness/complaint/cb522772-4e23-4593-8f95-1cd2551379f4, NSErrorFailingURLKey=http://202.105.104.105:8006/ssh/v1/wyBusiness/complaint/cb522772-4e23-4593-8f95-1cd2551379f4, _kCFStreamErrorDomainKey=1, _kCFStreamErrorCodeKey=50, NSLocalizedDescription=似乎已断开与互联网的连接。}
        
//        var reachability: Reachability!
//
//        do {
//            reachability = try Reachability.reachabilityForInternetConnection()
//        } catch {
//            print("Unable to create Reachability")
//            return
//        }
//
//        // 检测网络连接状态
//        if reachability.isReachable() {
//            print("网络连接：可用")
//        } else {
//            print("网络连接：不可用")
//        }
//
//        // 检测网络类型
//        if reachability.isReachableViaWiFi() {
//            print("网络类型：Wifi")
//        } else if reachability.isReachableViaWWAN() {
//            print("网络类型：移动网络")
//        } else {
//            print("网络类型：无网络连接")
//        }
//        
//        // 网络可用或切换网络类型时执行
//        reachability.whenReachable = { reachability in
//
//            // 判断网络状态及类型
//        }
//
//        // 网络不可用时执行
//        reachability.whenUnreachable = { reachability in
//
//            // 判断网络状态及类型
//        }
//
//        do {
//            // 开始监听
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
        changeStatus({ (isReach) in
            if isReach == false {
                "网络不可用".ext_debugPrintAndHint()
            } else {
                if !(requestKey.rawValue == XHWLRequestKeyID.XHWL_OPENDOOR.rawValue) {
                    XHMLProgressHUD.shared.show()
                }
                
                let request = XHWLHttpTool()
                request.initWithKey(requestKey, self)
                request.validTime = 1200
                if method == .get {
                    request.getHttpTool(parameters as! NSArray)
                } else {
                    request.postHttpTool(parameters as! Parameters)
                }
            }
        })
    }
    
    func superUnProgressHUDWithLoadData(_ parameters:Any, _ requestKey:XHWLRequestKeyID, _ method:HTTPMethod) {
        
        changeStatus({ (isReach) in
            if isReach == false {
                "网络不可用".ext_debugPrintAndHint()
            } else {
                let request = XHWLHttpTool()
                request.initWithKey(requestKey, self)
                request.validTime = 1200
                if method == .get {
                    request.getHttpTool(parameters as! NSArray)
                } else {
                    request.postHttpTool(parameters as! Parameters)
                }
            }
        })
    }
    
    func superWithUploadImage(_ parameters:NSDictionary, _ requestKey:XHWLRequestKeyID, _ data:[Data], _ name:[String]) {
        
        changeStatus({ (isReach) in
            if isReach == false {
                "网络不可用".ext_debugPrintAndHint()
            } else {
                XHMLProgressHUD.shared.show()
                
                let request = XHWLHttpTool()
                request.initWithKey(requestKey, self)
                request.validTime = 1200
                request.uploadHttpTool(parameters as! [String : String], data, name)
            }
        })
    }
    
    func changeStatus(_ block:@escaping ((Bool)->())) {
        let networkManager:NetworkReachabilityManager = NetworkReachabilityManager(host: "www.baidu.com")!
        // 开始监听
        networkManager.startListening()
        // 检测网络连接状态
        if networkManager.isReachable {
            print("网络连接：可用")
        } else {
            "网络不可用".ext_debugPrintAndHint()
            print("网络连接：不可用")
        }
        
        // 检测网络类型
        networkManager.listener = { status in
            switch status {
            case .notReachable:
                print("无网络连接")
//                AlertMessage.showAlertMessage(vc: self, alertMessage: "网络不可用！请检查网络连接...", block: {
//
//                })
                block(false)
                break
            case .unknown:
                print("未知网络")
                block(false)
                break
            case .reachable(.ethernetOrWiFi):
                print("WIFI")
                block(true)
                break
            case .reachable(.wwan):
                print("手机自带网络")
                block(true)
                break
            }
        }
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
        superWithUploadImage(parameters, .XHWL_REPORTLIST, data, name)
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
    
    // 处理安防事件（提交）
    func updateSafeGuardSubmitClick(_ parameters:NSDictionary, _ data:[Data], _ name:[String], _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithUploadImage(parameters, .XHWL_SAFEGUARDSUBMIT, data, name)
    }
    
    // 获取停车场异常放行记录
    func getExceptionPassLogClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_EXCEPTIONPASSLOG, .get)
    }
    
    // 处理异常放行记录
    func postHandleExceptionPassClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_HANDLEEXCEPTIONPASS, .post)
    }
    
    // 返回某项目某设备当前实时数据
    func getRealDataClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {

        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_REALDATA, .get)
    }
    
    // 返回项目所有房间与环境监测设备对应关系
    func postNavParameClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
    
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
    
    // 在线定位
    func getMapkitClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_MAPKIT, .get)
    }
    
    // 实时进度
    func getRealProgressClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_REALPROGRESS, .get)
    }
    
    //获取单元信息
    func postUnitClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_UNIT, .post)
    }
    
    // 开门
    func postOpenDoorClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superUnProgressHUDWithLoadData(parameters, .XHWL_OPENDOOR, .post)
    }
    
    // 访客登记记录
    func getVisitListClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_VISITLIST, .get)
    }
    
    // 门列表
    func postDoorListClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_DOORLIST, .post)
    }
    
    // 消息总数
    func getMessageCountClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superUnProgressHUDWithLoadData(parameters, .XHWL_MESSAGECOUNT, .get)
    }
    
    // 绑卡记录
    func getBindCardLogClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_BINDCARDLOG, .get)
    }
    
    // 删除绑卡记录
    func postDeleteCardLogClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_DELETECARDLOG, .post)
    }
    
    // 保存蓝牙绑卡记录
    func postSaveCardLogClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_SAVECARDLOG, .post)
    }
    
    // 访客登记提交推送
    func postRegisterJpushClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_REGISTERJPUSH, .post)
    }
    
    // 巡更—在线定位—轨迹回放
    func getSearchPinClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_SEARCHPIN, .get)
    }
    
    // 巡更—在线定位—点击位置查看详情
    func getPatrolDetailClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_PATROLDETAIL, .get)
    }
    
     // 上传云瞳抓拍图片
    func uploadVideoImageClick(_ parameters:NSDictionary, _ data:[Data], _ name:[String], _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithUploadImage(parameters, .XHWL_VIDEOUPLOAD, data, name)
    }
    
    // 获取云瞳抓拍图片
    func getVideoImgListClick(_ parameters:NSArray, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_VIDEOIMGLIST, .get)
    }
    
    //删除抓拍图片
    func postDeleteVideoImgClick(_ parameters:NSDictionary, _ delegate:XHWLNetworkDelegate) {
        
        self.delegate = delegate;
        superWithLoadData(parameters, .XHWL_DELETEVIDEOIMG, .post)
    }
    
    
    
    
    
    // MARK: - XHWLHttpToolDelegate
    func requestSuccess(_ requestKey:NSInteger, result request:Any) {
//        [[FireflyShowViewManager sharedInstance]dismissWaitingView];
        let dict:NSDictionary = request as! NSDictionary
        if dict["errorCode"] as! NSInteger == code_401 ||
            dict["errorCode"] as! NSInteger == code_400 { // 用户token过期  用户没有登录
//            AppDelegate.shared().
            onShowAlert()
        } else {
            self.delegate?.requestSuccess(requestKey, request as! [String : AnyObject])
        }
    }
    
    func onShowAlert() {
        let vc:UIViewController = AppDelegate.shared().getCurrentVC() as! UIViewController
        
        AlertMessage.showOneAlertMessage(vc: vc, alertMessage: "登录失效，请重新登录！") {
            AppDelegate.shared().onLogout()
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        self.delegate?.requestFail(requestKey, error)
    }
    
}
