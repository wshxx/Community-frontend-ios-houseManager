//
//  XHWLPatroLabelView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/25.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPatroLabelView: UIView {
    
    var titleL:UILabel!
    var contentL:UILabel!
    var textAlignment:NSTextAlignment? {
        willSet {
            if (newValue != nil) {
                contentL.textAlignment = newValue as! NSTextAlignment
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        self.backgroundColor = UIColor.red
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.textAlignment = .right
        titleL.font = font_14
        self.addSubview(titleL)

        contentL = UILabel()
        contentL.font = font_14
        contentL.textColor = UIColor.white
        contentL.numberOfLines = 0
        contentL.textAlignment = NSTextAlignment(rawValue: 7)!
        self.addSubview(contentL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:0, y:0, width:80, height:font_14.lineHeight)
        
        let size:CGSize = contentL.text!.boundingRect(with: CGSize(width:self.bounds.size.width-titleL.frame.maxX-10, height:CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font_14], context: nil).size
        contentL.frame = CGRect(x: titleL.frame.maxX, y: 0, width: self.bounds.size.width-titleL.frame.maxX-10, height:size.height)
    }
    
    func showText(leftText:String, rightText:String) {
        titleL.text = leftText
        contentL.text = rightText
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
