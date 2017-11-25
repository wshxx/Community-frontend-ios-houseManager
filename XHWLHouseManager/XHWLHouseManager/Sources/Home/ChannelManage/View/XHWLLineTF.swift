//
//  XHWLLineTF.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/11/20.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLLineTF: UIView , UITextFieldDelegate {

    var titleL:UILabel!
    var nameTF:UITextField!
    var lineL:UILabel!
    var endEditBlock:(String)->() = { param in }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.clear
        
        titleL = UILabel()
        titleL?.text = "频道名称"
        titleL?.font = UIFont.systemFont(ofSize: 14)
        titleL?.textColor = UIColor.white
        titleL?.textAlignment = .left
        self.addSubview(titleL!)
        
        nameTF = UITextField()
        nameTF?.placeholder = "请输入频道名称"
        nameTF?.font = UIFont.systemFont(ofSize: 14)
        nameTF?.textColor = UIColor.white
        nameTF?.textAlignment = .right
        nameTF?.delegate = self
        self.addSubview(nameTF!)
        
        lineL = UILabel()
        lineL?.backgroundColor = UIColor.white
        self.addSubview(lineL!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditBlock(textField.text!)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:10, y:0, width:100, height:30)
        nameTF.frame = CGRect(x:titleL.frame.maxX+10, y:0, width:self.bounds.size.width-titleL.frame.maxX-30, height:30)
        lineL.frame = CGRect(x:0, y:self.bounds.size.height-0.5, width:self.bounds.size.width, height:0.5)
    }
}
