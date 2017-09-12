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
    
    init(frame: CGRect, placeholder:String) {
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
        
        let rightV:UIView = UIView(frame: CGRect(x:0, y:0, width:100, height:30))
        let sendCodeBtn:UIButton = UIButton(frame: CGRect(x:0, y:0, width:100, height:30))
        sendCodeBtn.setTitle("发送验证码", for: UIControlState.normal)
        sendCodeBtn.setTitleColor(color_01f0ff, for: UIControlState.normal)
        sendCodeBtn.center = CGPoint(x: 15, y: 15)
        sendCodeBtn.titleLabel?.font = font_15
        sendCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        rightV.addSubview(sendCodeBtn)
        textField.rightView = rightV
        textField.rightViewMode = UITextFieldViewMode.always
        self.addSubview(textField)
        
        let lineIV : UIImageView = UIImageView()
        lineIV.image = UIImage(named: "warning_cell_line")
        lineIV.frame = CGRect(x: 0, y: self.bounds.size.height-0.5, width: self.bounds.size.width, height: 0.5)
        self.addSubview(lineIV)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(textField.text)")
        self.funcBackBlock(textField.text!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
