//
//  XHWLMoreListView.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/9/11.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

class XHWLMoreListView: UIView {

    var labelView:XHWLCheckTF!
    var phoneView:XHWLCheckTF!
    var cardView:XHWLCheckTF!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView() {
        
        labelView = XHWLCheckTF()
        labelView.showText(leftText: "业主：", rightText:"")
        self.addSubview(labelView)
        
        phoneView = XHWLCheckTF()
        phoneView.showText(leftText: "房间：", rightText:"")
        self.addSubview(phoneView)
        
        cardView = XHWLCheckTF()
        cardView.showText(leftText: "事由：", rightText:"")
        self.addSubview(cardView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        labelView.bounds = CGRect(x:0, y:0, width:258, height:20)
        labelView.center = CGPoint(x:self.frame.size.width/2.0, y:30)
        
        phoneView.bounds = CGRect(x:0, y:0, width:258, height:20)
        phoneView.center = CGPoint(x:self.frame.size.width/2.0, y:labelView.frame.maxY+30)
        
        
        cardView.bounds = CGRect(x:0, y:0, width:258, height:20)
        cardView.center = CGPoint(x:self.frame.size.width/2.0, y:phoneView.frame.maxY+30)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
