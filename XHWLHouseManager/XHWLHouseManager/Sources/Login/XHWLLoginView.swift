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
    
    var funcStartEditBlock : (Bool) -> () = {param in }
    var funcBackBlock : (String, String) -> () = {param in }
    var topStr:String!
    var bottomStr:String!
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
        bgIV.image = UIImage(named: "xhwl_login_showView")
        self.addSubview(bgIV)
        
        let titleL: UILabel = UILabel(frame: CGRect(x:28, y:23, width:310, height:30))
        titleL.textColor = color_5284d6
        titleL.text = "登陆"
        titleL.font = font_18
        self.addSubview(titleL)
        
        
        var weak_self:XHWLLoginView = self
        let userTF:XHWLLoginTF = XHWLLoginTF(frame: CGRect(x:25, y:100, width:self.bounds.width-50, height:32), loginEnum: XHWLLoginTFEnum.user, placeholder:"请输入工号")
        userTF.funcBackBlock = {str in
            weak_self.topStr = str
            
        }
        userTF.funcStartEditBlock = {
            self.funcStartEditBlock(true)
        }
        self.addSubview(userTF)
        
        let pwdTF:XHWLLoginTF = XHWLLoginTF(frame: CGRect(x:25, y:160, width:self.bounds.width-50, height:32), loginEnum: XHWLLoginTFEnum.password , placeholder:"请输入密码")
        
        pwdTF.funcBackBlock = {str in
            weak_self.bottomStr = str
        }
        pwdTF.funcStartEditBlock = {
            self.funcStartEditBlock(false)
        }
        self.addSubview(pwdTF)
        
        let img = UIImage(named: "xhwl_login_btn_highlight")
        
        let loginBtn:UIButton = UIButton(frame: CGRect(x:0, y:0, width:(img?.size.width)!, height:(img?.size.height)!))
        loginBtn.setBackgroundImage(img, for: UIControlState.normal)
        loginBtn.setTitle("登陆", for: UIControlState.normal)
        loginBtn.adjustsImageWhenHighlighted = false
        loginBtn.titleLabel?.font = font_18
        loginBtn.center = CGPoint(x: self.bounds.size.width/2.0, y: self.bounds.size.height-40-(img?.size.height)!/2.0)
        loginBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
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