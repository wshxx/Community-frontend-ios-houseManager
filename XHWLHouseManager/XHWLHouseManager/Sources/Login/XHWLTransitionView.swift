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
    var forgetCodeV:XHWLForgetPwdView!
//    var logo : YLImageView?
    
    var funcBackBlock : (String, String) -> () = {param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        ////
        showV = XHWLLoginView(frame: CGRect(x:0, y:75+30, width:self.bounds.size.width, height:self.bounds.size.height-75-60))
        weak var weak_self:XHWLTransitionView?  = self
        showV?.funcBackBlock = { topStr,bottomStr in
            
            self.onLoginClick(topStr: topStr,bottomStr: bottomStr)
        }
        showV?.forgetPwdBackBlock = { _ in
            self.onForgetCode()
        }
        self.addSubview(showV!)
        
        ////
        setPwdV = XHWLSetPwdView(frame: CGRect(x:0, y:75+30, width:self.bounds.size.width, height:self.bounds.size.height-75-60))
        setPwdV?.funcBackBlock = { topStr,bottomStr in
            
            self.funcBackBlock(topStr,bottomStr);
        }
        setPwdV?.isHidden = true
        self.addSubview(setPwdV!)
        
        self.bringSubview(toFront: self.showV!)
        
        forgetCodeV = XHWLForgetPwdView(frame: CGRect(x:0, y:75, width:self.bounds.size.width, height:self.bounds.size.height-75))
        forgetCodeV.funcBackBlock = { topStr,bottomStr in
            
            self.funcBackBlock(topStr,bottomStr);
        }
        forgetCodeV.isHidden = true
        self.addSubview(forgetCodeV)
        
//        logo = YLImageView(frame: CGRect(x:self.bounds.size.width/2.0-71, y:0, width:142, height:129))
//        self.addSubview(logo!)
        
//        YLGIFImage.setPrefetchNum(5)
//        let path = Bundle.main.url(forResource: "xhwl_login_logo_up", withExtension: "gif")?.absoluteString as String!
//        logo?.image = YLGIFImage(contentsOfFile: path!)
//        logo?.startAnimating()
    }

    func onForgetCode() {
        self.forgetCodeV?.isHidden = false
        UIView.transition(from: self.showV!,
                          to: self.forgetCodeV!,
                          duration: 2.0,
                          options: UIViewAnimationOptions.transitionFlipFromRight) { (animated) in
                            
                            //                            YLGIFImage.setPrefetchNum(5)
                            //                            let path = Bundle.main.url(forResource: "xhwl_login_logo_up", withExtension: "gif")?.absoluteString as String!
                            //                            self.logo?.image = YLGIFImage(contentsOfFile: path!)
                            //                            self.logo?.startAnimating()
                            
                            self.bringSubview(toFront: self.forgetCodeV!)
                            //                            self.bringSubview(toFront: self.logo!)
        }
    }
    
    // MARK: 登陆
    func onLoginClick(topStr:String, bottomStr:String) {
        
        let params:[String: String] = [:]// ["telephone" : topStr, "password" : bottomStr]
        print("\(params)")
        
        self.onChangeSetPwd() // 可注释
        return
        let url:String = "ssh/v1/wyBase/login" + "/\(topStr)/\(bottomStr)"
        XHWLHttpTool.sharedInstance.getHttpTool(url:url , parameters: params, success: { (response) in
            
            
            if response["state"] as! Bool{
                //登录成功
                //                        self.funcBackBlock(topStr,bottomStr);
                
                self.onChangeSetPwd()
                
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
    
    func onChangeSetPwd() {
        
        
        self.setPwdV?.isHidden = false
        UIView.transition(from: self.showV!,
                          to: self.setPwdV!,
                          duration: 2.0,
                          options: UIViewAnimationOptions.transitionFlipFromRight) { (animated) in
                            
//                            YLGIFImage.setPrefetchNum(5)
//                            let path = Bundle.main.url(forResource: "xhwl_login_logo_up", withExtension: "gif")?.absoluteString as String!
//                            self.logo?.image = YLGIFImage(contentsOfFile: path!)
//                            self.logo?.startAnimating()
                            
                            self.bringSubview(toFront: self.setPwdV!)
//                            self.bringSubview(toFront: self.logo!)
        }
    }

    
//    func onChangeLogo(isTop:Bool) {
//        if isTop {
//
//            YLGIFImage.setPrefetchNum(5)
//            let path = Bundle.main.url(forResource: "xhwl_login_logo_up", withExtension: "gif")?.absoluteString as String!
//            self.logo?.image = YLGIFImage(contentsOfFile: path!)
//            self.logo?.startAnimating()
//        } else {
//            YLGIFImage.setPrefetchNum(5)
//            let path = Bundle.main.url(forResource: "xhwl_login_logo_down", withExtension: "gif")?.absoluteString as String!
//            logo?.image = YLGIFImage(contentsOfFile: path!)
//            logo?.startAnimating()
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
