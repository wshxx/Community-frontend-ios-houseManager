   //
//  XHWLTransitionView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/31.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLTransitionViewDelegate:NSObjectProtocol {
    @objc optional func onGotoHome(_ trianView:XHWLTransitionView)
}

class XHWLTransitionView: UIView, XHWLNetworkDelegate {

    var showV: XHWLLoginView?
    var setPwdV: XHWLSetPwdView?
    var forgetCodeV:XHWLForgetPwdView!
    weak var delegate:XHWLTransitionViewDelegate?
    var funcBackBlock : (String, String) -> () = {param in }
    var workCode:String!
    var isResetPwd:Bool = false // 是否是重置密码
    var isWindowToLogin:Bool? = true { // 从菜单跳转过来为false
        willSet {
            if newValue == false {
                
                self.setPwdV?.isHidden = true
                self.setPwdV?.isWindowToLogin = newValue
                self.forgetCodeV?.isHidden = false
                self.forgetCodeV.isWindowToLogin = newValue
                self.showV?.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        ////
        showV = XHWLLoginView(frame: CGRect(x:0, y:75+30, width:self.bounds.size.width, height:self.bounds.size.height-75-60))
        showV?.funcBackBlock = { [weak self] topStr,bottomStr in // 登陆
            self?.onLoginClick(topStr, bottomStr)
        }
        showV?.forgetPwdBackBlock = { _ in // 忘记密码
            self.onForgetCode()
        }
        self.addSubview(showV!)
        
        ////
        setPwdV = XHWLSetPwdView(frame: CGRect(x:0, y:75+30, width:self.bounds.size.width, height:self.bounds.size.height-75-60))
        setPwdV?.funcBackBlock = {[weak self] topStr,bottomStr in // 重置密码，登陆
            self?.onResetPwdClick(topStr, bottomStr)
//            self.funcBackBlock(topStr,bottomStr);
        }
        setPwdV?.onCancelBlock = {[weak self] _ in
            self?.onResetChangeLogin()
        }
        setPwdV?.isHidden = true
        self.addSubview(setPwdV!)
        
        self.bringSubview(toFront: self.showV!)
        
        forgetCodeV = XHWLForgetPwdView(frame: CGRect(x:0, y:75, width:self.bounds.size.width, height:self.bounds.size.height-75))
        forgetCodeV.funcBackBlock = { topStr,bottomStr,workCode in
            // 跳转到重置密码
            self.onNextResetPwdClick(topStr,bottomStr, workCode)
        }
        forgetCodeV.onBackBlock = { [weak self] _ in
            self?.onForgetPwdChangeLogin() // 返回登陆页
        }
        forgetCodeV.isHidden = true
        self.addSubview(forgetCodeV)
        
//        progressHUD = XHMLProgressHUD.init(frame: CGRect(x:(Screen_width-100)/2.0, y:(Screen_height-100)/2.0, width:100, height:100))
//        
//        let window:UIWindow = UIApplication.shared.keyWindow!
//        window.addSubview(progressHUD)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        showV?.frame = CGRect(x:0, y:75+30, width:self.bounds.size.width, height:self.bounds.size.height-75-60)
        setPwdV?.frame = CGRect(x:0, y:75+30, width:self.bounds.size.width, height:self.bounds.size.height-75-60)
        forgetCodeV?.frame = CGRect(x:0, y:75, width:self.bounds.size.width, height:self.bounds.size.height-75)
    }

    func onForgetCode() {
        self.forgetCodeV?.isHidden = false
        UIView.transition(from: self.showV!,
                          to: self.forgetCodeV!,
                          duration: 2.0,
                          options: UIViewAnimationOptions.transitionFlipFromRight) { (animated) in

                            self.bringSubview(toFront: self.forgetCodeV!)
        }
    }
    
//    测试帐号及密码：
//    13543753375  000000 //  安管主任
//    13688980285  000000 // 工程
//    anguan 000000
//    xhwl9868 000000
    // MARK: 登陆
    func onLoginClick(_ topStr:String, _ bottomStr:String) {
        
        let params:NSArray = [topStr, bottomStr]
        
        if topStr.isEmpty {
            "您输入的工号为空".ext_debugPrintAndHint()
            return
        }
        
        if bottomStr.isEmpty {
            "您输入的密码为空".ext_debugPrintAndHint()
            return
        }
        
        XHWLNetwork.shared.getLoginClick(params, self)
    }
    
    // 下一步
    func onNextResetPwdClick(_ topStr:String, _ bottomStr:String, _ workCode:String) {
        
        self.workCode = workCode
        let params = ["telephone":topStr,
                      "verificatCode":bottomStr,
                      "workCode": workCode]
        
        if workCode.isEmpty {
            "您输入的工号为空".ext_debugPrintAndHint()
            return
        }
        
        print("\(topStr)")
        if Validation.phoneNum(topStr).isRight == false {
            "您输入的手机号不合法".ext_debugPrintAndHint()
            return
        }
        
        if bottomStr.isEmpty {
            "您输入的验证码为空".ext_debugPrintAndHint()
            return
        }
        
        XHWLNetwork.shared.postVercodeNextClick(params as NSDictionary, self)
    }
    
    // 重置密码
    func onResetPwdClick(_ topStr:String, _ bottomStr:String) {
        
        var params:[String: Any]!
        
        if topStr.compare(bottomStr).rawValue != 0 {
            "您输入的两次密码不一致".ext_debugPrintAndHint()
            return
        }
        
        if isResetPwd { // 重置密码
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
            params = ["token":userModel.wyAccount.token, "password":bottomStr]
            
            XHWLNetwork.shared.postResetPwdClick(params as NSDictionary, self)
            
        } else {
            params = ["workCode":self.workCode, "password":bottomStr]
            XHWLNetwork.shared.postForgetPwdClick(params as NSDictionary, self)
        }
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        //         self.progressHUD.hide()
        if requestKey == XHWLRequestKeyID.XHWL_LOGIN.rawValue {
            onLogin(response)
        }
        else  if requestKey == XHWLRequestKeyID.XHWL_VERCODENEXT.rawValue {
            onNext(response)
        }
        else  if requestKey == XHWLRequestKeyID.XHWL_RESETPWD.rawValue ||
            requestKey == XHWLRequestKeyID.XHWL_FORGETPWD.rawValue {
            onResetPwd(response, requestKey)
        }
        
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    func onLogin(_ response:[String : AnyObject]) {

        if response["state"] as! Bool{
            self.isUserInteractionEnabled = false
            
            //登录成功
            if !(response["result"]!["wyUser"] is NSNull) {
                "登陆成功".ext_debugPrintAndHint()
                 let wyUser:NSDictionary = response["result"]!["wyUser"] as! NSDictionary
//                let wyAccount:NSDictionary = response["result"]!["wyAccount"] as! NSDictionary
                let projectList:NSArray = response["result"]!["projectList"] as! NSArray
                let channelList:NSArray = response["result"]!["channelList"] as! NSArray
                
                print("\(wyUser)")
                let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: wyUser)
                print("\(userModel.wyAccount) \n \(userModel.wyAccount.token)")
                let data:NSData = userModel.mj_JSONData()! as NSData
                UserDefaults.standard.set(data, forKey: "user")
                
                let channelData:NSData = channelList.mj_JSONData()! as NSData
                UserDefaults.standard.set(channelData, forKey: "channelList")
                
                if (projectList.count > 0) {
                    let projectData:NSData = (projectList[0] as! NSDictionary).mj_JSONData()! as NSData
                    UserDefaults.standard.set(projectData, forKey: "project")
                }
                
                let modelData:NSData = projectList.mj_JSONData()! as NSData
                UserDefaults.standard.set(modelData, forKey: "projectList")
                UserDefaults.standard.synchronize()
                
                JPUSHService.setAlias(userModel.telephone,
                                      completion: { (iResCode, iAlias, seq) in
                                        if seq == 0 {
                                            print("别名 : \(userModel.telephone) ")
                                        }
                }, seq: 0)
                // 打标签 安管主任：AGM； 工程：GC
                if userModel.wyAccount.wyRole.name == "工程" {
                    JPUSHService.addTags(["GC"],
                                         completion: { (iResCode, iAlias, seq) in
                                            if seq == 0 {
                                                //  "打标签成功".ext_debugPrintAndHint()
                                            }
                    }, seq: 0)
                } else if userModel.wyAccount.wyRole.name == "安管主任" {
                    JPUSHService.addTags(["AGM"],
                                         completion: { (iResCode, iAlias, seq) in
                                            if seq == 0 {
                                                // "打标签成功".ext_debugPrintAndHint()
                                            }
                    }, seq: 0)
                } else if userModel.wyAccount.wyRole.name == "项目经理" {
                    JPUSHService.addTags(["PROM"],
                                         completion: { (iResCode, iAlias, seq) in
                                            if seq == 0 {
                                                // "打标签成功".ext_debugPrintAndHint()
                                            }
                    }, seq: 0)
                    
                    self.loginButtonClicked()
                } else {
                    
                    JPUSHService.setBadge(0) // JPush服务器
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    print("\(userModel.wyAccount.wyRole.name)")
                    if userModel.wyAccount.isFirstLogin.compare("y").rawValue == 0 { // 重置密码
                        self.onLoginChangeReset()
                    } else { // 跳到首页
                        self.delegate?.onGotoHome!(self)
                    }
                }
            } else {
                "登陆失败".ext_debugPrintAndHint()
            }
        } else {
            //登录失败
            switch(response["errorCode"] as! Int){
            case 11:
                "用户名不存在".ext_debugPrintAndHint()
                break
            default:
                
                let msg:String = response["message"] as! String
                msg.ext_debugPrintAndHint()
                break
            }
            
        }
    }
    
    //    #pragma mark ---点击登录按钮
    /**
     *  点击登录按钮 mcu
     */
    func loginButtonClicked() {
        
        let password:String = MSP_PASSWORD.md5
        
        //调用 登录平台接口,完成登录操作
        //注意:登录密码必须是经过MD5加密的
        MCUVmsNetSDK.shareInstance().loginMsp(withUsername: MSP_USERNAME, password: password, success: { (responseDic) in
            
            let obj:NSDictionary = responseDic as! NSDictionary
            let status:String = obj["status"] as! String
            
            if (status.compare("200").rawValue == 0) {
                
                UserDefaults.standard.set(true, forKey: "isLogin")
                UserDefaults.standard.synchronize()
            } else {
                
                UserDefaults.standard.set(false, forKey: "isLogin")
                UserDefaults.standard.synchronize()
//                "登陆失败".ext_debugPrintAndHint()
                print("登陆失败")
                //                //返回码为200,代表登录成功.返回码为202,203,204时,分别代表的意思是初始密码登录,密码强度不符合要求,密码过期.这三种情况都需要修改密码.请开发者使用当前账号登录BS端平台,按要求进行密码修改后,再进行APP的开发测试工作.其他返回码,请根据平台返回提示信息进行提示或处理
                ////                [SVProgressHUD showErrorWithStatus:responseDic[@"description"]];
            }
        }) { (error) in
            
            "服务器连接失败".ext_debugPrintAndHint()
            print("登陆请求失败")
        }
    }
    
    func onNext(_ response:[String : AnyObject]) {
        if response["state"] as! Bool{
            // 跳到重置密码
            self.onForgetPwdChangeReset()
            
        } else {
            //登录失败
            switch(response["errorCode"] as! Int){
            case 11:
                "用户名不存在".ext_debugPrintAndHint()
                break
            default:
                
                let msg:String = response["message"] as! String
                msg.ext_debugPrintAndHint()
                break
            }
            
        }
    }
    
    func onResetPwd(_ response:[String : AnyObject], _ requestKey:NSInteger) {
        if response["state"] as! Bool{
            let msg =  response["message"] as! String
            msg.ext_debugPrintAndHint()
            
            if requestKey == XHWLRequestKeyID.XHWL_RESETPWD.rawValue {
                
                // 跳到首页
                self.delegate?.onGotoHome!(self)
            } else if requestKey == XHWLRequestKeyID.XHWL_FORGETPWD.rawValue {
                
                // 跳到登录
                onResetChangeLogin()
            }
        } else {
            //登录失败
            switch(response["errorCode"] as! Int){
            case 11:
                "用户名不存在".ext_debugPrintAndHint()
                break
            default:
                
                let msg:String = response["message"] as! String
                msg.ext_debugPrintAndHint()
                break
            }
            
        }
    }
    
    // MARK: - 页面跳转
    
    // 忘记密码跳回到登陆页面 清数据
    func onForgetPwdChangeLogin() {
        self.forgetCodeV?.clearData()
        
        self.showV?.isHidden = false
        UIView.transition(from: self.forgetCodeV!,
                          to: self.showV!,
                          duration: 1.0,
                          options: UIViewAnimationOptions.transitionFlipFromLeft) { (animated) in
                            
                            self.workCode = ""
                            self.bringSubview(toFront: self.showV!)
        }
    }
    
    // 忘记密码跳转到重置密码页面 清数据
    func onForgetPwdChangeReset() {
        self.forgetCodeV?.clearData()
        
        self.setPwdV?.isHidden = false
        UIView.transition(from: self.forgetCodeV!,
                          to: self.setPwdV!,
                          duration: 1.0,
                          options: UIViewAnimationOptions.transitionFlipFromRight) { (animated) in
                            
                            self.isResetPwd = false
                            self.bringSubview(toFront: self.setPwdV!)
        }
    }
    
    // 登陆跳转到重置密码页面
    func onLoginChangeReset() {
        self.setPwdV?.isHidden = false
        UIView.transition(from: self.showV!,
                          to: self.setPwdV!,
                          duration: 1.0,
                          options: UIViewAnimationOptions.transitionFlipFromRight) { (animated) in
                            
                            self.isResetPwd = true
                            self.bringSubview(toFront: self.setPwdV!)
        }
    }
    
    // 重置密码页面跳转到登陆 清数据
    func onResetChangeLogin() {
        self.setPwdV?.clearData()
        
        self.showV?.isHidden = false
        UIView.transition(from: self.setPwdV!,
                          to: self.showV!,
                          duration: 1.0,
                          options: UIViewAnimationOptions.transitionFlipFromLeft) { (animated) in
                            
                            self.bringSubview(toFront: self.showV!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
