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
    case phone
}

class XHWLLoginTF: UIView, UITextFieldDelegate {

    var funcBackBlock : (String) -> () = {param in }
    var textField: UITextField!
    var lineIV : UIImageView!
    
    init(frame: CGRect , loginEnum:XHWLLoginTFEnum, placeholder:String) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        textField = UITextField(frame: CGRect(x:0, y:0, width:self.bounds.width, height:30))
        textField.textColor = color_c8e5f0
        let placeholderAttr:NSMutableAttributedString = NSMutableAttributedString.init(string: placeholder)
       placeholderAttr.addAttribute(NSForegroundColorAttributeName, value: color_c8e5f0, range: NSMakeRange(0, placeholder.characters.count))
        placeholderAttr.addAttribute(NSFontAttributeName, value: font_15, range: NSMakeRange(0, placeholder.characters.count))
        textField.attributedPlaceholder = placeholderAttr
        textField.font = font_15
        textField.tintColor = color_c8e5f0
        textField.delegate = self
        textField.clearsOnBeginEditing = true
        
        let rightV:UIView = UIView()
        rightV.frame = CGRect(x:0, y:0, width:12.5, height:12.5)
        let imgBtn:UIButton = UIButton()
        imgBtn.frame = rightV.bounds
        imgBtn.setImage(UIImage(named:"login_textfield_clear"), for: UIControlState.normal)
        imgBtn.addTarget(self, action: #selector(XHWLLoginTF.onClear), for: UIControlEvents.touchUpInside)
        rightV.addSubview(imgBtn)
        textField.rightView = rightV
        textField.rightViewMode = UITextFieldViewMode.whileEditing
        
        
        let leftV:UIView = UIView(frame: CGRect(x:0, y:0, width:30, height:30))
        let bgIV:UIImageView = UIImageView(frame: CGRect(x:0, y:(30-22)/2.0, width:12, height:22))
        bgIV.contentMode = .center
        if XHWLLoginTFEnum.user == loginEnum {
            bgIV.image = UIImage(named: "login_person")
        } else if XHWLLoginTFEnum.password == loginEnum {
            bgIV.image = UIImage(named: "login_password")
            textField.isSecureTextEntry = true
        } else if XHWLLoginTFEnum.phone == loginEnum {
            bgIV.image = UIImage(named: "login_phone")
        }
        bgIV.center = CGPoint(x: 15, y: 15)
        leftV.addSubview(bgIV)
        textField.leftView = leftV
        textField.leftViewMode = UITextFieldViewMode.always
        self.addSubview(textField)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        lineIV.frame = CGRect(x: 0, y: self.bounds.size.height-0.5, width: self.bounds.size.width, height: 0.5)
        self.addSubview(lineIV)
        
//        let lineL: UIImageView = SpaceLineSetup(view: self, color: color_f2f2f2)
//        self.addSubview(lineL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = CGRect(x:0, y:0, width:self.bounds.width, height:self.bounds.size.height)
        lineIV.frame = CGRect(x: 0, y: self.bounds.size.height-0.5, width: self.bounds.size.width, height: 0.5)
        
    }
    
    func onClear() {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(textField.text)")
        self.funcBackBlock(textField.text!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
