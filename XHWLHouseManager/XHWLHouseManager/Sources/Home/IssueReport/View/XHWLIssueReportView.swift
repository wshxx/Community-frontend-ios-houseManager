//
//  XHWLIssueReportView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLIssueReportViewDelegate:NSObjectProtocol {
    @objc optional func onSafeGuard( _ index:NSInteger, _ count:NSInteger)
}

class XHWLIssueReportView: UIView {

    var bgImage:UIImageView!
    var bgSc:UIScrollView!
    var pickPhoto:XHWLPickPhotoView!
    var remark:XHWLRemarkView!
    var radioView: XHWLRadioView!
    var typeView: XHWLSelTypeView!
    var dotView: XHWLLabelView!
    var managerBtn:UIButton!
    var selfBtn:UIButton!
    var imageArray:NSMutableArray = NSMutableArray()
    var scanModel:XHWLScanModel! {
        willSet {
            if (newValue != nil) {
                
                if newValue.type == "plant" {
                    let scanDataModel:XHWLScanDataModel = newValue.plant
//                 dotView.showText(leftText: "巡检点位：", rightText:"(\(scanDataModel.longitude),\(scanDataModel.latitude))")
                    dotView.showText(leftText: "巡检点位：", rightText:"\(scanDataModel.descriptions)")
                } else if newValue.type == "equipment" {
                    let scanDataModel:XHWLScanDataModel = newValue.equipment
                    dotView.showText(leftText: "巡检点位：", rightText:scanDataModel.address)
                }
            }
        }
    }
    var cancelBtn:UIButton!
    var submitBtn:UIButton!
    weak var delegate:XHWLIssueReportViewDelegate?
    var btnBlock:(NSInteger, String, String, Bool, Bool)->(Void) = { param in }
    var dismissBlock:()->() = {_ in }
    var urgency:Bool = false
    var type:NSInteger! = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        bgImage = UIImageView()
        bgImage.image = UIImage(named:"menu_bg")
        self.addSubview(bgImage)
        
        bgSc = UIScrollView()
        bgSc.showsVerticalScrollIndicator = false
        self.addSubview(bgSc)
        
        typeView = XHWLSelTypeView()
        typeView.showText("异常类型", "安防", false)
        typeView.btnBlock = { [weak typeView] in
            self.endEditing(true)
            let array:NSArray = ["安防", "工程", "环境", "客服"]
            let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:array)
            
            let window: UIWindow = (UIApplication.shared.keyWindow)!
            pickerView.dismissBlock = { [weak pickerView] (index)->() in
                print("\(index)")
                if index != -1 {
                    self.type = index+1 // array[index] as! String
                    typeView?.showBtnTitle(array[index] as! String)
                }
                pickerView?.removeFromSuperview()
            }
            pickerView.frame = UIScreen.main.bounds
            window.addSubview(pickerView)
        }
        bgSc.addSubview(typeView)
        
        
        
        dotView = XHWLLabelView()
        dotView.showText(leftText: "巡检点位：", rightText:"中海华庭水泵房")
        bgSc.addSubview(dotView)
        
        remark = XHWLRemarkView()
        remark.showText("备注")
        bgSc.addSubview(remark)
        
        radioView = XHWLRadioView()
        radioView.showText(leftText: "紧急情况：", rightText: "是", btnTitle: "否")
        radioView.onDefaultSelect(false)
        radioView.btnBlock = { [weak self] index in
            
            if index == 0 {
                self?.urgency = true
            } else {
                self?.urgency = false
            }
            
        }
        bgSc.addSubview(radioView)
        
        pickPhoto = XHWLPickPhotoView(frame: CGRect.zero, false)
        pickPhoto.showText("上传照片：")
//        pickPhoto.isShow = false
        pickPhoto.addPictureBlock = { index, count in
            self.delegate?.onSafeGuard!( index, count)
        }
        bgSc.addSubview(pickPhoto)
        
        managerBtn = UIButton()
        managerBtn.isHidden = true
        managerBtn.setImage(UIImage(named:"IssueReport_manager"), for: UIControlState.normal)
        managerBtn.addTarget(self, action: #selector(managerClick), for: UIControlEvents.touchUpInside)
        self.addSubview(managerBtn)
        
        selfBtn = UIButton()
        selfBtn.isHidden = true
        selfBtn.setImage(UIImage(named:"IssueReport_self"), for: UIControlState.normal)
        selfBtn.addTarget(self, action: #selector(selfClick), for: UIControlEvents.touchUpInside)
        self.addSubview(selfBtn)
        
        
//        cancelBtn = UIButton()
//        cancelBtn.setTitle("取消", for: UIControlState.normal)
//        cancelBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
//        cancelBtn.titleLabel?.font = font_14
//        cancelBtn.tag = comTag
//        cancelBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
//        cancelBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
//        self.addSubview(cancelBtn)
        
        submitBtn = UIButton()
        submitBtn.setTitle("提交", for: UIControlState.normal)
        submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        submitBtn.titleLabel?.font = font_14
        submitBtn.tag = comTag+1
        submitBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        self.addSubview(submitBtn)
    }
    
    func selfClick() {
        self.btnBlock(self.type, dotView.contentTF.text! , remark.textView.text! , urgency, false)
    }
    
    func managerClick() {
        self.btnBlock(self.type, dotView.contentTF.text! , remark.textView.text! , urgency, true)
        
    }

    func submitClick(btn:UIButton) {
        
        if btn.currentTitle == "取消" {
//            self.dismissBlock()
            bgSc.isUserInteractionEnabled = true
            
            managerBtn.isHidden = true
            selfBtn.isHidden = true
            submitBtn.setTitle("提交", for: UIControlState.normal)
        } else {
            bgSc.isUserInteractionEnabled = false
            
            if imageArray.count == 0 {
                "请先上传图片或视频".ext_debugPrintAndHint()
                return
            }
            
            managerBtn.isHidden = false
            selfBtn.isHidden = false
            submitBtn.setTitle("取消", for: UIControlState.normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        bgSc.frame = CGRect(x:0, y:0, width:self.bounds.size.width, height:self.bounds.size.height-60)
        
        typeView.frame = CGRect(x:10, y:10, width:self.bounds.size.width-10, height:20)
        dotView.frame = CGRect(x:10, y:typeView.frame.maxY+10, width:self.bounds.size.width-10, height:20)
        remark.frame = CGRect(x:10, y:dotView.frame.maxY+10, width:self.bounds.size.width-10, height:80)
        
        radioView.frame = CGRect(x:10, y:remark.frame.maxY+10, width:self.bounds.size.width-10, height:20)
        pickPhoto.frame = CGRect(x:0, y:radioView.frame.maxY+10, width:self.bounds.size.width-20, height:80)
        bgSc.contentSize = CGSize(width:self.bounds.size.width, height:self.bounds.size.height)
        
        managerBtn.frame = CGRect(x:0, y:0, width:50, height:60)
        managerBtn.center = CGPoint(x:self.bounds.size.width/4.0, y:self.bounds.size.height-80)
        selfBtn.frame = CGRect(x:0, y:0, width:50, height:60)
        selfBtn.center = CGPoint(x:self.bounds.size.width*3/4.0, y:self.bounds.size.height-80)
        
//        cancelBtn.bounds = CGRect(x:0, y:0, width:71, height:30)
//        cancelBtn.center = CGPoint(x:self.bounds.size.width/2.0-20-71/2.0, y:self.bounds.size.height-30)
        submitBtn.bounds = CGRect(x:0, y:0, width:71, height:30)
        submitBtn.center = CGPoint(x:self.bounds.size.width/2.0, y:self.bounds.size.height-30)
    }

}
