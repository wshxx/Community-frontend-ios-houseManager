//
//  XHWLSelTypeView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/18.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLSelTypeView: UIView {
        
        var titleL:UILabel!
        var listBtn:XHWLButton!
        var img: UIImageView!
        var btnBlock:()->(Void) = { param in }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupView()
        }
        
        func setupView() {
            
            titleL = UILabel()
            titleL.textColor = UIColor.white
            titleL.font = font_14
            self.addSubview(titleL)
            
            listBtn = XHWLButton()
            listBtn.addTarget(self, action: #selector(onListTouchClick), for: UIControlEvents.touchUpInside)
            self.addSubview(listBtn)
            
        }
        
        func onListTouchClick() {
            self.btnBlock()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
            
            titleL.frame = CGRect(x:10, y:0, width:size.width, height:30)
            listBtn.frame = CGRect(x: titleL.frame.maxX+10, y: 0, width: self.bounds.size.width-titleL.frame.size.width-30, height: 30)
        }
        
    func showText(_ leftText:String, _ btnTitle:String, _ isNeed:Bool) {
            if isNeed {
                let attr:NSMutableAttributedString = NSMutableAttributedString.init(string: "* \(leftText):", attributes: [NSForegroundColorAttributeName: UIColor.white])
                attr.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSMakeRange(0, 1))
                titleL.attributedText = attr
            } else {
                titleL.text = "  \(leftText):"
            }
            listBtn.showBtnTitle(btnTitle)
        }
        
        func showBtnTitle(_ btnTitle:String) {
            
            listBtn.showBtnTitle(btnTitle)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
