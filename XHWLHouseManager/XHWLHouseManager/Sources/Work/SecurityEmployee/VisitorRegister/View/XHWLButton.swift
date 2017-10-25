//
//  XHWLButton.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/22.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLButton: UIButton {

    var titleL:UILabel!
    var imageV:UIImageView!
    var btnBlock:()->(Void) = { param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        self.setBackgroundImage(UIImage(named:"menu_text_bg"), for: UIControlState.normal)
//        self.addTarget(self, action: #selector(onListTouchClick), for: UIControlEvents.touchUpInside)
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_14
        titleL.numberOfLines = 0
        titleL.textColor = color_09fbfe
        titleL.textAlignment = .center
        self.addSubview(titleL)
        
        imageV = UIImageView()
        imageV.image = UIImage(named:"home_switch")!
        self.addSubview(imageV)
    }
    
//    func onListTouchClick() {
//        self.btnBlock()
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let image:UIImage = UIImage(named:"home_switch")!
        
        imageV.frame = CGRect(x:(self.frame.size.width-image.size.width-5), y:(self.frame.size.height-image.size.height)/2.0, width:image.size.width, height:image.size.height)
        titleL.frame = CGRect(x:5, y:0, width:self.bounds.size.width-image.size.width-15, height:self.bounds.size.height)
    }
    
    func showBtnTitle(_ btnTitle:String) {
        self.titleL.text = btnTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
