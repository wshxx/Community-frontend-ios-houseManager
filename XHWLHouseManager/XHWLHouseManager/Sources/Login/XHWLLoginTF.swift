//
//  XHWLLoginTF.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/8/30.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

enum XHWLLoginTFEnum : Int{
    case user = 0
    case password
}

class XHWLLoginTF: UIView, UITextFieldDelegate {

    var funcBackBlock : (String) -> () = {param in }
    
    init(frame: CGRect , loginEnum:XHWLLoginTFEnum, placeholder:String) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let textField: UITextField = UITextField(frame: CGRect(x:0, y:0, width:self.bounds.width, height:30))
        textField.textColor = color_c8e5f0
        let placeholderAttr:NSMutableAttributedString = NSMutableAttributedString.init(string: placeholder)
       placeholderAttr.addAttribute(NSForegroundColorAttributeName, value: color_c8e5f0, range: NSMakeRange(0, placeholder.characters.count))
        placeholderAttr.addAttribute(NSFontAttributeName, value: font_15, range: NSMakeRange(0, placeholder.characters.count))
        textField.attributedPlaceholder = placeholderAttr
        textField.font = font_15
        textField.tintColor = color_c8e5f0
        textField.delegate = self
        
        let leftV:UIView = UIView(frame: CGRect(x:0, y:0, width:30, height:30))
        let bgIV:UIImageView = UIImageView(frame: CGRect(x:0, y:(30-13)/2.0, width:11, height:13))
        if XHWLLoginTFEnum.user == loginEnum {
            bgIV.image = UIImage(named: "xhwl_login_person")
        } else if XHWLLoginTFEnum.password == loginEnum {
            bgIV.image = UIImage(named: "xhwl_login_password")
        }
        bgIV.center = CGPoint(x: 15, y: 15)
        leftV.addSubview(bgIV)
        textField.leftView = leftV
        textField.leftViewMode = UITextFieldViewMode.always
        self.addSubview(textField)
        
        let lineIV : UIImageView = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        lineIV.frame = CGRect(x: 0, y: self.bounds.size.height-0.5, width: self.bounds.size.width, height: 0.5)
        self.addSubview(lineIV)
        
//        let lineL: UIImageView = SpaceLineSetup(view: self, color: color_f2f2f2)
//        self.addSubview(lineL)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(textField.text)")
        self.funcBackBlock(textField.text!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
