//
//  XHWLForgetPwdView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLForgetPwdView: UIView, XHWLNetworkDelegate {
    
    var bgIV:UIImageView!
    var titleBtn: UIButton!
    var funcBackBlock : (String, String, String) -> () = {param in }
    var onBackBlock : () -> () = {param in }
    var topStr:String!
    var bottomStr:String!
    var pwdTF:XHWLLoginTF!
    var userTF:XHWLLoginTF!
    var codeTF:XHWLCodeTF!
    var loginBtn:UIButton!

    func clearData() {
        pwdTF.textField.text = ""
        userTF.textField.text = ""
        codeTF.textField.text = ""
        remainingSeconds = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        bgIV = UIImageView(frame: self.bounds)
        bgIV.image = UIImage(named: "login_showView")
        self.addSubview(bgIV)
        
        titleBtn = UIButton(frame: CGRect(x:28, y:23, width:310, height:30))
        titleBtn.setTitle("< 账号验证", for: UIControlState.normal)
        titleBtn.setTitleColor(color_01f0ff, for: UIControlState.normal)
        titleBtn.titleLabel?.font = font_18
        titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        titleBtn.addTarget(self, action: #selector(onBackLogin), for: UIControlEvents.touchUpInside)
        self.addSubview(titleBtn)
        
        userTF = XHWLLoginTF(frame: CGRect(x:25, y:100, width:self.bounds.width-50, height:40), loginEnum: XHWLLoginTFEnum.user, placeholder:"请输入工号")
        userTF.funcBackBlock = {str in
            self.topStr = str
        }
        self.addSubview(userTF)
        
        
        pwdTF = XHWLLoginTF(frame: CGRect(x:25, y:160, width:self.bounds.width-50, height:40), loginEnum: XHWLLoginTFEnum.user , placeholder:"请输入手机号")
        pwdTF.funcBackBlock = {str in
            self.bottomStr = str
        }
        self.addSubview(pwdTF)
        
        codeTF = XHWLCodeTF(frame: CGRect(x:25, y:220, width:self.bounds.width-50, height:40), placeholder:"")
        codeTF.funcBackBlock = {str in
            self.bottomStr = str
        }
        codeTF.onSendCodeClickBlock = { [weak self] _ in
              // 发送验证码
            self?.onSendVeriBtnClicked()
        }
        self.addSubview(codeTF)
        
        let img = UIImage(named: "login_btn_highlight")
        
        loginBtn = UIButton(frame: CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!))
        loginBtn.setBackgroundImage(img, for: UIControlState.normal)
        loginBtn.setTitle("下一步", for: UIControlState.normal)
        loginBtn.titleLabel?.font = font_18
        loginBtn.adjustsImageWhenHighlighted = false
        loginBtn.center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height-40-(img?.size.height)!/2.0)
        loginBtn.setTitleColor(color_01f0ff, for: UIControlState.normal)
        loginBtn.addTarget(self, action: #selector(XHWLLoginView.onLoginClick), for: UIControlEvents.touchUpInside)
        self.addSubview(loginBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgIV.bounds = self.bounds
        
        titleBtn.frame = CGRect(x:28, y:23, width:310, height:30)
        userTF.frame = CGRect(x:25, y:Screen_height/7.0, width:self.bounds.width-50, height:40)
        pwdTF.frame = CGRect(x:25, y:userTF.frame.maxY+10, width:self.bounds.width-50, height:40)
        codeTF.frame = CGRect(x:25, y:pwdTF.frame.maxY+10, width:self.bounds.width-50, height:40)
        
        let img = UIImage(named: "login_btn_highlight")
        loginBtn.frame = CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!)
        loginBtn.center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height*7/8.0-(img?.size.height)!/2.0)
    }
    
    // 返回首页
    func onBackLogin() {
        self.onBackBlock()
    }
    
    func onLoginClick(btn:UIButton) {
        self.endEditing(true)
        
        if (topStr != nil) && (bottomStr != nil) {
            
            self.funcBackBlock(pwdTF.textField.text!, codeTF.textField.text!, userTF.textField.text!)
        }
        
    }
    
    //发送短信验证码
    func onSendVeriBtnClicked() {
        
        self.endEditing(true)
        
        //传给发送验证码接口的参数
        let text:String = pwdTF.textField.text!
        let workCode:String = userTF.textField.text!
        
//        let url:String = "wyBase/getVerificatCode"
        
        if workCode.isEmpty {
            "您输入的工号为空".ext_debugPrintAndHint()
            return
        }
        
        //判断手机号格式是否正确
        if Validation.phoneNum(text).isRight {
            
            XHWLNetwork.shared.getVerCodeClick([text, workCode], self)
        } else {
            "您输入的手机号格式不正确".ext_debugPrintAndHint()
        }
        
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if response["state"] as! Bool{
            //发送验证码成功
            self.isCounting = true
            
            self.codeTF.sendCodeBtn.isEnabled = false
            "验证码发送成功".ext_debugPrintAndHint()
        } else{
            let msg:String = response["message"] as! String
            msg.ext_debugPrintAndHint()
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    var countDownTimer: Timer?//用于按钮计时

    //显示剩余秒数
    var remainingSeconds: Int = 0{
        willSet{
            codeTF.sendCodeBtn.setTitle("已发送(\(newValue))", for: .normal)
            if newValue <= 0{
                codeTF.sendCodeBtn.setTitle("发送验证码", for: .normal)
                isCounting = false
                codeTF.sendCodeBtn.isEnabled = true //设置按钮的isEnabled属性
            }
        }
    }
    
    //是否正在计数
    var isCounting = false{
        willSet{
            if newValue {
                
                remainingSeconds = 60
                countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(XHWLForgetPwdView.updateTimer(_:)), userInfo: nil, repeats: true)
                
            }else{
                countDownTimer?.invalidate()
                countDownTimer = nil
            }
        }
    }
    
    //更新剩余秒数
    func updateTimer(_ timer: Timer){
        remainingSeconds -= 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
