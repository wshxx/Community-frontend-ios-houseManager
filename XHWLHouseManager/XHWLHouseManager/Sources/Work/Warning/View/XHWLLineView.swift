//
//  XHWLLineView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/20.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLLineView: UIView {

    var titleL:UILabel!
    var contentL:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
//    func contentTextAlign(textAlignment: NSTextAlignment) {
//        
//        contentTF.textAlignment = textAlignment
//    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_12
        self.addSubview(titleL)
        
        contentL = UILabel()
        contentL.font = font_12
        contentL.textColor = UIColor.white
        contentL.numberOfLines = 0
        self.addSubview(contentL)
    }
    
    func heightWithSize() -> CGFloat {

        let sizeL:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
        let sizeR:CGSize = contentL.text!.boundingRect(with: CGSize(width:CGFloat(self.bounds.size.width-sizeL.width-20), height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:contentL.font], context: nil).size
        
        return sizeR.height + 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
        
        titleL.frame = CGRect(x:10, y:5, width:size.width, height:size.height)
        contentL.frame = CGRect(x: titleL.frame.maxX+10, y: 5, width: self.bounds.size.width-titleL.frame.size.width-10, height: self.bounds.size.height-10)
    }
    
    func showText(leftText:String, rightText:String) {
        titleL.text = leftText
        contentL.text = rightText
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
