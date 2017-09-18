//
//  XHWLCheckTF.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/10.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLCheckTF: UIView, UITextFieldDelegate {

    var titleL:UILabel!
    var contentTF:UITextField!
    var textEndBlock:(String)->() = {param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
//        contentTF.rightView = UIImageView.init(image: UIImage(named:"home_switch"))
//        contentTF.rightViewMode = UITextFieldViewMode.always
//        contentTF.backgroundColor = UIColor.red
        self.addSubview(contentTF)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
        
        titleL.frame = CGRect(x:10, y:0, width:size.width, height:30)
        contentTF.frame = CGRect(x: titleL.frame.maxX+10, y: 0, width: self.bounds.size.width-titleL.frame.size.width-30, height: 30)
    }
    
    func showText(leftText:String, rightText:String) {
        titleL.text = leftText
        contentTF.text = rightText
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textEndBlock(textField.text!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
