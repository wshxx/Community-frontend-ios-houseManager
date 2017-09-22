//
//  XHWLRadioView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLRadioView: UIView {

    var titleL:UILabel!
    var leftBtn:UIButton!
    var rightBtn:UIButton!
    var selectBtn:UIButton!
    var btnBlock:(NSInteger)->(Void) = { param in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.font = font_14
        titleL.text = "业主认证："
        self.addSubview(titleL)
        
        leftBtn = UIButton()
        leftBtn.setImage(UIImage(named:"radio_normal"), for: UIControlState.normal)
        leftBtn.setImage(UIImage(named:"radio_selected"), for: UIControlState.selected)
        leftBtn.titleLabel?.font = font_14
        leftBtn.tag = comTag
        leftBtn.titleLabel?.textColor = UIColor.white
        leftBtn.addTarget(self, action: #selector(onClick), for: UIControlEvents.touchUpInside)
        leftBtn.setTitle("是", for: UIControlState.normal)
        leftBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0)
        self.addSubview(leftBtn)
        
        rightBtn = UIButton()
        rightBtn.setImage(UIImage(named:"radio_normal"), for: UIControlState.normal)
        rightBtn.setImage(UIImage(named:"radio_selected"), for: UIControlState.selected)
        rightBtn.titleLabel?.font = font_14
        rightBtn.tag = comTag+1
        rightBtn.titleLabel?.textColor = UIColor.white
        rightBtn.addTarget(self, action: #selector(onClick), for: UIControlEvents.touchUpInside)
        rightBtn.setTitle("否", for: UIControlState.normal)
        rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0)
        self.addSubview(rightBtn)
        
        selectBtn = leftBtn
        selectBtn.isSelected = true
    }
    
    func onClick(btn:UIButton) {
        selectBtn.isSelected = false
        selectBtn = btn
        btn.isSelected = true
        self.btnBlock(btn.tag-comTag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let size:CGSize = titleL.text!.boundingRect(with: CGSize(width:CGFloat(MAXFLOAT), height:30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:titleL.font], context: nil).size
        
        titleL.frame = CGRect(x:10, y:0, width:size.width, height:30)
        
        leftBtn.frame = CGRect(x:titleL.frame.maxX+10, y:0, width:60, height:30)
        rightBtn.frame = CGRect(x: leftBtn.frame.maxX+10, y: 0, width: 60, height: 30)
    }
    
    func showText(leftText:String, rightText:String, btnTitle:String) {
        titleL.text = leftText
        leftBtn.setTitle(rightText, for: UIControlState.normal)
        rightBtn.setTitle(btnTitle, for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
