//
//  XHWLTransitionView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/31.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLTransitionView: UIView {

    var showV: XHWLLoginView?
    var setPwdV: XHWLSetPwdView?
    var logo : YLImageView?
    var funcBackBlock : (String, String) -> () = {param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        ////
        showV = XHWLLoginView(frame: CGRect(x:0, y:75, width:self.bounds.size.width, height:self.bounds.size.height-75))
        weak var weak_self:XHWLTransitionView?  = self
        showV?.funcBackBlock = { topStr,bottomStr in
            
            let params:[String: String] = ["telephone" : topStr, "password" : bottomStr]
            self .onLoginClick(params: params)
    
        }
        showV?.funcStartEditBlock = { isTop in
            self .onChangeLogo(isTop: isTop)
        }
        self.addSubview(showV!)
        
        ////
        setPwdV = XHWLSetPwdView(frame: CGRect(x:0, y:75, width:self.bounds.size.width, height:self.bounds.size.height-75))
        setPwdV?.funcBackBlock = { topStr,bottomStr in
            
            self.funcBackBlock(topStr,bottomStr);
        }
        setPwdV?.funcStartEditBlock = { isTop in
            self .onChangeLogo(isTop: isTop)
        }
        self.addSubview(setPwdV!)
        
        self.bringSubview(toFront: self.showV!)
        
        logo = YLImageView(frame: CGRect(x:self.bounds.size.width/2.0-71, y:0, width:142, height:129))
        self.addSubview(logo!)
        
        YLGIFImage.setPrefetchNum(5)
        let path = Bundle.main.url(forResource: "xhwl_login_logo_up", withExtension: "gif")?.absoluteString as String!
        logo?.image = YLGIFImage(contentsOfFile: path!)
        logo?.startAnimating()
    }
    
    // 登陆
    func onLoginClick(params:[String: String]) {
        
        self.onChangeSetPwd() // 可注释
        
        return
            
             XHWLHttpTool.sharedInstance.postHttpTool(url: "appBase/login", parameters: params, success: { (response) in
               
                    if response["state"] as! Bool{
                        //登录成功
                        //                        self.funcBackBlock(topStr,bottomStr);
                        
                        self.onChangeSetPwd()
                        
                    }else{
                        //                    AlertMessage.showAlertMessage(vc: self.superview, alertMessage: result["message"] , duration: 1)
                        
                        //登录失败
                        switch(response["errorCode"] as! Int){
                        case 11:
                            //用户名不存在
                            //                            AlertMessage.showAlertMessage(vc: self, alertMessage: "用户名不存在！", duration: 1)
                            
                            break
                        default:
                            break
                        }
                        
                    }
             }, failture: { (error) in
                
             })
    }
    
    func onChangeSetPwd() {
        
        UIView.transition(from: self.showV!,
                          to: self.setPwdV!,
                          duration: 2.0,
                          options: UIViewAnimationOptions.transitionFlipFromRight) { (animated) in
                            
                            YLGIFImage.setPrefetchNum(5)
                            let path = Bundle.main.url(forResource: "xhwl_login_logo_up", withExtension: "gif")?.absoluteString as String!
                            self.logo?.image = YLGIFImage(contentsOfFile: path!)
                            self.logo?.startAnimating()

                            self.bringSubview(toFront: self.setPwdV!)
                            self.bringSubview(toFront: self.logo!)
        }
    }
    
    func onChangeLogo(isTop:Bool) {
        if isTop {
            
            YLGIFImage.setPrefetchNum(5)
            let path = Bundle.main.url(forResource: "xhwl_login_logo_up", withExtension: "gif")?.absoluteString as String!
            self.logo?.image = YLGIFImage(contentsOfFile: path!)
            self.logo?.startAnimating()
        } else {
            YLGIFImage.setPrefetchNum(5)
            let path = Bundle.main.url(forResource: "xhwl_login_logo_down", withExtension: "gif")?.absoluteString as String!
            logo?.image = YLGIFImage(contentsOfFile: path!)
            logo?.startAnimating()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
