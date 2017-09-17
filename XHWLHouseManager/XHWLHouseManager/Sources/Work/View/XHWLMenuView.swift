//
//  XHWLMenuView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/8.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMenuView: UIView , XHWLMenuLabelViewDelegate, XHWLNetworkDelegate {

    var bgScrollView:UIScrollView!
    var bgImg :UIImageView!
    var headOutImg :UIImageView!
    var headImg :UIImageView!
    var dataAry:NSMutableArray!
    var labelViewArray:NSMutableArray!
    var isUserName:Bool? = false
    var block:(Bool) -> () = {param in }
    
//    var 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"姓名：", "content":userModel.name, "isHiddenEdit": false],
                   ["name":"工号：", "content":userModel.wyAccount.workCode, "isHiddenEdit": true],
                   ["name":"手机：", "content":userModel.telephone, "isHiddenEdit":false],
                   ["name":"岗位：", "content":userModel.wyAccount.wyRoleName, "isHiddenEdit": true],
                   ["name":"项目：", "content":userModel.wyAccount.wyRole.name, "isHiddenEdit": true]]
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        setupView()
        
        
    }
    
    func setupView() {
        bgImg = UIImageView()
        bgImg.frame = self.bounds
        bgImg.image = UIImage(named:"menu_bg")
        self.addSubview(bgImg)
        
        bgScrollView = UIScrollView()
        bgScrollView.frame = self.bounds
        bgScrollView.contentSize = CGSize(width:0, height:self.bounds.height+20)
        bgScrollView.showsVerticalScrollIndicator = false
        self.addSubview(bgScrollView)
        
        headOutImg = UIImageView()
        headOutImg.bounds = CGRect(x:0, y:0, width:86, height:86)
        headOutImg.image = UIImage(named:"menu_head_outer_circle")
        headOutImg.center = CGPoint(x:self.frame.size.width/2.0, y:58)
        bgScrollView.addSubview(headOutImg)
        
        headImg = UIImageView()
        headImg.bounds = CGRect(x:0, y:0, width:77, height:77)
        headImg.image = UIImage(named:"menu_head_inner_circle")
        headImg.center = CGPoint(x:self.frame.size.width/2.0, y:58)
        bgScrollView.addSubview(headImg)
        
        labelViewArray = NSMutableArray()
        for i in 0...dataAry.count-1 {
            let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
            let labelView: XHWLMenuLabelView = XHWLMenuLabelView()
            labelView.showText(leftText: menuModel.name, rightText:menuModel.content, isHiddenEdit: menuModel.isHiddenEdit)
            labelView.isHiddenEdit = menuModel.isHiddenEdit
            labelView.delegate = self
            labelView.tag = comTag+i
//            labelView.onOKClickBlock = { string, block in
//                if i == 0 {
//                    self.onModityUserName(string, { isTrue in
//                        block(isTrue)
//                    })
//                } else if i == 2 {
//                    self.onModityPhone(string, { isTrue in
//                        block(isTrue)
//                    })
//                }
//            }
            bgScrollView.addSubview(labelView)
            labelViewArray.add(labelView)
        }
    }
    
    func menuLabel(_ labelView:XHWLMenuLabelView, _ text:String, _ block:@escaping((Bool)->())) {
        
        self.block = block
        if labelView.tag-comTag == 0 {
            self.onModityUserName(text, block)
        }
        else if labelView.tag-comTag == 2 {
            
            self.onModityPhone(text, block)
        }
    }
    
    // 修改姓名
    func onModityUserName(_ string:String, _ block:@escaping(Bool) -> ()) {
        
        self.isUserName = true
        if string.isEmpty {
            "您输入的姓名不能为空".ext_debugPrintAndHint()
            return
        }
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        
        let params = ["name":string, "token":userModel.wyAccount.token]
        
//        let url:String = "wyBusiness/wyUser"
         XHWLNetwork.shared.postModifyUserClick(params as NSDictionary, self)
    
        
//        XHWLHttpTool.sharedInstance.postHttpTool(url:url , parameters:params, success: { (response) in
//            
//           
//        }, failture: { (error) in
//            
//        })
    }
    
    // 修改手机号
    func onModityPhone(_ string:String, _ block:@escaping (Bool) -> ()) {
        
        self.isUserName = false
        if Validation.phoneNum(string).isRight == false {
            "您输入的手机号不合法".ext_debugPrintAndHint()
            return
        }
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let params = ["telephone":string, "token":userModel.wyAccount.token]
      
        
        XHWLNetwork.shared.postModifyUserClick(params as NSDictionary, self)
        
//        let url:String = "wyBusiness/wyUser"
        
//        XHWLHttpTool.sharedInstance.postHttpTool(url:url , parameters:params, success: { (response) in
//            
//            
//        }, failture: { (error) in
//            
//        })
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if self.isUserName! {
            
            onModifyUserName(response)
        } else {
            
            onModifyPhone(response)
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    func onModifyPhone(_ response:[String : AnyObject]) {
        if response["state"] as! Bool{
            "修改手机号成功".ext_debugPrintAndHint()
            
            block(true)
            
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
    
    func onModifyUserName(_ response:[String : AnyObject]) {
        if response["state"] as! Bool{
            "修改姓名成功".ext_debugPrintAndHint()
            block(true)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for i in 0...labelViewArray.count-1 {
            
            let labelView :XHWLMenuLabelView = labelViewArray[i] as! XHWLMenuLabelView
            labelView.bounds = CGRect(x:0, y:0, width:258, height:30)
            labelView.center = CGPoint(x:self.frame.size.width/2.0, y:CGFloat(145 + i*52))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
