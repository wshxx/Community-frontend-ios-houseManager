//
//  XHWLLoginView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLLoginView: UIView {
    
    //无参无返回值
//    typealias funcBlock = () -> () //或者 () -> Void
    //返回值是String
//    typealias funcBackBlock = (UIButton) -> ()
    
//    var funcBackBlock:(UIButton) -> ()
    
    var funcBackBlock : (String, String) -> () = {param in }
    var forgetPwdBackBlock : () -> () = {param in }
    var topStr:String!
    var bottomStr:String!
    var forgetPwdBtn:UIButton!
    
    //返回值是String
//    typealias funcBlockA = (Int,Int) -> String
//    //返回值是一个函数指针，入参为String
//    typealias funcBlockB = (Int,Int) -> (String)->()
//    //返回值是一个函数指针，入参为String 返回值也是String
//    typealias funcBlockC = (Int,Int) -> (String)->String
//    var blockPropertyA : funcBlockA?  //这写法就可以初始时为nil了,因为生命周其中，(理想状态)可能为nil所以用?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let bgIV:UIImageView = UIImageView(frame: self.bounds)
        bgIV.image = UIImage(named: "login_showView")
        self.addSubview(bgIV)
        
        let titleL: UILabel = UILabel(frame: CGRect(x:28, y:23, width:310, height:30))
        titleL.textColor = color_01f0ff
        titleL.text = "登陆"
        titleL.font = font_18
        self.addSubview(titleL)
        
        let userTF:XHWLLoginTF = XHWLLoginTF(frame: CGRect(x:25, y:100, width:self.bounds.width-50, height:32), loginEnum: XHWLLoginTFEnum.user, placeholder:"请输入工号")
        userTF.funcBackBlock = {[weak self] str in
            self?.topStr = str
            
        }
        self.addSubview(userTF)
        
        let pwdTF:XHWLLoginTF = XHWLLoginTF(frame: CGRect(x:25, y:160, width:self.bounds.width-50, height:32), loginEnum: XHWLLoginTFEnum.password , placeholder:"请输入密码")
        
        pwdTF.funcBackBlock = {[weak self] str in
            self?.bottomStr = str
        }
        self.addSubview(pwdTF)
        
        forgetPwdBtn = UIButton(frame: CGRect(x:self.bounds.size.width-100, y:pwdTF.frame.maxY+5, width:85, height:30))
        forgetPwdBtn.setTitle("忘记密码？", for: UIControlState.normal)
        forgetPwdBtn.adjustsImageWhenHighlighted = false
        forgetPwdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        forgetPwdBtn.titleLabel?.font = font_14
        forgetPwdBtn.setTitleColor(color_c8e5f0, for: UIControlState.normal)
        forgetPwdBtn.addTarget(self, action: #selector(XHWLLoginView.onForgetPwdClick), for: UIControlEvents.touchUpInside)
        self.addSubview(forgetPwdBtn)
        
        let img = UIImage(named: "login_btn_highlight")
        
        let loginBtn:UIButton = UIButton(frame: CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!))
        loginBtn.setBackgroundImage(img, for: UIControlState.normal)
        loginBtn.setTitle("登陆", for: UIControlState.normal)
        loginBtn.adjustsImageWhenHighlighted = false
        loginBtn.titleLabel?.font = font_18
        loginBtn.center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height-40-(img?.size.height)!/2.0)
        loginBtn.setTitleColor(color_01f0ff, for: UIControlState.normal)
        loginBtn.addTarget(self, action: #selector(XHWLLoginView.onLoginClick), for: UIControlEvents.touchUpInside)
        self.addSubview(loginBtn)
    }
    
    func onForgetPwdClick() {
        self.forgetPwdBackBlock()
    }
    
    func onLoginClick(btn:UIButton) {
        
        self.endEditing(true)
        
        if (topStr != nil) && (bottomStr != nil) {
            self.funcBackBlock(topStr!, bottomStr!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
