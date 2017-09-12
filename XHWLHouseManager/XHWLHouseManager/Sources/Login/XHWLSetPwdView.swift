//
//  XHWLSetPwdView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/31.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSetPwdView: UIView {
    
    var funcBackBlock : (String, String) -> () = {param in }
    var topStr:String!
    var bottomStr:String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let bgIV:UIImageView = UIImageView(frame: self.bounds)
        bgIV.image = UIImage(named: "xhwl_login_showView")
        self.addSubview(bgIV)
        
        let titleL: UILabel = UILabel(frame: CGRect(x:28, y:23, width:310, height:30))
        titleL.textColor = color_01f0ff
        titleL.text = "重新设置密码"
        titleL.font = font_18
        self.addSubview(titleL)
        
        let userTF:XHWLLoginTF = XHWLLoginTF(frame: CGRect(x:25, y:100, width:self.bounds.width-50, height:40), loginEnum: XHWLLoginTFEnum.password, placeholder:"请输入密码")
        userTF.funcBackBlock = {str in
            self.topStr = str
        }
        self.addSubview(userTF)
        
        
        let pwdTF:XHWLLoginTF = XHWLLoginTF(frame: CGRect(x:25, y:160, width:self.bounds.width-50, height:40), loginEnum: XHWLLoginTFEnum.password , placeholder:"请确认密码")
        pwdTF.funcBackBlock = {str in
            self.bottomStr = str
        }
        self.addSubview(pwdTF)
        
        let img = UIImage(named: "xhwl_login_btn_highlight")
        
        let loginBtn:UIButton = UIButton(frame: CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!))
        loginBtn.setBackgroundImage(img, for: UIControlState.normal)
        loginBtn.setTitle("登陆", for: UIControlState.normal)
        loginBtn.titleLabel?.font = font_18
        loginBtn.adjustsImageWhenHighlighted = false
        loginBtn.center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height-40-(img?.size.height)!/2.0)
        loginBtn.setTitleColor(color_01f0ff, for: UIControlState.normal)
        loginBtn.addTarget(self, action: #selector(XHWLLoginView.onLoginClick), for: UIControlEvents.touchUpInside)
        self.addSubview(loginBtn)
    }
    
    func onLoginClick(btn:UIButton) {
        
        if (topStr != nil) && (bottomStr != nil) {
            
            self.funcBackBlock(topStr!, bottomStr!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
