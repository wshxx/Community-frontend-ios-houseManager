//
//  XHWLCodeTF.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLCodeTF: UIView, UITextFieldDelegate {
    
    var funcBackBlock : (String) -> () = {param in }
    var onSendCodeClickBlock : () -> () = {param in }
    var sendCodeBtn:UIButton!
    var textField: UITextField!
    var lineIV : UIImageView!
    
    init(frame: CGRect, placeholder:String) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        textField = UITextField(frame: CGRect(x:0, y:0, width:self.bounds.width-100, height:30))
        textField.textColor = color_c8e5f0
        let placeholderAttr:NSMutableAttributedString = NSMutableAttributedString.init(string: placeholder)
        placeholderAttr.addAttribute(NSForegroundColorAttributeName, value: color_c8e5f0, range: NSMakeRange(0, placeholder.characters.count))
        placeholderAttr.addAttribute(NSFontAttributeName, value: font_15, range: NSMakeRange(0, placeholder.characters.count))
        textField.attributedPlaceholder = placeholderAttr
        textField.font = font_15
        textField.tintColor = color_c8e5f0
        textField.delegate = self
        textField.clearsOnBeginEditing = true
        
        let leftV:UIView = UIView(frame: CGRect(x:0, y:0, width:30, height:30))
        textField.leftView = leftV
        textField.leftViewMode = UITextFieldViewMode.always
        
        let rightV:UIView = UIView()
        rightV.frame = CGRect(x:0, y:0, width:12.5, height:12.5)
        let imgBtn:UIButton = UIButton()
        imgBtn.frame = rightV.bounds
        imgBtn.setImage(UIImage(named:"login_textfield_clear"), for: UIControlState.normal)
        imgBtn.addTarget(self, action: #selector(XHWLCodeTF.onClear), for: UIControlEvents.touchUpInside)
        rightV.addSubview(imgBtn)
        textField.rightView = rightV
        textField.rightViewMode = UITextFieldViewMode.whileEditing
        self.addSubview(textField)
        
        sendCodeBtn = UIButton(frame: CGRect(x:self.bounds.width-90, y:0, width:80, height:30))
        sendCodeBtn.setTitle("发送验证码", for: UIControlState.normal)
        sendCodeBtn.setTitleColor(color_01f0ff, for: UIControlState.normal)
        sendCodeBtn.addTarget(self, action: #selector(onSendCodeClick), for: UIControlEvents.touchUpInside)
        sendCodeBtn.titleLabel?.font = font_15
        sendCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        self.addSubview(sendCodeBtn)
        
        lineIV = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        lineIV.frame = CGRect(x: 0, y: self.bounds.size.height-0.5, width: self.bounds.size.width, height: 0.5)
        self.addSubview(lineIV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = CGRect(x:0, y:0, width:self.bounds.width-100, height:self.bounds.size.height)
        sendCodeBtn.frame = CGRect(x:self.bounds.width-90, y:0, width:80, height:self.bounds.size.height)
        lineIV.frame = CGRect(x: 0, y: self.bounds.size.height-0.5, width: self.bounds.size.width, height: 0.5)
        
    }
    
    func onClear() {
        textField.text = ""
    }
    
    // 发送验证码
    func onSendCodeClick() {
       self.onSendCodeClickBlock()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(textField.text)")
        self.funcBackBlock(textField.text!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
