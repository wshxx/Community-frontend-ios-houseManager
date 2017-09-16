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
    var submitBtn:UIButton!
    var dataAry:NSMutableArray!
    var labelViewArray:NSMutableArray!
    var subView:XHWLMoreListView!
    var isShowSUbView:Bool = true
    var btnBlock:(NSInteger)->(Void) = { param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataAry = NSMutableArray()
        let array :NSArray = [["name":"姓名：", "content":"", "isHiddenEdit": false, "type": 0],
                              ["name":"类型：", "content":"", "isHiddenEdit": true, "type": 0],
                              ["name":"证件：", "content":"身份证", "isHiddenEdit":false, "type": 1],
                              ["name":"手机：", "content":"", "isHiddenEdit": true, "type": 0],
                              ["name":"时效：", "content":"请选择", "isHiddenEdit": false, "type": 2],
                              ["name":"车牌：", "content":"2017-11-11 09:12:30 \n 2017-11-11", "isHiddenEdit": true, "type": 0],
                              ["name":"业主认证：", "content":"是\n否", "isHiddenEdit":false, "type": 3]]
        

        
        dataAry = XHWLMenuModel.mj_objectArray(withKeyValuesArray: array)
        
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
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
                cardView.showText(leftText: menuModel.name, rightText:"")
                bgScrollView.addSubview(cardView)
                labelViewArray.add(cardView)
            }
            else if menuModel.type == 1 {
                let vertical:XHWLCheckListTF = XHWLCheckListTF(frame:CGRect.zero, checkListEnum:XHWLCheckListTFEnum.left)
                vertical.showText(leftText: menuModel.name, rightText: "", btnTitle: menuModel.content)
                vertical.btnBlock = {  [weak vertical]  in
                    let array:NSArray = ["sdhf", "sdfjdo"]
                    let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:array)
                    
                    let window: UIWindow = (UIApplication.shared.keyWindow)!
                    pickerView.dismissBlock = { [weak pickerView] (index)->() in
                        print("\(index)")
                        if index != -1 {
                            vertical?.showBtnTitle(array[index] as! String)
                        }
                        pickerView?.removeFromSuperview()
                    }
                    pickerView.frame = UIScreen.main.bounds
                    window.addSubview(pickerView)
                }
                bgScrollView.addSubview(vertical)
                labelViewArray.add(vertical)
            }
            else if menuModel.type == 2 {
                let timeView:XHWLCheckListTF = XHWLCheckListTF(frame:CGRect.zero, checkListEnum:XHWLCheckListTFEnum.right)
                timeView.showText(leftText: menuModel.name, rightText: "", btnTitle: menuModel.content)
                timeView.btnBlock = { [weak timeView] in
                    let array:NSArray = ["sdhf", "sdfjdo"]
                    let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:array)
                    
                    let window: UIWindow = (UIApplication.shared.keyWindow)!
                    pickerView.dismissBlock = { [weak pickerView] (index)->() in
                        print("\(index)")
                        if index != -1 {
                            timeView?.showBtnTitle(array[index] as! String)
                        }
                        pickerView?.removeFromSuperview()
                    }
                    pickerView.frame = UIScreen.main.bounds
                    window.addSubview(pickerView)
                }
                bgScrollView.addSubview(timeView)
                labelViewArray.add(timeView)
            }
            else if menuModel.type == 3 {
                let radioView:XHWLRadioView = XHWLRadioView()
                radioView.showText(leftText: menuModel.name, rightText: "是", btnTitle: "否")
                radioView.btnBlock = { index in
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
        }
        
        subView = XHWLMoreListView()
        bgScrollView.addSubview(subView)
        
        submitBtn = UIButton()
        submitBtn.setTitle("提交", for: UIControlState.normal)
        submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        submitBtn.titleLabel?.font = font_12
        submitBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        bgScrollView.addSubview(submitBtn)
    }
    
    func submitClick() {
        self.btnBlock(1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews() 
        
        bgImage.frame = self.bounds
        bgScrollView.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:self.bounds.size.height)
   
        
        for i in 0...labelViewArray.count-1 {
            let labelView :UIView = labelViewArray[i] as! UIView
            labelView.bounds = CGRect(x:0, y:0, width:258, height:20)
            labelView.center = CGPoint(x:self.frame.size.width/2.0, y:20+CGFloat(i*40))
        }
        let lastView:UIView = labelViewArray.lastObject as! UIView
        var topHeight:CGFloat = lastView.frame.maxY
        
        if subView.isHidden == false {
            subView.frame = CGRect(x:0, y:lastView.frame.maxY, width:self.bounds.size.width, height:120)
            topHeight = subView.frame.maxY
        } else {
            
            subView.frame = CGRect(x:0, y:lastView.frame.maxY, width:self.bounds.size.width, height:0)
        }
        
        submitBtn.frame = CGRect(x:(self.bounds.size.width-150)/2.0, y:topHeight+20, width:150, height:30)
        bgScrollView.contentSize = CGSize(width:0, height: submitBtn.frame.maxY+50)
    }
}
