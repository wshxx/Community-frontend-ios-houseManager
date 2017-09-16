//
//  XHWLIssueReportView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLIssueReportViewDelegate:NSObjectProtocol {
    @objc optional func onSafeGuard(_ isAdd:Bool)
}

class XHWLIssueReportView: UIView {

    var bgImage:UIImageView!
    var titleL:UILabel!
    var pickPhoto:XHWLPickPhotoView!
    var remark:XHWLRemarkView!
    var radioView: XHWLRadioView!
    var typeView: XHWLLabelView!
    var dotView: XHWLLabelView!
    var cancelBtn:UIButton!
    var submitBtn:UIButton!
    var lineIV:UIImageView!
    weak var delegate:XHWLIssueReportViewDelegate?
    var btnBlock:(String, String, String, String)->(Void) = { param in }
    var dismissBlock:()->() = {_ in }
    var radioIndex:String?
    
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
        
        titleL = UILabel()
        titleL.textAlignment = NSTextAlignment.center
        titleL.textColor = color_09fbfe
        titleL.font = font_13
        titleL.text = "报事"
        self.addSubview(titleL)
        
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        self.addSubview(lineIV)
        
        typeView = XHWLLabelView()
        typeView.showText(leftText: "异常类型：", rightText:"工程")
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
        
        pickPhoto = XHWLPickPhotoView()
        pickPhoto.showText("上传照片：")
        pickPhoto.addPictureBlock = { isAdd in
            self.delegate?.onSafeGuard!(isAdd)
        }
        self.addSubview(pickPhoto)
        
        cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        cancelBtn.titleLabel?.font = font_12
        cancelBtn.tag = comTag
        cancelBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        self.addSubview(cancelBtn)
        
        submitBtn = UIButton()
        submitBtn.setTitle("提交", for: UIControlState.normal)
        submitBtn.setTitleColor(color_09fbfe, for: UIControlState.normal)
        submitBtn.titleLabel?.font = font_12
        submitBtn.tag = comTag+1
        submitBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
        submitBtn.addTarget(self, action: #selector(submitClick), for: UIControlEvents.touchUpInside)
        self.addSubview(submitBtn)
    }
    
    func submitClick(btn:UIButton) {
        
        if btn.tag - comTag == 0 {
            self.dismissBlock()
        } else {
            self.btnBlock(typeView.contentTF.text!, dotView.contentTF.text!, remark.textView.text!, radioIndex!)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImage.frame = self.bounds
        
        titleL.frame = CGRect(x:10, y:10, width:self.bounds.size.width-20, height:44)
        lineIV.frame = CGRect(x:10, y:titleL.frame.maxY, width:self.bounds.size.width-20, height:0.5)
        typeView.frame = CGRect(x:10, y:lineIV.frame.maxY+10, width:self.bounds.size.width-20, height:20)
        dotView.frame = CGRect(x:10, y:typeView.frame.maxY+10, width:self.bounds.size.width-20, height:20)
        remark.frame = CGRect(x:10, y:dotView.frame.maxY+10, width:self.bounds.size.width-20, height:80)
        
        radioView.frame = CGRect(x:10, y:remark.frame.maxY+10, width:self.bounds.size.width-20, height:44)
        pickPhoto.frame = CGRect(x:10, y:radioView.frame.maxY+10, width:self.bounds.size.width-20, height:80)
        
        cancelBtn.frame = CGRect(x:50, y:self.bounds.size.height-60, width:71, height:30)
        submitBtn.frame = CGRect(x:self.bounds.size.width-50-71, y:self.bounds.size.height-60, width:71, height:30)
    }

}
