//
//  XHWLIssueReportView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLIssueReportViewDelegate:NSObjectProtocol {
    @objc optional func onSafeGuard(_ isAdd:Bool, _ index:NSInteger, _ isPictureAdd:Bool)
}

class XHWLIssueReportView: UIView {

    var bgImage:UIImageView!
    var bgSc:UIScrollView!
    var pickPhoto:XHWLPickPhotoView!
    var remark:XHWLRemarkView!
    var radioView: XHWLRadioView!
    var typeView: XHWLSelTypeView!
    var dotView: XHWLLabelView!
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
    var btnBlock:(String, String, String, String)->(Void) = { param in }
    var dismissBlock:()->() = {_ in }
    var radioIndex:String? = "否"
    var type:String! = "工程"
    
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
        typeView.showText("异常类型", "工程", false)
        typeView.btnBlock = { [weak typeView] in
            self.endEditing(true)
            let array:NSArray = ["工程", "环境", "客服", "安防"]
            let pickerView:XHWLPickerView = XHWLPickerView(frame:CGRect.zero, array:array)
            
            let window: UIWindow = (UIApplication.shared.keyWindow)!
            pickerView.dismissBlock = { [weak pickerView] (index)->() in
                print("\(index)")
                if index != -1 {
                    self.type = array[index] as! String
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
                self?.radioIndex = "是"
            } else {
                self?.radioIndex = "否"
            }
            
        }
        bgSc.addSubview(radioView)
        
        pickPhoto = XHWLPickPhotoView(frame: CGRect.zero, false)
        pickPhoto.showText("上传照片：")
//        pickPhoto.isShow = false
        pickPhoto.addPictureBlock = { isAdd, index, isPictureAdd in
            self.delegate?.onSafeGuard!(isAdd, index, isPictureAdd)
        }
        bgSc.addSubview(pickPhoto)
        
        cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        cancelBtn.titleLabel?.font = font_14
        cancelBtn.tag = comTag
        cancelBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        self.addSubview(cancelBtn)
        
        submitBtn = UIButton()
        submitBtn.setTitle("提交", for: UIControlState.normal)
        submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        submitBtn.titleLabel?.font = font_14
        submitBtn.tag = comTag+1
        submitBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        self.addSubview(submitBtn)
    }

    func submitClick(btn:UIButton) {
        
        if btn.tag - comTag == 0 {
            self.dismissBlock()
        } else {
//            if type.isEmpty {
//                "异常类型为空".ext_debugPrintAndHint()
//                return
//            }
//            if remark.textView.text.isEmpty {
//                "异常类型为空".ext_debugPrintAndHint()
//                return
//            }
            self.btnBlock(self.type!, dotView.contentTF.text! ?? "", remark.textView.text! ?? "", radioIndex!)
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
        
        cancelBtn.bounds = CGRect(x:0, y:0, width:71, height:30)
        cancelBtn.center = CGPoint(x:self.bounds.size.width/2.0-20-71/2.0, y:self.bounds.size.height-30)
        submitBtn.bounds = CGRect(x:0, y:0, width:71, height:30)
        submitBtn.center = CGPoint(x:self.bounds.size.width/2.0+20+71/2.0, y:self.bounds.size.height-30)
    }

}
