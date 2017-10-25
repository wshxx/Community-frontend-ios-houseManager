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
    var roomView:XHWLSelTypeView!
//    var unit:String! = ""
    var roomNo:String! = ""
    var yzId:String! = ""
    var yzTele:String! = ""
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
        
        roomView = XHWLSelTypeView()
        roomView.showText("房间", "请选择房间", true)
        roomView.btnBlock = { [weak self] in
            if (self?.yzName.isEmpty)! {
                "您输入的业主信息".ext_debugPrintAndHint()
                return
            }
            self?.loadData()
        }
        self.addSubview(roomView)
        
//        phoneView = XHWLRoomView(frame:CGRect.zero)
//        phoneView.showText(leftText: "房间", rightText: "", btnTitle:"请选择单元", true)
//        phoneView.btnBlock = { [weak self] in
//
//        }
//        phoneView.textEndBlock = {[weak self] param in
//            self?.roomNo = param
//        }
//        self.addSubview(phoneView)
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
            self.yzTele = model.telephone
            
            print("\(model.address) = \(model.yzId)")
            if model.address.count > 0 {
                let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:model.address)
                
                let window: UIWindow = (UIApplication.shared.keyWindow)!
                pickerView.dismissBlock = { [weak pickerView] (index)->() in
                    print("\(index)")
                    if index != -1 {
                        self.roomNo = model.address[index] as! String
                        self.roomView?.showBtnTitle(model.address[index] as! String)
                        self.updateView()
//                        self.updateConstraints()
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
    
    func updateView() {
        let size:CGSize = "* 房间:".boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        
        let image:UIImage = UIImage(named:"home_switch")!
        
        let listSize:CGSize = self.roomNo.boundingRect(with: CGSize(width:258-size.width-image.size.width-20-40, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        
        //        titleL.frame = CGRect(x:10, y:0, width:size.width, height:30)
        //        listBtn.frame = CGRect(x: titleL.frame.maxX+10, y: 0, width: self.bounds.size.width-titleL.frame.size.width-30, height: listSize.height)
        
        roomView.frame = CGRect(x:(self.frame.size.width-258)/2.0, y:labelView.frame.maxY+10, width:258, height:listSize.height+10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelView.bounds = CGRect(x:0, y:0, width:258, height:30)
        labelView.center = CGPoint(x:self.frame.size.width/2.0, y:20)
        
//        roomView.bounds = CGRect(x:0, y:0, width:258, height:80)
//        roomView.center = CGPoint(x:self.frame.size.width/2.0, y:labelView.frame.maxY+60)
        
        
        let size:CGSize = "* 房间:".boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        
        let image:UIImage = UIImage(named:"home_switch")!
        
        let listSize:CGSize = self.roomNo.boundingRect(with: CGSize(width:258-size.width-image.size.width-15-40, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        
//        titleL.frame = CGRect(x:10, y:0, width:size.width, height:30)
//        listBtn.frame = CGRect(x: titleL.frame.maxX+10, y: 0, width: self.bounds.size.width-titleL.frame.size.width-30, height: listSize.height)
        
        roomView.bounds = CGRect(x:0, y:0, width:258, height:listSize.height+10)
        roomView.center = CGPoint(x:self.frame.size.width/2.0, y:labelView.frame.maxY+10+(listSize.height+10)/2.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
