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
        var listBtn:UIButton!
        var img: UIImageView!
        var btnBlock:()->(Void) = { param in }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupView()
        }
        
        func setupView() {
            
            titleL = UILabel()
            titleL.textColor = UIColor.white
            titleL.font = font_12
            self.addSubview(titleL)
            
            listBtn = UIButton()
            listBtn.setBackgroundImage(UIImage(named:"btn_background"), for: UIControlState.normal)
//            let image:UIImage = UIImage(named:"home_switch")!
//            listBtn.setImage(image, for: UIControlState.normal)
            listBtn.titleLabel?.font = font_12
            listBtn.titleLabel?.textColor = color_09fbfe
            listBtn.addTarget(self, action: #selector(onListTouchClick), for: UIControlEvents.touchUpInside)
            self.addSubview(listBtn)
            
            img = UIImageView()
            img.image = UIImage(named:"home_switch")!
            listBtn.addSubview(img)
        }
        
        func onListTouchClick() {
            self.btnBlock()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
            
            titleL.frame = CGRect(x:10, y:0, width:size.width, height:30)
            listBtn.frame = CGRect(x: titleL.frame.maxX+10, y: 0, width: self.bounds.size.width-titleL.frame.size.width-30, height: 30)
            
            let image:UIImage = UIImage(named:"home_switch")!
//            let titleW:CGFloat = (listBtn.titleLabel?.bounds.size.width)!
//            listBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleW-image.size.width-14)
//            listBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -image.size.width-titleW, bottom: 0, right: 0)
            
            
            img.frame = CGRect(x:(listBtn.frame.size.width-image.size.width-10), y:(listBtn.frame.size.height-image.size.height)/2.0, width:image.size.width, height:image.size.height)
        }
        
        func showText(leftText:String, btnTitle:String) {
            titleL.text = leftText
            listBtn.setTitle(btnTitle, for: UIControlState.normal)
        }
        
        func showBtnTitle(_ btnTitle:String) {
            listBtn.setTitle(btnTitle, for: UIControlState.normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
