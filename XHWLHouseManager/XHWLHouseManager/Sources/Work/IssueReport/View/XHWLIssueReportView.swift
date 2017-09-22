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
    var pickPhoto:XHWLPickPhotoView!
    var remark:XHWLRemarkView!
    var radioView: XHWLRadioView!
    var typeView: XHWLSelTypeView!
    var dotView: XHWLLabelView!
    var scanModel:XHWLScanModel! {
        willSet {
            if (newValue != nil) {
                dotView.showText(leftText: "巡检点位：", rightText:newValue.address)
            }
        }
    }
    var cancelBtn:UIButton!
    var submitBtn:UIButton!
    weak var delegate:XHWLIssueReportViewDelegate?
    var btnBlock:(String, String, String, String)->(Void) = { param in }
    var dismissBlock:()->() = {_ in }
    var radioIndex:String? = "是"
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
        
        typeView = XHWLSelTypeView()
        typeView.showText(leftText: "异常类型：", btnTitle:"工程")
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
        self.addSubview(typeView)
        
        
        
        dotView = XHWLLabelView()
        dotView.showText(leftText: "巡检点位：", rightText:"中海华庭水泵房")
        self.addSubview(dotView)
        
        remark = XHWLRemarkView()
        remark.showText("备注：")
        self.addSubview(remark)
        
        radioView = XHWLRadioView()
        radioView.showText(leftText: "紧急情况：", rightText: "是", btnTitle: "否")
        radioView.btnBlock = { [weak self] index in
            
            if index == 0 {
                self?.radioIndex = "是"
            } else {
                self?.radioIndex = "否"
            }
            
        }
        self.addSubview(radioView)
        
        pickPhoto = XHWLPickPhotoView(frame: CGRect.zero, false)
        pickPhoto.showText("上传照片：")
//        pickPhoto.isShow = false
        pickPhoto.addPictureBlock = { isAdd, index, isPictureAdd in
            self.delegate?.onSafeGuard!(isAdd, index, isPictureAdd)
        }
        self.addSubview(pickPhoto)
        
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
        
        typeView.frame = CGRect(x:10, y:10, width:self.bounds.size.width-20, height:20)
        dotView.frame = CGRect(x:10, y:typeView.frame.maxY+10, width:self.bounds.size.width-20, height:20)
        remark.frame = CGRect(x:10, y:dotView.frame.maxY+10, width:self.bounds.size.width-20, height:80)
        
        radioView.frame = CGRect(x:10, y:remark.frame.maxY+10, width:self.bounds.size.width-20, height:44)
        pickPhoto.frame = CGRect(x:10, y:radioView.frame.maxY+10, width:self.bounds.size.width-20, height:80)
        
        cancelBtn.frame = CGRect(x:50, y:self.bounds.size.height-60, width:71, height:30)
        submitBtn.frame = CGRect(x:self.bounds.size.width-50-71, y:self.bounds.size.height-60, width:71, height:30)
    }

}
