//
//  XHWLPatrolStateView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/24.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLPatrolStateView: UIView {

    var titleL:UILabel!
    var lineView:XHWLPatrolLineView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    func setupView() {
        
        titleL = UILabel()
        titleL.textColor = UIColor.white
        titleL.text = "工作时间："
        titleL.textAlignment = .right
        titleL.font = font_14
        self.addSubview(titleL)
        
        lineView = XHWLPatrolLineView()
        self.addSubview(lineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleL.frame = CGRect(x:0, y:0, width:80, height:font_14.lineHeight)
        lineView.frame = CGRect(x: titleL.frame.maxX, y: 0, width:self.bounds.size.width-titleL.frame.maxX, height:self.bounds.size.height)
    }
    
    func showText(leftText:String, rightText:String) {
        titleL.text = leftText
//        lineView.text = rightText
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
