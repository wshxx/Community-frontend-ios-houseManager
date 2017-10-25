//
//  XHWLCheckListView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

enum XHWLCheckListViewEnum : Int{
    case textField = 0
    case textListLeft
    case textListRight
    case radio
}

class XHWLCheckListView: UIView {

    var bgImage:UIImageView!
    var bgScrollView:UIScrollView!
    var lineIV:UIImageView!
    var dataAry:NSMutableArray!
    var labelViewArray:NSMutableArray!
    var subView:XHWLMoreListView!
    var isShowSUbView:Bool = true
    
    var name:String! = ""
    var type:String! = ""
    var certificateType:String! = "身份证"
    var certificateNo:String! = ""
    var telephone:String! = ""
    var timeUnit:String! = "分钟"
    var timeNo:String! = ""
    var carNo:String! = ""
    var accessReason:String! = ""

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"姓名", "content":"", "isHiddenEdit": true, "type": 0],
                              ["name":"类型", "content":"", "isHiddenEdit": true, "type": 4],
                              ["name":"", "content":"身份证", "isHiddenEdit":true, "type": 1],
                              ["name":"手机", "content":"", "isHiddenEdit": true, "type": 0],
                              ["name":"时效", "content":"分钟", "isHiddenEdit": true, "type": 2],
                              ["name":"车牌", "content":"2017-11-11 09:12:30 \n 2017-11-11", "isHiddenEdit": false, "type": 0],
                              ["name":"事由", "content":"", "isHiddenEdit": true, "type": 0],
                              ["name":"业主认证", "content":"是\n否", "isHiddenEdit":true, "type": 3]]
        

        
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"subview_bg")
        self.addSubview(bgImage)
        
        bgScrollView = UIScrollView()
        bgScrollView.showsVerticalScrollIndicator = false
        self.addSubview(bgScrollView)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        self.addSubview(lineIV)
        
        labelViewArray = NSMutableArray()
        for i in 0...dataAry.count-1  {
            let menuModel :XHWLMenuModel = dataAry[i] as! XHWLMenuModel
            
            if menuModel.type == 0 {
                let cardView:XHWLCheckTF = XHWLCheckTF()
                cardView.showText(menuModel.name, "", menuModel.isHiddenEdit)
                cardView.textEndBlock = {param in
                    if i == 0 {
                        self.name = param
                    } else if i == 3 {
                        self.telephone = param
                    } else if i == 5 {
                        self.carNo = param
                    } else if i == 6 {
                        self.accessReason = param
                    }
                }
                bgScrollView.addSubview(cardView)
                labelViewArray.add(cardView)
            }
            else if menuModel.type == 1 {
                let vertical:XHWLCheckListTF = XHWLCheckListTF(frame:CGRect.zero, checkListEnum:XHWLCheckListTFEnum.left)
                vertical.showText(menuModel.name,  "", menuModel.content, menuModel.isHiddenEdit)
                vertical.btnBlock = {  [weak vertical]  in
                    self.endEditing(true)
                    let array:NSArray = ["身份证", "护照"]
                    let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:array)
                    
                    let window: UIWindow = (UIApplication.shared.keyWindow)!
                    pickerView.dismissBlock = { [weak pickerView] (index)->() in
                        print("\(index)")
                        if index != -1 {
                            self.certificateType = array[index] as! String
                            vertical?.showBtnTitle(array[index] as! String)
                        }
                        pickerView?.removeFromSuperview()
                    }
                    pickerView.frame = UIScreen.main.bounds
                    window.addSubview(pickerView)
                }
                vertical.textEndBlock = {param in
                    self.certificateNo = param
                }
                bgScrollView.addSubview(vertical)
                labelViewArray.add(vertical)
            }
            else if menuModel.type == 2 {
                let timeView:XHWLCheckListTF = XHWLCheckListTF(frame:CGRect.zero, checkListEnum:XHWLCheckListTFEnum.right)
                timeView.showText( menuModel.name, "", menuModel.content, menuModel.isHiddenEdit)
                timeView.btnBlock = { [weak timeView] in
                    self.endEditing(true)
                    let array:NSArray = ["分钟", "小时", "天", "月"]
                    let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:array)
                    
                    let window: UIWindow = (UIApplication.shared.keyWindow)!
                    pickerView.dismissBlock = { [weak pickerView] (index)->() in
                        print("\(index)")
                        if index != -1 {
                            self.timeUnit = array[index] as! String
                            timeView?.showBtnTitle(array[index] as! String)
                        }
                        pickerView?.removeFromSuperview()
                    }
                    pickerView.frame = UIScreen.main.bounds
                    window.addSubview(pickerView)
                }
                timeView.textEndBlock = {param in
                    self.timeNo = param
                }
                bgScrollView.addSubview(timeView)
                labelViewArray.add(timeView)
            }
            else if menuModel.type == 3 {
                let radioView:XHWLRadioView = XHWLRadioView()
                radioView.showText(leftText: menuModel.name, rightText: "是", btnTitle: "否")
                radioView.btnBlock = { index in
                    self.endEditing(true)
                    if index == 0 {
                        self.subView.isHidden = false
                    } else {
                        self.subView.isHidden = true
                    }
                    self.setNeedsLayout()
                }
                bgScrollView.addSubview(radioView)
                labelViewArray.add(radioView)
            }
            else if menuModel.type == 4 {
                let cardView:XHWLSelTypeView = XHWLSelTypeView()
                cardView.showText(menuModel.name, "请选择", menuModel.isHiddenEdit)
                cardView.btnBlock = { [weak cardView] in
                    self.endEditing(true)
                    
                    let array:NSArray = ["亲属", "友人", "家教", "家政", "快递", "外卖", "维修人员", "其他"]
                    let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:array)
                    
                    let window: UIWindow = (UIApplication.shared.keyWindow)!
                    pickerView.dismissBlock = { [weak pickerView] (index)->() in
                        print("\(index)")
                        if index != -1 {
                            self.type = array[index] as! String
                            cardView?.showBtnTitle(array[index] as! String)
                        }
                        pickerView?.removeFromSuperview()
                    }
                    pickerView.frame = UIScreen.main.bounds
                    window.addSubview(pickerView)
                }
                bgScrollView.addSubview(cardView)
                labelViewArray.add(cardView)
            }
            
        }
        
        subView = XHWLMoreListView()
        bgScrollView.addSubview(subView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews() 
        
        bgImage.frame = self.bounds
        bgScrollView.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:self.bounds.size.height)
   
        
        for i in 0...labelViewArray.count-1 {
            let labelView :UIView = labelViewArray[i] as! UIView
            labelView.bounds = CGRect(x:0, y:0, width:258, height:30)
            labelView.center = CGPoint(x:self.frame.size.width/2.0, y:40+CGFloat(i*40))
        }
        let lastView:UIView = labelViewArray.lastObject as! UIView
        var topHeight:CGFloat = lastView.frame.maxY
        
        if subView.isHidden == false {
            subView.frame = CGRect(x:0, y:lastView.frame.maxY, width:self.bounds.size.width, height:120)
            topHeight = subView.frame.maxY
        } else {
            
            subView.frame = CGRect(x:0, y:lastView.frame.maxY, width:self.bounds.size.width, height:0)
        }
        
        bgScrollView.contentSize = CGSize(width:0, height: subView.frame.maxY+50)
    }
}
