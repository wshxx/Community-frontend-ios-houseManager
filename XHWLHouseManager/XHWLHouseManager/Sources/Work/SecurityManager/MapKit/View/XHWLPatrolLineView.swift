//
//  XHWLPatrolLineView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/24.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPatrolLineView: UIView {

    var timeL:UILabel!
    var stateL:UILabel!
    var stateIV:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    func setupView() {
        
        timeL = UILabel()
        timeL.textColor = UIColor.white
        timeL.font = font_14
        timeL.text = "07:00-09:00"
        self.addSubview(timeL)

        stateL = UILabel()
        stateL.font = font_14
        stateL.text = "1个未检点、1个异常点"
        stateL.textColor = UIColor.red
        self.addSubview(stateL)
        
        stateIV = UIImageView()
        stateIV.isHidden = true
        stateIV.image = UIImage(named:"Patrol_finished")
        self.addSubview(stateIV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        timeL.frame = CGRect(x:0, y:0, width:85, height:self.bounds.size.height)
//        stateL.frame = CGRect(x: timeL.frame.maxX+5, y: 0, width: self.bounds.size.width-timeL.frame.maxX-15, height:self.bounds.size.height)
       
        timeL.frame = CGRect(x:0, y:0, width:85, height:font_14.lineHeight)
        stateL.frame = CGRect(x: timeL.frame.maxX, y: 0, width: self.bounds.size.width-timeL.frame.maxX, height:font_14.lineHeight)
        stateIV.bounds = CGRect(x:0, y: 0, width: 14, height:14)
        stateIV.center = CGPoint(x: timeL.frame.maxX+5+7, y: font_14.lineHeight/2.0)
    }
    
    func showText(leftText:String, rightText:String) {
        timeL.text = leftText
        stateL.text = rightText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
