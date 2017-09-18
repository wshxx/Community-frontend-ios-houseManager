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
    var listBtn:UIButton!
    var checkEnum:XHWLCheckListTFEnum!
    var img: UIImageView!
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
        titleL.font = font_12
        self.addSubview(titleL)
        
        contentTF = UITextField()
        contentTF.delegate = self
        contentTF.background = UIImage(named:"check_textfield_bg")
        contentTF.font = font_12
        contentTF.textColor = UIColor.white
        contentTF.tintColor = color_c8e5f0
        contentTF.leftView = UIView(frame: CGRect(x:0, y:0, width:5, height:10))
        contentTF.leftViewMode = UITextFieldViewMode.always
        //        contentTF.backgroundColor = UIColor.red
        self.addSubview(contentTF)
        
        listBtn = UIButton()
        listBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
//        let image:UIImage = UIImage(named:"home_switch")!
//        listBtn.setImage(image, for: UIControlStateaqxswxd.normal)
        listBtn.titleLabel?.font = font_12
        listBtn.titleLabel?.textColor = color_09fbfe
        listBtn.addTarget(self, action: #selector(onListTouchClick), for: UIControlEvents.touchUpInside)
        self.addSubview(listBtn)
        
        img = UIImageView()
        img.image = UIImage(named:"home_switch")!
        listBtn.addSubview(img)
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
        
        let image:UIImage = UIImage(named:"home_switch")!
//        let titleW:CGFloat = (listBtn.titleLabel?.bounds.size.width)!
//        listBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleW-image.size.width-14)
//        listBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -image.size.width-titleW, bottom: 0, right: 0)
        
        img.frame = CGRect(x:(listBtn.frame.size.width-image.size.width-10), y:(listBtn.frame.size.height-image.size.height)/2.0, width:image.size.width, height:image.size.height)
    }
    
    func showText(leftText:String, rightText:String, btnTitle:String) {
        titleL.text = leftText
        contentTF.text = rightText
        listBtn.setTitle(btnTitle, for: UIControlState.normal)
    }
    
    func showBtnTitle(_ btnTitle:String) {
        listBtn.setTitle(btnTitle, for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
