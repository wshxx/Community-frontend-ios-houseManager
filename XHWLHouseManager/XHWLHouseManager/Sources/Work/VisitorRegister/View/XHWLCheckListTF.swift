//
//  XHWLCheckListTF.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

enum XHWLCheckListTFEnum : Int{
    case left = 0
    case right
}

class XHWLCheckListTF: UIView, UITextFieldDelegate {

    var titleL:UILabel!
    var contentTF:UITextField!
    var listBtn:XHWLButton!
    var checkEnum:XHWLCheckListTFEnum!
    var btnBlock:()->(Void) = { param in }
    var textEndBlock:(String)->() = {param in }
    
    init(frame: CGRect , checkListEnum:XHWLCheckListTFEnum) {
        super.init(frame: frame)
        
        checkEnum = checkListEnum
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_14
        self.addSubview(titleL)
        
        contentTF = UITextField()
        contentTF.delegate = self
        contentTF.background = UIImage(named:"check_textfield_bg")
        contentTF.font = font_14
        contentTF.textColor = UIColor.white
        contentTF.tintColor = color_c8e5f0
        contentTF.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:10))
        contentTF.leftViewMode = UITextFieldViewMode.always
        //        contentTF.backgroundColor = UIColor.red
        self.addSubview(contentTF)
        
        listBtn = XHWLButton()
        listBtn.addTarget(self, action: #selector(onListTouchClick), for: UIControlEvents.touchUpInside)
        self.addSubview(listBtn)
    }
    
    func onListTouchClick() {
        self.btnBlock()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textEndBlock(textField.text!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
        
        titleL.frame = CGRect(x:10, y:0, width:size.width, height:30)
        
        if checkEnum == XHWLCheckListTFEnum.right {
            
            listBtn.frame = CGRect(x:self.bounds.size.width-100-10, y:0, width:100, height:30)
            contentTF.frame = CGRect(x: titleL.frame.maxX+10, y: 0, width: self.bounds.size.width-titleL.frame.maxX-127, height: 30)
            
        } else {
            listBtn.frame = CGRect(x:titleL.frame.maxX+10, y:0, width:100, height:30)
            contentTF.frame = CGRect(x: listBtn.frame.maxX+5, y: 0, width: self.bounds.size.width-listBtn.frame.maxX-20, height: 30)
            
        }
    }
    
    func showText(leftText:String, rightText:String, btnTitle:String) {
        titleL.text = leftText
        contentTF.text = rightText
        listBtn.showBtnTitle(btnTitle)
    }
    
    func showBtnTitle(_ btnTitle:String) {
        listBtn.showBtnTitle(btnTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
