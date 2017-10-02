//
//  XHWLMenuLabelView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/8.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

@objc protocol XHWLMenuLabelViewDelegate:NSObjectProtocol {
    @objc optional func menuLabel(_ labelView:XHWLMenuLabelView, _ text:String, _ block:@escaping ((Bool)->()))
}

class XHWLMenuLabelView: UIView {

    var titleL:UILabel!
    var contentTF:UITextField!
    var rightBtn:UIButton!
    var okBtn:UIButton!
    var isShowEdit:Bool! = false
    var isHiddenEdit:Bool! = false
    var labelBgIV:UIImageView!
    var delegate:XHWLMenuLabelViewDelegate?
    var onOKClickBlock : (String, ((Bool) -> ())) -> () = {param in }
    var contentStr:String?
    var isClickOk:Bool! = false
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setupView()
//    }
    
    init(frame: CGRect, _ isShowEdit:Bool) {
        super.init(frame: frame)
        
        self.isShowEdit = isShowEdit
         setupView()
    }
    
    func isHiddenImg() {
        
        labelBgIV.isHidden = true
    }
    
    func setupView() {
        labelBgIV = UIImageView()
        labelBgIV.image = UIImage(named:"menu_text_bg")
        self.addSubview(labelBgIV)
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_14
        self.addSubview(titleL)
        
        contentTF = UITextField()
        contentTF.font = font_14
        contentTF.textColor = UIColor.white
        contentTF.backgroundColor = UIColor.clear
        contentTF.textAlignment = NSTextAlignment.left
        contentTF.isEnabled = false
        contentTF.tintColor = color_c8e5f0
        
        let leftV:UIView = UIView(frame: CGRect(x:0, y:0, width:5, height:20))
        contentTF.leftView = leftV
        contentTF.leftViewMode = UITextFieldViewMode.always
        self.addSubview(contentTF)
        
        if isShowEdit {
            okBtn = UIButton()
            okBtn.setTitle("确定", for: UIControlState.normal)
            okBtn.setTitleColor(UIColor().colorWithHexString(colorStr: "3cf8ff"), for: UIControlState.normal)
            okBtn.isHidden = true
            okBtn.titleLabel?.font = font_14
            okBtn.addTarget(self, action: #selector(onOkClick), for: UIControlEvents.touchUpInside)
            self.addSubview(okBtn)
            
            rightBtn = UIButton()
            rightBtn.setImage(UIImage(named:"menu_edit"), for: UIControlState.normal)
            rightBtn.setTitle("", for: UIControlState.normal)
            rightBtn.titleLabel?.font = font_14
            rightBtn.setTitleColor(UIColor().colorWithHexString(colorStr: "3cf8ff"), for: UIControlState.normal)
            rightBtn.isHidden = isHiddenEdit
            rightBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            rightBtn.addTarget(self, action: #selector(onEdit), for: UIControlEvents.touchUpInside)
            self.addSubview(rightBtn)
        }
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelBgIV.frame = self.bounds
        
        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
        
        titleL.frame = CGRect(x:5, y:0, width:size.width, height:30)
        if isShowEdit {
            contentTF.frame = CGRect(x: titleL.frame.maxX+10, y: 2, width: 100, height: 26)
            okBtn.frame = CGRect(x:self.frame.size.width-80, y:4, width:50, height:22)
            rightBtn.frame = CGRect(x:self.frame.size.width-40, y:4, width:40, height:22)
        } else {
            contentTF.frame = CGRect(x: titleL.frame.maxX+10, y: 2, width: self.bounds.size.width-titleL.frame.maxX-20, height: 26)
        }
    }
    
    func showText(leftText:String, rightText:String, isHiddenEdit:Bool) {
        titleL.text = leftText
        contentTF.text = rightText
        contentStr = rightText
        if isShowEdit {
            rightBtn.isHidden = isHiddenEdit
            //        okBtn.isHidden = isHiddenEdit
        }
    }
    
    // 确定
    func onOkClick() {
        isClickOk = true
        self.delegate?.menuLabel!(self, contentTF.text!, {[weak self] (isTrue) in
            if isTrue {
                
                self?.onCancel((self?.rightBtn)!)
            }
        })
//        self.onOKClickBlock(contentTF.text!, {_ in 
//            
//        })
    }
    
    func onEdit(btn:UIButton) {
        isClickOk = false
        onCancel(btn)
    }
    
    func onCancel(_ btn:UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            okBtn.isHidden = false
            contentTF.isEnabled = true
            contentTF.backgroundColor = UIColor().colorWithHexString(colorStr: "1e2b36")
            rightBtn.setImage(UIImage(named:""), for: UIControlState.normal)
            rightBtn.setTitleColor(UIColor().colorWithHexString(colorStr: "3cf8ff"), for: UIControlState.normal)
            rightBtn.setTitle("取消", for: UIControlState.normal)
        } else {
            
            okBtn.isHidden = true
            contentTF.isEnabled = false
            contentTF.backgroundColor = UIColor.clear
            rightBtn.setTitle("", for: UIControlState.normal)
            rightBtn.setImage(UIImage(named:"menu_edit"), for: UIControlState.normal)
            if isClickOk == false {
                contentTF.text = contentStr
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
