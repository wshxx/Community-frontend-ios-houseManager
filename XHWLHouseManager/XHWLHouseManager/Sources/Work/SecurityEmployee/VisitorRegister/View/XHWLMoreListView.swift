//
//  XHWLMoreListView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMoreListView: UIView , XHWLNetworkDelegate{

    var labelView:XHWLCheckTF!
    var phoneView:XHWLRoomView!
    var unit:String! = ""
    var roomNo:String! = ""
    var yzId:String! = ""
    var yzName:String! = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        labelView = XHWLCheckTF()
        labelView.showText("业主", "", true)
        labelView.textEndBlock = {[weak self] param in
            self?.yzName = param
        }
        self.addSubview(labelView)
        
        phoneView = XHWLRoomView(frame:CGRect.zero)
        phoneView.showText(leftText: "房间", rightText: "", btnTitle:"请选择单元", true)
        phoneView.btnBlock = { [weak self] in
            if (self?.yzName.isEmpty)! {
                "您输入的业主信息".ext_debugPrintAndHint()
                return
            }
            self?.loadData()
        }
        phoneView.textEndBlock = {[weak self] param in
            self?.roomNo = param
        }
        self.addSubview(phoneView)
    }
    
    //获取单元信息
    func loadData() {
        
        let data:NSData = UserDefaults.standard.object(forKey: "user") as! NSData
        let userModel:XHWLUserModel = XHWLUserModel.mj_object(withKeyValues: data.mj_JSONObject())
        
        let params:[String:Any] = ["yzName":yzName, // 业主姓名
            "token":userModel.wyAccount.token,
            ] //
        
        XHWLNetwork.shared.postUnitClick(params as NSDictionary, self)
    }
    
    // MARK: - XHWLNetworkDelegate
    
    func requestSuccess(_ requestKey:NSInteger, _ response:[String : AnyObject]) {
        //        历史告警
        if response["result"] is NSNull {
            return
        }
        
        if requestKey == XHWLRequestKeyID.XHWL_UNIT.rawValue {
            let dict = response["result"] as! NSDictionary
            let model:XHWLUnitModel = XHWLUnitModel.mj_object(withKeyValues: dict)
            self.yzId = model.yzId
            
            print("\(model.address) = \(model.yzId)")
            if model.address.count > 0 {
                let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:model.address)
                
                let window: UIWindow = (UIApplication.shared.keyWindow)!
                pickerView.dismissBlock = { [weak pickerView] (index)->() in
                    print("\(index)")
                    if index != -1 {
                        self.unit = model.address[index] as! String
                        self.phoneView?.showBtnTitle(model.address[index] as! String)
                    }
                    pickerView?.removeFromSuperview()
                }
                pickerView.frame = UIScreen.main.bounds
                window.addSubview(pickerView)
            }
        }
    }
    
    func requestFail(_ requestKey:NSInteger, _ error:NSError) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelView.bounds = CGRect(x:0, y:0, width:258, height:20)
        labelView.center = CGPoint(x:self.frame.size.width/2.0, y:30)
        
        phoneView.bounds = CGRect(x:0, y:0, width:258, height:80)
        phoneView.center = CGPoint(x:self.frame.size.width/2.0, y:labelView.frame.maxY+60)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
