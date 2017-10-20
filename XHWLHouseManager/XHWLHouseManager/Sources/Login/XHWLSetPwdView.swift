//
//  XHWLSetPwdView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/31.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSetPwdView: UIView {
    
    var bgIV:UIImageView!
    var titleL: UILabel!
    var userTF:XHWLLoginTF!
    var pwdTF:XHWLLoginTF!
    var loginBtn:UIButton!
    var cancelBtn:UIButton!
    
    var funcBackBlock : (String, String) -> () = {param in }
    var onCancelBlock : () -> () = {param in }
    var topStr:String!
    var bottomStr:String!
    var isWindowToLogin:Bool? = true {
        willSet {
            if newValue == false {
                cancelBtn.isHidden = true
            }
        }
    }
    
    func clearData() {
        userTF.textField.text = ""
        pwdTF.textField.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        bgIV = UIImageView(frame: self.bounds)
        bgIV.image = UIImage(named: "login_showView")
        self.addSubview(bgIV)
        
        titleL = UILabel(frame: CGRect(x:28, y:23, width:310, height:30))
        titleL.textColor = color_01f0ff
        titleL.text = "重新设置密码"
        titleL.font = font_18
        self.addSubview(titleL)
        
        userTF = XHWLLoginTF(frame: CGRect(x:25, y:100, width:self.bounds.width-50, height:40), loginEnum: XHWLLoginTFEnum.password, placeholder:"请输入密码")
        userTF.funcBackBlock = {str in
            self.topStr = str
        }
        self.addSubview(userTF)
        
        
        pwdTF = XHWLLoginTF(frame: CGRect(x:25, y:160, width:self.bounds.width-50, height:40), loginEnum: XHWLLoginTFEnum.password , placeholder:"请确认密码")
        pwdTF.funcBackBlock = {str in
            self.bottomStr = str
        }
        self.addSubview(pwdTF)
        
        let img = UIImage(named: "login_btn_highlight")
        
        loginBtn = UIButton(frame: CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!))
        loginBtn.setBackgroundImage(img, for: UIControlState.normal)
        loginBtn.setTitle("确定", for: UIControlState.normal)
        loginBtn.titleLabel?.font = font_18
        loginBtn.adjustsImageWhenHighlighted = false
        loginBtn.center = CGPoint(x: self.bounds.size.width/4.0, y: self.bounds.size.height-40-(img?.size.height)!/2.0)
        loginBtn.setTitleColor(color_01f0ff, for: UIControlState.normal)
        loginBtn.addTarget(self, action: #selector(XHWLSetPwdView.onLoginClick), for: UIControlEvents.touchUpInside)
        self.addSubview(loginBtn)
        
        cancelBtn = UIButton(frame: CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!))
        cancelBtn.setBackgroundImage(img, for: UIControlState.normal)
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.titleLabel?.font = font_18
        cancelBtn.adjustsImageWhenHighlighted = false
        cancelBtn.center = CGPoint(x: self.bounds.size.width*3/4.0, y: self.bounds.size.height-40-(img?.size.height)!/2.0)
        cancelBtn.setTitleColor(color_01f0ff, for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(XHWLSetPwdView.onCancelClick), for: UIControlEvents.touchUpInside)
        self.addSubview(cancelBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgIV.bounds = self.bounds
        
        titleL.frame = CGRect(x:28, y:23, width:310, height:30)
        userTF.frame = CGRect(x:25, y:Screen_height/7.0, width:self.bounds.width-50, height:40)
        pwdTF.frame = CGRect(x:25, y:userTF.frame.maxY+10, width:self.bounds.width-50, height:40)
        
        let img = UIImage(named: "login_btn_highlight")
        
        if self.isWindowToLogin! {
            loginBtn.frame = CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!)
            loginBtn.center = CGPoint(x: self.bounds.size.width/4.0, y: self.bounds.size.height*7/8.0-(img?.size.height)!/2.0)
            cancelBtn.frame = CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!)
            cancelBtn.center = CGPoint(x: self.bounds.size.width*3/4.0, y: self.bounds.size.height*7/8.0-(img?.size.height)!/2.0)
        } else {
            
            loginBtn.frame = CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!)
            loginBtn.center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height*7/8.0-(img?.size.height)!/2.0)
        }
    }
    
    func onLoginClick(btn:UIButton) {
        
        self.endEditing(true)
        
        if (topStr != nil) && (bottomStr != nil) {
            
            self.funcBackBlock(topStr!, bottomStr!)
        }
        
    }
    
    func onCancelClick() {
        self.onCancelBlock()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
