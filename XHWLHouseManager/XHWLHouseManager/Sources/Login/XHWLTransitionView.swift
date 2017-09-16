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
//    @objc optional func on(_ trianView:XHWLTransitionView)
}

class XHWLTransitionView: UIView {

    var showV: XHWLLoginView?
    var setPwdV: XHWLSetPwdView?
    var forgetCodeV:XHWLForgetPwdView!
    weak var delegate:XHWLTransitionViewDelegate?
    var funcBackBlock : (String, String) -> () = {param in }
    var workCode:String!
    var isResetPwd:Bool = false // 是否是重置密码
//    var progressHUD:XHMLProgressHUD!
    
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
        
        
//        // 跳到首页
//        self.delegate?.onGotoHome!(self)
//        return
//        self.onLoginChangeReset()// 可删除
//        return
        
        let params:NSArray = [topStr, bottomStr]
        let url:String = "wyBase/login"
        
        if topStr.isEmpty {
            "您输入的工号为空".ext_debugPrintAndHint()
            return
        }
        
        if bottomStr.isEmpty {
            "您输入的密码为空".ext_debugPrintAndHint()
            return
        }
        
//        self.progressHUD.show()
        
        XHWLHttpTool.sharedInstance.getHttpTool(url:url , parameters:params, success: { (response) in
            
//            self.progressHUD.hide()
            if response["state"] as! Bool{
                "登陆成功".ext_debugPrintAndHint()
                //登录成功
                let wyUser:NSDictionary = response["result"]!["wyUser"] as! NSDictionary
                let projectList:NSArray = response["result"]!["projectList"] as! NSArray
                
                print("\(wyUser)")
                let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: wyUser)
                let data:NSData = userModel.mj_JSONData()! as NSData
                UserDefaults.standard.set(data, forKey: "user")
                
//                let modelAry:NSArray = XHWLProjectModel.mj_objectArray(withKeyValuesArray: projectList)
                let modelData:NSData = projectList.mj_JSONData()! as NSData
                UserDefaults.standard.set(modelData, forKey: "projectList")
                UserDefaults.standard.synchronize()
                
                print("\(userModel.wyAccount.wyRole.name)")
                userModel.wyAccount.wyRole.name.ext_debugPrintAndHint()
                if userModel.wyAccount.isFirstLogin.compare("y").rawValue == 0 { // 重置密码
                    self.onLoginChangeReset()
                } else { // 跳到首页
                    self.delegate?.onGotoHome!(self)
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
        }, failture: { (error) in
            
        })
    }
    
    // 下一步
    func onNextResetPwdClick(_ topStr:String, _ bottomStr:String, _ workCode:String) {
        
//        self.onForgetPwdChangeReset()// 可删除
//        return
        
        let params = ["telephone":topStr,
                      "verificatCode":bottomStr,
                      "workCode": workCode]
        let url:String = "wyBase/testVerificatCode"
        
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
        
        XHWLHttpTool.sharedInstance.postHttpTool(url:url , parameters:params, success: { (response) in
            
            if response["state"] as! Bool{
//                "修改成功".ext_debugPrintAndHint()
                
                self.workCode = workCode
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
        }, failture: { (error) in
            
        })
    }
    
    // 重置密码
    func onResetPwdClick(_ topStr:String, _ bottomStr:String) {
        
//        self.delegate?.onGotoHome!(self)
//        return
        
        var params:[String: Any]!
        var url:String!
        
        if topStr.compare(bottomStr).rawValue != 0 {
            "您输入的两次密码不一致".ext_debugPrintAndHint()
            return
        }
        
        if isResetPwd { // 重置密码
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            print("\(data.mj_JSONObject()) ")
            
            let dict:NSDictionary = data.mj_JSONObject() as! NSDictionary
            
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: dict)
            
            print("\n \(userModel.wyAccount.token)")
            
            url = "wyBase/password/reset"
            params = ["token":userModel.wyAccount.token, "password":bottomStr]
            
        } else {
            url = "wyBase/password/modify"
            params = ["workCode":self.workCode, "password":bottomStr]
        }
        
        XHWLHttpTool.sharedInstance.postHttpTool(url:url , parameters:params, success: { (response) in
            
            if response["state"] as! Bool{
                let msg =  response["message"] as! String
                msg.ext_debugPrintAndHint()
          
                // 跳到首页
                self.delegate?.onGotoHome!(self)
                
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
        }, failture: { (error) in
            
        })
    }
    
    // 忘记密码跳回到登陆页面 清数据
    func onForgetPwdChangeLogin() {
        self.forgetCodeV?.clearData()
        
        self.showV?.isHidden = false
        UIView.transition(from: self.forgetCodeV!,
                          to: self.showV!,
                          duration: 2.0,
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
                          duration: 2.0,
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
                          duration: 2.0,
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
                          duration: 2.0,
                          options: UIViewAnimationOptions.transitionFlipFromLeft) { (animated) in
                            
                            self.bringSubview(toFront: self.showV!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
