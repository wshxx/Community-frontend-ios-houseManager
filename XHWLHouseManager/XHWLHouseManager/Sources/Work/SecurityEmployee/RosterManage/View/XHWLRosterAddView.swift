//
//  XHWLRosterAddView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit
protocol XHWLRosterAddViewDelegate:NSObjectProtocol {
    func cancelWith(rosterAddView:XHWLRosterAddView)
    func addWith(rosterAddView:XHWLRosterAddView)
}

class XHWLRosterAddView: UIView , XHWLNetworkDelegate{

    var bgView:UIView!
    var bgImage:UIImageView!
    var bgScrollView:UIScrollView!
    var typeView:XHWLSelTypeView!
    var nameV:XHWLCheckTF!
    var cardView:XHWLCheckTF!
    var detailV:XHWLRemarkView!
    var delegate:XHWLRosterAddViewDelegate!
    var cancelBtn:UIButton!
    var submitBtn:UIButton!
    var typeName:String = "黑名单"
    var nameStr:String = ""
    var cardStr:String = ""
    var cardType:String = "身份证"
    var remark:String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        setupView()
    }
    
    func clearData() {
         typeName = "黑名单"
         nameStr = ""
         cardStr = ""
         cardType = "身份证"
         remark = ""
    }
    
    func onCancel() {
        // 清空数据
        self.delegate.cancelWith(rosterAddView: self)
    }
    
    func onAdd() {
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        let params:NSDictionary = [
            "token":userModel.wyAccount.token, //   是    用户登录token
            "type": typeName,          //    是    类别：黑名单、灰名单
            "name":nameStr,                 //
            "telephone":"23",
            "certificateType":cardType,   //     证件类别
            "cetificateNo":cardStr,         //  证件号
            "remark":remark              // 描述
        ]
        
        XHWLNetwork.shared.postAddRosterClick(params, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        
        if requestKey == XHWLRequestKeyID.XHWL_ADDROSTER.rawValue {
            
            let dict = response["result"] as! NSDictionary
            let array = dict["rosterList"] as! NSArray
            if array.count <= 0 {
                return
            }
            
            self.delegate.addWith(rosterAddView: self)
//            //XHWLRosterModel(jsonData: array)
//            let dealArray:NSArray = XHWLRosterModel.mj_objectArray(withKeyValuesArray:array)
//            self.dataAry = dealArray as! NSMutableArray
//            self.warningView.dataAry = NSMutableArray()
//            self.warningView.dataAry.addObjects(from: dealArray as! [Any])
//            self.warningView.tableView.reloadData()
        }
//        else if requestKey == XHWLRequestKeyID.XHWL_ROSTERINFO.rawValue {
        
//            self.typeName = response["certificateType"]
//            self.tele = response["type"]
//        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgView = UIView()
        self.addSubview(bgView)
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"pop_bg")
        bgView.addSubview(bgImage)
        
        bgScrollView = UIScrollView()
        bgView.addSubview(bgScrollView)
        
        typeView = XHWLSelTypeView()
        typeView.showText("名单类型", "请选择", false)
        typeView.btnBlock = { [weak typeView] in
            self.endEditing(true)
            
            let array:NSArray! = ["黑名单", "灰名单"]
            
            let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:array)
            
            let window: UIWindow = (UIApplication.shared.keyWindow)!
            pickerView.dismissBlock = { [weak pickerView] (index)->() in
                print("\(index)")
                if index != -1 {
                    self.typeName = array[index] as! String
                    typeView?.showBtnTitle(array[index] as! String)
                }
                pickerView?.removeFromSuperview()
            }
            pickerView.frame = UIScreen.main.bounds
            window.addSubview(pickerView)
        }
        bgScrollView.addSubview(typeView)
        
        nameV = XHWLCheckTF()
        nameV.showText("姓名", "", false)
        nameV.textEndBlock = {[weak self] param in
                        self?.nameStr = param
        }
        bgScrollView.addSubview(nameV)
        
        cardView = XHWLCheckTF()
        cardView.showText("证件", "", false)
        cardView.textEndBlock = {[weak self] param in
            self?.cardStr = param
            
            let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
            let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
            let params:NSDictionary = [
                "token":userModel.wyAccount.token, //   是    用户登录token
                "cetificateNo": param          //
            ]
            
//            XHWLNetwork.shared.postRosterInfoClick(params, self!)
        }
        bgScrollView.addSubview(cardView)
        
        detailV = XHWLRemarkView()
        detailV.showText("详情")
        detailV.textViewBlock = { text in
            self.remark = text
        }
        bgScrollView.addSubview(detailV)
        
        cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        cancelBtn.titleLabel?.font = font_14
        cancelBtn.setBackgroundImage(UIImage(named:"menu_text_bg"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(onCancel), for: UIControlEvents.touchUpInside)
        bgScrollView.addSubview(cancelBtn)
        
        submitBtn = UIButton()
        submitBtn.setTitle("增加", for: UIControlState.normal)
        submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        submitBtn.titleLabel?.font = font_14
        submitBtn.setBackgroundImage(UIImage(named:"menu_text_bg"), for: UIControlState.normal)
        submitBtn.addTarget(self, action: #selector(onAdd), for: UIControlEvents.touchUpInside)
        bgScrollView.addSubview(submitBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.frame = CGRect(x:0, y:0, width:Screen_width*13/16.0, height:Screen_height*2/5.0)
        bgView.center = CGPoint(x:self.frame.size.width/2.0, y:self.frame.size.height/2.0)
        bgScrollView.frame = bgView.bounds
        
        bgImage.frame = bgView.bounds
        typeView.frame = CGRect(x:0, y:10, width:bgView.frame.size.width, height:30)
        nameV.frame = CGRect(x:0, y:typeView.frame.maxY+10, width:bgView.frame.size.width, height:30)
        cardView.frame = CGRect(x:0, y:nameV.frame.maxY+10, width:bgView.frame.size.width, height:30)
        detailV.frame = CGRect(x:-30, y:cardView.frame.maxY+5, width:bgView.frame.size.width+30, height:80)
        
        cancelBtn.bounds = CGRect(x:0, y:0, width:80, height:30)
        cancelBtn.center = CGPoint(x:bgView.bounds.size.width/4.0, y:bgView.bounds.size.height-30)
        
        submitBtn.bounds = CGRect(x:0, y:0, width:80, height:30)
        submitBtn.center = CGPoint(x:bgView.bounds.size.width*3/4.0, y:bgView.bounds.size.height-30)
        bgScrollView.contentSize = CGSize(width:0, height:submitBtn.frame.maxY+20)
    }
}
