//
//  XHWLLabelView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/9.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLLabelView: UIView {

    var titleL:UILabel!
    var contentTF:UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func contentTextAlign(_ textAlignment: NSTextAlignment) {
        
        contentTF.textAlignment = textAlignment
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.textAlignment = .right
        titleL.font = font_14
        self.addSubview(titleL)
        
        contentTF = UITextField()
        contentTF.font = font_14
        contentTF.textColor = UIColor.white
        contentTF.backgroundColor = UIColor.clear
        contentTF.isEnabled = false
        self.addSubview(contentTF)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        titleL.frame = CGRect(x:10, y:0, width:80, height:30)
        contentTF.frame = CGRect(x: titleL.frame.maxX, y: 0, width: self.bounds.size.width-titleL.frame.size.width-20, height: 30)
        
//        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
//        
//        titleL.frame = CGRect(x:10, y:0, width:size.width, height:30)
//        contentTF.frame = CGRect(x: titleL.frame.maxX+10, y: 0, width: self.bounds.size.width-titleL.frame.size.width-30, height: 30)
    }
    
    func showText(leftText:String, rightText:String) {
        titleL.text = leftText
        contentTF.text = rightText
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
